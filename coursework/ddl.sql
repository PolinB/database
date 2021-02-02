create table Towns (
    TownId int primary key,
    TownName varchar(60) unique not null
);

create table Users (
    UserId bigint primary key,
    Email varchar(60) unique not null,
    PswdHash text not null,
    UserName varchar(60) not null,
    UserTownId int not null,
    foreign key (UserTownId) references Towns (TownId)
);

create table Events (
    EventId bigint primary key,
    EventName varchar(50) not null,
    Description text,
    StartTime timestamp not null,
    EndTime timestamp not null,
    IsOpen boolean not null,
    CreatorId bigint not null,
    EventTownId int not null,
    constraint checkTime check (StartTime < EndTime),
    foreign key (CreatorId) references Users (UserId),
    foreign key (EventTownId) references Towns (TownId)
);

create table Volunteers (
    UserId bigint,
    EventId bigint,
    IsParticipated boolean,
    primary key (UserId, EventId),
    foreign key (UserId) references Users (UserId),
    foreign key (EventId) references Events (EventId)
);

create table Messages (
    MessageId bigint primary key,
    MessageText text not null,
    SendTime timestamp not null,
    FromUserId bigint not null,
    ToUserId bigint not null,
    foreign key (FromUserId) references Users (UserId),
    foreign key (ToUserId) references Users (UserId)
);

create table Comments (
    CommentId bigint primary key,
    CommentText text not null,
    SendTime timestamp not null,
    EventId bigint not null,
    UserId bigint not null,
    foreign key (EventId) references Events (EventId),
    foreign key (UserId) references Users (UserId)
);

create table CommentReplies (
    CommentId bigint primary key,
    ReplyCommentId bigint not null,
    constraint checkNotEqualsId check (CommentId <> ReplyCommentId),
    foreign key (CommentId) references Comments (CommentId) on delete cascade,
    foreign key (ReplyCommentId) references Comments (CommentId) on delete cascade
);

create table Achievements (
    AchievementId int primary key,
    Name varchar(50) unique not null
);

create table EventAchievements (
    EventId bigint,
    AchievementId int,
    UpValue int not null constraint interval_up check (UpValue > 0 and UpValue <= 10),
    primary key (EventId, AchievementId) 
);

create table UserAchievements (
    UserId bigint,
    AchievementId int,
    Value int not null constraint not_negative_value check (Value >= 0),
    primary key (UserId, AchievementId)
);

-- Если пользователей часто будут интересовать мероприятия именно в их городах
-- Запрос 'Мероприятия в городе участника', то имеет смысл добавить следующие индексы
create index on Users using hash (UserTownId);
create index on Events using hash (EventTownId);

-- Индекс на внешний ключ
-- Для запросов когда мы хотим проверить создателя события, часто встречается в updates.sql
-- Например, в markAllVolunteersInEvent
create index on Events using hash (CreatorId);

-- Индекс на внешний ключ
-- Для поиска всех комментариев к событию
-- Например, в 'Комментарии к мероприятию'
create index on Comments using hash (EventId);
