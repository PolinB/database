select
    StudentId, StudentName, GroupId
from
    Students
    natural join Marks
where
    CourseId = :CourseId and Mark = :Mark;
