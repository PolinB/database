create or replace function hello(flightIdArg int)
returns int as
$$
declare
    reservationInterval interval := interval '1 Day';
    currentTime timestamp := now();
    seat int := 0;
    allSeats int := 0;
    result int[] := array[]::int[];
    flightTime timestamp;
begin
    flightTime := (select FligtTime from Flights where FlightId = flightIdArg);
    if flightTime = null then
        return -2100;
    end if;
    return flightTime;
    exception 
    when others then
      return -200;
end;
$$
language plpgsql;