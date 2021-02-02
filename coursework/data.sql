insert into Towns
    (TownId, TownName) values
    (1, 'Saint Petersburg'),
    (2, 'Petergof'),
    (3, 'Saratov'),
    (4, 'Moscow'),
    (5, 'Kotlas');

insert into Users
    (UserId, Email, PswdHash, UserName, UserTownId) values
    (1, 'PolinB2413@gmail.com', '1234qwerty', 'Burtseva Polina', 1),
    (2, 'niki@mail.ru', 'qwerty1234', 'Kochetkov Nikita', 1),
    (3, 'nell_23@mail.ru', 'zxcvbnm098765431', 'Burtseva Julia', 5),
    (4, 'nell@mail.ru', 'zxcvbnm098765431', 'Burtseva Julia', 3),
    (5, 'neerc@ifmo.ru', 'ASM5415L7Y', 'Kopelovich Anna', 2),
    (6, 'test6@mail.ru', 'J96SJNDI7N', 'Test6', 2),
    (7, 'test7@mail.ru', 'COGCXJF1DG', 'Test7', 1),
    (8, 'test8@mail.ru', '63QRENE652', 'Test8', 1),
    (9, 'test9@mail.ru', '3PRA0G1N1O', 'Test9', 4),
    (10, 'test10@mail.ru', 'GJWA8AR9DE', 'Test10', 5),
    (11, 'test11@mail.ru', 'K26131SISC', 'Test11', 5),
    (12, 'test12@mail.ru', 'R996GTRS8V', 'Test12', 2),
    (13, 'test13@mail.ru', 'RQW0JTJOHJ', 'Test13', 4),
    (14, 'test14@mail.ru', 'OV7A12SF78', 'Test14', 2),
    (15, 'test15@mail.ru', 'NSAZD2U0E9', 'Test15', 3);

insert into Events
    (EventId, EventName, Description, StartTime, EndTime, IsOpen, CreatorId, EventTownId) values
    (1, 'Feed', null, '2021-01-01 18:00:00', '2021-01-01 19:30:00', false, 1, 5),
    (2, 'NEERC', null, '2021-04-13 09:00:00', '2021-04-15 15:00:00', true, 5, 1),
    (3, 'NEERC', null, '2021-04-13 09:00:00', '2021-04-15 15:00:00', true, 5, 4),
    (4, 'Feed', null, '2021-01-24 16:30:00', '2021-01-24 18:00:00', true, 3, 1),
    (5, 'Math tournament', null, '2021-05-17 09:30:00', '2021-05-27 16:00:00', true, 3, 5),
    (6, 'Feed', null, '2021-01-02 18:00:00', '2021-01-02 19:30:00', false, 1, 5),
    (7, 'Feed', null, '2021-01-03 18:00:00', '2021-01-03 19:30:00', false, 1, 5),
    (8, 'ClosedEvent', 'It is closed event for example', '2021-01-03 18:00:00', '2021-01-03 19:30:00', false, 2, 3);

insert into Volunteers
    (UserId, EventId, IsParticipated) values
    (1, 2, false),
    (10, 4, false),
    (12, 2, false),
    (10, 2, false),
    (2, 4, false),
    (15, 2, false),
    (1, 1, true),
    (5, 1, true),
    (9, 3, false),
    (7, 4, true),
    (3, 1, false),
    (15, 3, false),
    (10, 1, false),
    (10, 6, true),
    (10, 7, false),
    (4, 3, false),
    (13, 4, true),
    (3, 3, false),
    (5, 2, false),
    (9, 2, false);

insert into Messages
    (MessageId, MessageText, SendTime, FromUserId, ToUserId) values
    (1, 'Text1', '2022-12-05 04:02:35', 9, 7),
    (2, 'Text2', '2021-08-01 11:05:09', 8, 4),
    (3, 'Text3', '2022-06-05 19:57:15', 2, 14),
    (4, 'Text4', '2022-05-09 20:25:28', 14, 12),
    (5, 'Text5', '2022-04-09 15:48:57', 7, 1),
    (6, 'Text6', '2021-02-04 20:44:58', 15, 6),
    (7, 'Text7', '2022-03-19 22:30:05', 10, 1),
    (8, 'Text8', '2022-07-30 14:55:22', 12, 10),
    (9, 'Text9', '2022-07-07 21:45:57', 8, 7),
    (10, 'Text10', '2021-02-05 11:25:42', 12, 14);

insert into Comments
    (CommentId, CommentText, SendTime, EventId, UserId) values
    (1, 'Will it be necessary to communicate with people?', '2021-01-01 07:00:00', 1, 2),
    (2, 'I think maybe', '2021-01-01 08:15:22', 1, 6),
    (3, 'No, you will only have contact with animals', '2021-01-01 12:01:30', 1, 1),
    (4, 'In what format will it be held?', '2021-04-06 01:20:43', 2, 7),
    (5, 'Very interesting event', '2021-04-06 01:20:43', 2, 3),
    (6, 'This year everything is remote', '2021-04-07 01:20:43', 2, 6),
    (7, 'In any case, it will not be full-time', '2021-08-22 05:38:02', 2, 9),
    (8, 'I really hope that the situation will improve by then','2021-09-21 11:05:14', 2, 10),
    (9, 'Sadly', '2022-02-02 19:58:59', 2, 11);

insert into CommentReplies
    (CommentId, ReplyCommentId) values
    (2, 1),
    (3, 2),
    (6, 4),
    (7, 4),
    (8, 4),
    (9, 7);

insert into Achievements
    (AchievementId, Name) values
    (1, 'pets'),
    (2, 'sorter'),
    (3, 'math'),
    (4, 'science'),
    (5, 'karma'),
    (6, 'care'),
    (7, 'medicine'),
    (8, 'computer builder');

insert into EventAchievements
    (EventId, AchievementId, UpValue) values
    (1, 1, 10),
    (1, 5, 1),
    (1, 6, 5),
    (2, 8, 10),
    (3, 8, 10),
    (3, 5, 1),
    (4, 1, 1),
    (5, 3, 10),
    (5, 4, 5),
    (5, 5, 1),
    (6, 1, 5),
    (7, 2, 3),
    (6, 3, 2);


insert into UserAchievements
    (UserId, AchievementId, Value) values
    (1, 1, 10),
    (1, 5, 1),
    (1, 6, 5),
    (5, 1, 10),
    (5, 5, 1),
    (5, 6, 5),
    (7, 1, 3);

