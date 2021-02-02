insert into UniversityGroups
    (group_id, group_no) values
    (1, 'M3435'),
    (2, 'M3436'),
    (3, 'M3437'),
    (4, 'M3139');

insert into Students
    (student_id, student_name, email, group_id) values
    (1, 'Vika', 'la@mail.ru', 1),
    (2, 'Polina', 'lala@ha.ru', 1),
    (3, 'Daniil', null, 2),
    (4, 'Nadya', 'val@val.ru', 4);

insert into Subjects
    (subject_id, subject_name) values
    (1, 'Data Base'),
    (2, 'Java');

insert into Teachers
    (teacher_id, teacher_name) values
    (1, 'Korneev Georgiy'),
    (2, 'Vedernikov Nikolay');

insert into SubjectTeachers
    (subject_id, teacher_id) values
    (1, 1),
    (2, 1),
    (2, 2);

insert into Marks
    (student_id, subject_id, mark) values
    (1, 1, null),
    (2, 1, null),
    (3, 1, null),
    (1, 2, 'A'),
    (2, 2, 'A'),
    (3, 2, 'B'),
    (4, 2, null);

