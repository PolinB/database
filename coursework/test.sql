-- insert into CommentReplies (CommentId, ReplyCommentId) values (4, 7);
-- insert into CommentReplies (CommentId, ReplyCommentId) values (1, 4);
-- select * from addEvent(1, '1234qwerty', 'Add event test', 9, 'New Event', '2021-05-01 18:00:00', '2021-05-01 19:30:00', 1);
-- select * from Events;
-- select * from sendMessage (1, '1234qwerty', 2, 11, 'Hello');
-- select * from Messages;
-- select * from sendComment (1, '1234qwerty', 3, 10, 'What we must do on this event?');
-- select * from Comments;
-- select * from replyOnComment (1, '1234qwerty', 3, 3, 11, 'Reply comment');
-- select * from Comments;
-- select * from CommentReplies;
-- select * from registrateVolunteer (1, '1234qwerty', 4);
-- select * from Volunteers;

-- select * from askCancelParticipationByVolunteer(15, 'NSAZD2U0E9', 3, 'I have an exam scheduled for this day');
-- select * from Messages;

-- select * from deleteVolunteerFromEvent(5, 'ASM5415L7Y', 3, 15, 'Event closed due to pandemic');
-- select * from Messages;
-- select * from Volunteers;

-- select * from markVolunteerInEvent(5, 'ASM5415L7Y', 3, 4);
-- select * from Volunteers;


-- select * from markAllVolunteersInEvent(3, 'zxcvbnm098765431', 4);
-- select * from Volunteers;

-- select * from closeEvent(3, 'zxcvbnm098765431', 4);

-- Постройте запрос, который для событию получает 
-- топ волонтёров с максимальным числом ачивок за события, проходившие в том же городе

select V.UserId, count(EA.AchievementId)
from
    Volunteers as V natural join
    EventAchievements as EA natural join
    (
        select EventId
        from
            Events
        where
            EventTownId in (
                select EventTownId
                from Events
                where EventId = 1)
            and IsOpen = false
    ) req1
where
    V.IsParticipated = true
group by V.UserId
order by count(EA.AchievementId) DESC;