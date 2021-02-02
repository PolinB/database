drop table if exists Marks;
drop table if exists Plan;
drop table if exists Students;
drop table if exists Groups;
drop table if exists Courses;
drop table if exists Lecturers;

create table Groups (
    GroupId int primary key,
    GroupName char(5) unique not null
);

create table Students (
    StudentId int primary key,
    StudentName varchar(50) not null,
    GroupId int not null
);
    
create table Courses (
    CourseId int primary key,
    CourseName varchar(60) not null
);

create table Lecturers (
    LecturerId int primary key,
    LecturerName varchar(50) not null
);

create table Plan (
    GroupId int,
    CourseId int,
    LecturerId int,
    primary key (GroupId, CourseId)
);

create table Marks (
    StudentId int,
    CourseId int,
    Mark int,
    primary key (StudentId, CourseId)
);