select distinct CourseName, GroupName
from (
    select CourseName, CourseId
    from
        Marks 
        natural join Students
        natural join Courses
    ) AllCourseWithMark, (
    select 
        GroupId, GroupName
    from
        Students
        natural join Groups
    ) StudentGroups
except
    select distinct
        CourseName, GroupName
    from (
        select 
            CourseId, StudentId, GroupId, GroupName, CourseName
        from (
            select
                CourseId, CourseName
            from
                Marks 
                natural join Students
                natural join Courses
            ) AllCourseWithMark, (
            select
                StudentId, StudentName, GroupId, GroupName
            from
                Students
                natural join Groups
            ) AllStudentsGroups
        except
            select CourseId, StudentId, GroupId, GroupName, CourseName
            from
                Students
                natural join Marks
                natural join Courses
                natural join Groups
    ) UnlessGroups;
