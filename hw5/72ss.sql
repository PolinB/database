select distinct CourseName, GroupName
from (
    select distinct CourseId, GroupId
    from (
        select CourseId
        from
            Marks natural join Students
        ) AllCourseWithMark, (
        select 
            GroupId
        from
            Students
        ) StudentGroups
    except
        select distinct
            CourseId, GroupId
        from (
            select 
                CourseId, StudentId, GroupId
            from (
                select
                    CourseId
                from
                    Marks natural join Students
                ) AllCourseWithMark, (
                select
                    StudentId, StudentName, GroupId
                from
                    Students
                ) AllStudentsGroups
            except
                select CourseId, StudentId, GroupId
                from
                    Students natural join Marks
        ) UnlessGroups
    ) CIdGId
    natural join Courses
    natural join Groups
