drop table if exists Marks;
drop table if exists SubjectTeachers;
drop table if exists Students;
drop table if exists UniversityGroups;
drop table if exists Subjects;
drop table if exists Teachers;

create table UniversityGroups (
    group_id int primary key,
    group_no char(5) unique not null
);

create table Students (
    student_id int primary key,
    student_name varchar(50) not null,
    email varchar(30),
    group_id int not null,
    foreign key (group_id) references UniversityGroups (group_id)
);
    
create table Subjects (
    subject_id int primary key,
    subject_name varchar(60) not null
);

create table Teachers (
    teacher_id int primary key,
    teacher_name varchar(50) not null
);

create table SubjectTeachers (
    subject_id int,
    teacher_id int,
    primary key (subject_id, teacher_id),
    foreign key (subject_id) references Subjects (subject_id),
    foreign key (teacher_id) references Teachers (teacher_id)
);

create table Marks (
    student_id int,
    subject_id int,
    mark char,
    primary key (student_id, subject_id),
    foreign key (student_id) references Students (student_id),
    foreign key (subject_id) references Subjects (subject_id)
);

