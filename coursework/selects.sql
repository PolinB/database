-- Мероприятия в городе участника
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны события, которые действительно уже занесены в базу данных,
-- а какие-то не подтвержденные могут создать ложное впечатление у пользователя
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    EventId, EventName, Description, StartTime, EndTime, UserName as Creator, TownName
from
    Events
    inner join Towns on (Events.EventTownId = Towns.TownId)
    inner join Users on (Events.CreatorId = Users.UserId and Events.EventTownId = Users.UserTownId)
where
    StartTime > '2021-01-13 12:00:00';

-- Комментарии к мероприятию
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны комментарии, которые действительно уже занесены в базу данных,
-- а какие-то не подтвержденные могут создать ложное впечатление у пользователя
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    CommentId, CommentText, UserName, SendTime, ReplyCommentId
from
    Comments
    natural join Users
    left join CommentReplies using (CommentId)
where
    EventId = 1
order by
    SendTime;

-- Ответы к комментарию
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны комментарии, которые действительно уже занесены в базу данных,
-- а какие-то не подтвержденные могут создать ложное впечатление у пользователя
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    CommentId, CommentText, UserName, SendTime
from
    Comments
    natural join Users
    natural join CommentReplies
where
    ReplyCommentId = 4
order by
    SendTime;

-- Увеличение навыка
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд события и навыки
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    Name, UpValue
from
    Events
    natural join EventAchievements
    natural join Achievements
where
    EventId = 1;

-- Где увеличить навык
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд события и навыки
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    UpValue as SkillIncrease, EventId, EventName, StartTime, EndTime, UserName as Creator
from
    Events
    inner join Users on (Events.CreatorId = Users.UserId)
    natural join EventAchievements
    natural join Achievements
where
    Name = 'karma' and
    StartTime > '2021-01-13 12:00:00'
order by
    SkillIncrease;

-- Еще не закрытые, но уже закончившиеся мероприятия
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд события
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    EventId, EventName, Description, StartTime, EndTime, CreatorId
from
    Events
where
    EndTime < '2021-01-31 12:00:00' and
    IsOpen = true;

-- Волонтеры на мероприятие
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд пользователи и регистрации
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    UserId, UserName, Email, TownName
from
    Volunteers
    natural join Users
    inner join Towns on (Users.UserId = Towns.TownId)
where
    EventId = 1;

-- Количество успешных участий волонтеров
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд события
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    UserId, UserName, count(EventId) as countEvents
from
    Volunteers
    natural join Users
where
    IsParticipated = true
group by
    UserId, UserName;

-- Плохие волонтеры
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд данные
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select
    UserId
from
    Events
    natural join Volunteers
where
    IsOpen = false and
    IsParticipated = false
group by
    UserId
having
    count(EventId) > 2;

-- В активном поиске волонтеров
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд данные
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
select 
    EventId, EventName, Description, StartTime, EndTime
from
    Events
where 
    EventId not in (
        select
            EventId
        from
            Volunteers
        ) and
    IsOpen = true and
    EndTime > '2021-01-01 12:00:00';


-- вспомогательные представления

-- EventVolunteersCount
-- Уровень изоляции: read commited
-- Мы не собираем статистику и нам важны занесенные в бд данные
-- поэтому read uncommited не подходит, а больший уровень на чтение ни к чему
create or replace view EventVolunteersCount as
select
    EventId, EventName, IsOpen, count(UserId)
from
    Events
    natural join Volunteers
group by
    EventId, EventName, IsOpen;

select EventId, EventName, IsOpen, count from EventVolunteersCount;

-- StatisticUpValue
-- Уровень изоляции: read uncommited
-- Мы собираем статистику и если прочтем что-то не то, то это не повлияет на работу
create or replace view StatisticUpValue as
select
    AchievementId, Name, min(UpValue), avg(UpValue), max(UpValue)
from
    EventAchievements
    natural join Achievements
group by
    AchievementId, Name;

select AchievementId, Name, min, avg, max from StatisticUpValue;
