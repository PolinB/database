select
    StudentName, AvgMark
from
    Students
    left join (
        select
            avg(cast(Mark as real)) as AvgMark, StudentId
        from
            Marks
        group by
            StudentId
    ) SAVG
on
    Students.StudentId = SAVG.StudentId;
