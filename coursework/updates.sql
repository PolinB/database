-- updateEvent
-- хорошо видно на изменениии EventId = 4
create or replace function checkChangeEventStatus() returns trigger 
as 
$checkChangeEventStatus$
begin
    if old.IsOpen = new.IsOpen
    then return new;
    else
        if old.IsOpen = false and new.IsOpen = true
        then 
            raise exception 'You can not open this event';
        else
            update 
                UserAchievements
            set 
                Value = UserAchievements.Value + EventAchievements.UpValue
            from
                EventAchievements
                natural join Volunteers
            where
                UserAchievements.UserId = Volunteers.UserId and
                UserAchievements.AchievementId = EventAchievements.AchievementId and
                EventId = new.EventId and
                IsParticipated = true;

        	insert into UserAchievements (UserId, AchievementId, Value)
                select
                    UserId, AchievementId, UpValue as Value
                from
                    EventAchievements
                    natural join Volunteers
                where
                    IsParticipated = true and
                    EventId = new.EventId
            on conflict (UserId, AchievementId)
            do nothing;
            return new;
        end if;
    end if;
end;
$checkChangeEventStatus$ language plpgsql;

create trigger updateEvent
    before update
    on Events
    for each row
execute procedure checkChangeEventStatus();

-- insertReplyComment
create or replace function checkReplyComment() returns trigger 
as 
$checkReplyComment$
begin
    if (select count(CommentId)
        from CommentReplies
        where CommentId = new.ReplyCommentId and ReplyCommentId = new.CommentId) <> 0
    then
        raise exception 'You can add reply comment to reply comment';
    else
        if (select SendTime
            from Comments
            where CommentId = new.ReplyCommentId) >
            (select SendTime
            from Comments
            where CommentId = new.CommentId)
        then
            raise exception 'You can add reply comment, because you send it before';
        else
            return new;
        end if;
    end if;
end;
$checkReplyComment$ language plpgsql;

create trigger insertReplyComment
    before insert
    on CommentReplies
    for each row
execute procedure checkReplyComment();

-- addEvent
-- select * from addEvent(1, '1234qwerty', 9, 'Add event test', 'New Event', '2021-05-01 18:00:00', '2021-05-01 19:30:00', 1);
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- простая вставка не тредует большего уровня, можем позволить себе Неповторяемое чтение
create or replace function addEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    eventNameArg varchar(50),
    descriptionArg text,
    startTimeArg timestamp,
    endTimeArg timestamp,
    townId int
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        startTimeArg < currentTime
    then
        return false;
    else
        insert into Events
        (EventId, EventName, Description, StartTime, EndTime, IsOpen, CreatorId, EventTownId) values
        (eventIdArg, eventNameArg, descriptionArg, startTimeArg, endTimeArg, true, userIdArg, townId);
        return true;
    end if;
end;
$$ language plpgsql;

-- sendMessage
-- select * from sendMessage (1, '1234qwerty', 11, 2, 'Hello');
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- простая вставка не тредует большего уровня, можем позволить себе Неповторяемое чтение
create or replace function sendMessage(
    userIdArg bigint, 
    pswdHashArg text,
    messageIdVal bigint,
    toUserIdArg bigint,
    messageArg text
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg)
    then
        return false;
    else
        insert into Messages
        (MessageId, MessageText, SendTime, FromUserId, ToUserId) values
        (messageIdVal, messageArg, currentTime, userIdArg, toUserIdArg);
        return true;
    end if;
end;
$$ language plpgsql;

-- sendComment
-- select * from sendComment (1, '1234qwerty', 3, 10, 'What we must do on this event?');
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- простая вставка не тредует большего уровня, можем позволить себе Неповторяемое чтение
create or replace function sendComment(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    commentIdVal bigint,
    commentTextArg text
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg)
    then
        return false;
    else
        insert into Comments
        (CommentId, CommentText, SendTime, EventId, UserId) values
        (commentIdVal, commentTextArg, currentTime, eventIdArg, userIdArg);
        return true;
    end if;
end;
$$ language plpgsql;


-- replyOnComment
-- select * from replyOnComment (1, '1234qwerty', 3, 3, 11, 'Reply comment');
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- хотя вставка происходит в 2 таблицы, важна лишь вставка в первую, во вторую она, с большой
-- вероятностью произойдет успешно после первой, так как отдельно никто не  добавляет в таблицу
-- CommentReplies, а значит значения с таким же Id не будет
create or replace function replyOnComment(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    replyCommentIdArg bigint,
    commentIdVal bigint,
    commentTextArg text
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg)
    then
        return false;
    else
        insert into Comments
        (CommentId, CommentText, SendTime, EventId, UserId) values
        (commentIdVal, commentTextArg, currentTime, eventIdArg, userIdArg);

        insert into CommentReplies
        (CommentId, ReplyCommentId) values
        (commentIdVal, replyCommentIdArg);
        return true;
    end if;
end;
$$ language plpgsql;

-- registrateVolunteer
-- select * from registrateVolunteer (1, '1234qwerty', 4);
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- уровень выше нам и не требуется, так как вставка происходит по ключу и максимум при
-- повторной регистрации выдастся ошибка
create or replace function registrateVolunteer(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        currentTime > (select EndTime from Events where EventId = eventIdArg)
    then
        return false;
    else
        insert into Volunteers
        (UserId, EventId, IsParticipated) values
        (userIdArg, eventIdArg, false);
        return true;
    end if;
end;
$$ language plpgsql;

-- askCancelParticipationByVolunteer
-- select * from askCancelParticipationByVolunteer(15, 'NSAZD2U0E9', 3, 12, 'I have an exam scheduled for this day');
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- поскольку операция изменения создателя события не предусмотрена, то Неповторяемое чтение нам походит
create or replace function askCancelParticipationByVolunteer(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    messageIdVal bigint,
    reasonArg text
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
    creatorIdVal bigint;
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        currentTime > (select StartTime from Events where EventId = eventIdArg)
    then
        return false;
    else
        creatorIdVal := (select CreatorId from Events where EventId = eventIdArg);
        insert into Messages
        (MessageId, MessageText, SendTime, FromUserId, ToUserId) values
        (messageIdVal, reasonArg, currentTime, userIdArg, creatorIdVal);
        return true;
    end if;
end;
$$ language plpgsql;

-- deleteVolunteerFromEvent
-- select * from deleteVolunteerFromEvent(5, 'ASM5415L7Y', 3, 15, 13, 'Event closed due to pandemic');
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- поскольку операция изменения Id пользователей не предусмотрена, то Неповторяемое чтение нам походит
create or replace function deleteVolunteerFromEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    volunteerIdArg bigint,
    messageIdVal bigint,
    messageArg text
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        currentTime > (select EndTime from Events where EventId = eventIdArg) or
        (select count(CreatorId) from Events where EventId = eventIdArg and CreatorId = userIdArg) = 0
    then
        return false;
    else
        delete from Volunteers where EventId = eventIdArg and UserId = volunteerIdArg;
        insert into Messages
        (MessageId, MessageText, SendTime, FromUserId, ToUserId) values
        (messageIdVal, messageArg, currentTime, userIdArg, volunteerIdArg);
        return true;
    end if;
end;
$$ language plpgsql;

-- addAchievementToEvent
-- select * from addAchievementToEvent(5, 'ASM5415L7Y', 2, 'karma', 2);
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- поскольку операция изменения Id пользователей не предусмотрена, то Неповторяемое чтение нам походит
create or replace function addAchievementToEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    achievementNameArg varchar(50),
    upValueArg int
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        (select count(CreatorId) from Events where EventId = eventIdArg and CreatorId = userIdArg and isOpen = true) = 0
    then
        return false;
    else
        insert into EventAchievements
            (EventId, AchievementId, UpValue)
        select
            eventIdArg, AchievementId, upValueArg
        from
            Achievements
        where
            Name = achievementNameArg;
        return true;
    end if;
end;
$$ language plpgsql;

-- markVolunteerInEvent
-- select * from markVolunteerInEvent(5, 'ASM5415L7Y', 3, 4);
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- так как происходит простой update, и не предусмотрено изменение ключей, то проблема с
-- Неповторяющимся чтением нам не страшна
create or replace function markVolunteerInEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint,
    volunteerIdArg bigint
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        (select count(CreatorId) from Events where EventId = eventIdArg and CreatorId = userIdArg and isOpen = true) = 0
    then
        return false;
    else
        update Volunteers
        set IsParticipated = true
        where
            userId = volunteerIdArg and
            EventId = eventIdArg;
        return true;
    end if;
end;
$$ language plpgsql;

-- markAllVolunteersInEvent
-- select * from markAllVolunteersInEvent(3, 'zxcvbnm098765431', 4);
-- уровень изоляции: read commited
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- так как происходит простой update, и не предусмотрено изменение ключей, то проблема с
-- Неповторяющимся чтением нам не страшна
create or replace function markAllVolunteersInEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        (select count(CreatorId) from Events where EventId = eventIdArg and CreatorId = userIdArg and isOpen = true) = 0
    then
        return false;
    else
        update Volunteers
        set IsParticipated = true
        where
            EventId = eventIdArg;
        return true;
    end if;
end;
$$ language plpgsql;

-- closeEvent
-- select * from closeEvent(3, 'zxcvbnm098765431', 4);
-- уровень изоляции: repeatable read
-- чтение незарегистрированных данных при проверке логина и пароля пользователя критично
-- поэтому позволить себе уровень ниже RC мы не можем
-- внутри происходит сложное обновление данных за счет триггера, если несколько операций 
-- блудут обновлять одно значение Value, то возникнет проблема, поэтому хочется гарантировать,
-- что не будет Неповторяющегося чтения
create or replace function closeEvent(
    userIdArg bigint, 
    pswdHashArg text,
    eventIdArg bigint
)
returns boolean
as
$$
declare
    currentTime timestamp := now();
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and PswdHash = pswdHashArg) or
        currentTime > (select EndTime from Events where EventId = eventIdArg) or
        (select count(CreatorId) from Events where EventId = eventIdArg and CreatorId = userIdArg) = 0
    then
        return false;
    else
        update Events
        set IsOpen = false
        where
            EventId = eventIdArg;
        return true;
    end if;
end;
$$ language plpgsql;
