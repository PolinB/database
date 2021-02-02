INSERT INTO Groups (GroupId, GroupName)
	VALUES (1, 'M3439'),
		   (2, 'M3339'),
		   (3, 'M3239'),
		   (4, 'M3139'),
		   (5, 'M3438');

INSERT INTO Students (StudentId, StudentName, GroupId) 
	VALUES (1, 'Ivan Belonogov', 1),
		   (2, 'Evgeny Nemchenko', 5), 
		   (3, 'Michail Putilin', 1), 
		   (4, 'Appolinaria Romanova', 3), 
		   (5, 'Anna Rodionova', 2),
		   (6, 'Vyacheslav Moklev', 1),
		   (7, 'Daniil Prokopenko', 5);

INSERT INTO Lecturers (LecturerId, LecturerName)
	VALUES (1, 'Georgiy Korneev'),
		   (2, 'Andrew Stankevich'),
		   (3, 'Oksana Pavlova');

		   
INSERT INTO Courses (CourseId, CourseName)
	VALUES (1, 'Java'),
		   (2, 'Algorithm and Data Structures'),
		   (3, 'English'),
		   (4, 'Databases'),
		   (5, 'DMath');		   		   

INSERT INTO Marks (Mark, CourseId, StudentId)
	VALUES 
		   (99, 2, 3),
		   (40, 4, 3),		   
		   (44, 1, 6),
		   (98, 4, 6),
		   (100, 2, 2),
		   (100, 4, 4),
		   (88, 1, 4),
		   (33, 1, 1),
		   (22, 2, 1),
		   (44, 4, 1),
		   (100, 2, 5);

INSERT INTO Plan (LecturerId, CourseId, GroupId)
	VALUES (1, 1, 1),
		   (2, 2, 1),
		   (1, 4, 1),
		   (1, 4, 2),
		   (2, 2, 3),
		   (2, 5, 4),
		   (1, 1, 3),
		   (1, 4, 3),
		   (3, 2, 2),
		   (3, 3, 5),
		   (2, 2, 5);