create table Groups (
    group_id int primary key,
    group_name char(5) unique not null
);

create table Students (
    student_id int primary key,
    student_name varchar(50) not null,
    group_id int not null,
    foreign key (group_id) references Groups (group_id)
);
    
create table Courses (
    course_id int primary key,
    course_name varchar(100) not null
);

create table Lecturers (
    lecturer_id int primary key,
    lecturer_name varchar(50) not null
);

create table CourseGroups (
    group_id int,
    course_id int,
    lecturer_id int not null,
    primary key (group_id, course_id),
    foreign key (group_id) references Groups (group_id),
    foreign key (course_id) references Courses (course_id)
);

create table Marks (
    student_id int,
    course_id int,
    mark_name char not null,
    primary key (student_id, course_id),
    foreign key (student_id) references Students (student_id),
    foreign key (course_id) references Courses (course_id)
);

