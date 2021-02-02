create or replace function freeSeatsProc(flightId int)
returns int[] as
$$
begin
    set transaction isolation level read committed;
    select freeSeats(flightId);
end;
$$
language plpgsql;