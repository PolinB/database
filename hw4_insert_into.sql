insert into Groups
    (group_id, group_name) values
    (1, 'M3335'),
    (2, 'M3339'),
    (3, 'M3437');

insert into Students
    (student_id, student_name, group_id) values
    (1, 'Vika', 1),
    (2, 'Polina', 1),
    (3, 'Daniil', 2);

insert into Courses
    (course_id, course_name) values
    (1, 'Data Base'),
    (2, 'Java');

insert into Lecturers
    (lecturer_id, lecturer_name) values
    (1, 'Korneev Georgiy'),
    (2, 'Vedernikov Nikolay');

insert into CourseGroups
    (group_id, course_id, lecturer_id) values
    (2, 2, 1),
    (1, 2, 2),
    (3, 2, 1);

insert into Marks
    (student_id, course_id, mark_name) values
    (1, 2, 'A'),
    (2, 2, 'A'),
    (3, 2, 'B');

