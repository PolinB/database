select StudentId
from Marks
except
    select StudentId
    from (
        select StudentId, CourseId
        from (
            select StudentId from Marks
        ) AllStudentsWithMarks, (
            select CourseId from Plan natural join Lecturers where LecturerName = :LecturerName
        ) AllLecturerCourses
        except
        select StudentId, CourseId from Marks
    ) AllStudentsIdCourseId;
