create or replace function freeSeats(flightIdArg int)
returns int[] as
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
    if flightTime is null or flightTime < currentTime then
        return result;
    end if;
    allSeats := (select SeatNo from Seats natural join Flights where Flights.FlightId = flightIdArg);
    loop
        declare infoCount int;
        begin
            exit when seat = allSeats;
            seat := seat + 1;
            if seat not in (select SeatNo from BoughtSeats where FlightId = flightIdArg and SeatNo = seat) and
                seat not in (select SeatNo 
                          from ReservedSeats 
                          where 
                              FlightId = flightIdArg 
                              and SeatNo = seat 
                              and ReserveTime + reservationInterval > currentTime
                         ) then
                result := array_append(result, seat);
            end if;
        end;
    end loop;
    return result;
end;
$$
language plpgsql;

-- select * from freeSeats(1);