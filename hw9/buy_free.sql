create or replace function buyFree(flightIdArg int, seatNoArg int)
returns boolean as
$$
declare
    reservationInterval interval := interval '1 Day';
    currentTime timestamp := now();
    infoCount int;
begin
    if flightIdArg not in (select FlightId from Flights where FligtTime > currentTime)
       or seatNoArg < 1
       or seatNoArg > (select SeatNo from Seats natural join Flights where FlightId = flightIdArg) then
        return false;
    end if;
    if seatNoArg not in (select SeatNo from BoughtSeats where FlightId = flightIdArg and SeatNo = seatNoArg) and
        seatNoArg not in 
            (select SeatNo 
              from ReservedSeats 
              where 
                  FlightId = flightIdArg 
                  and SeatNo = seatNoArg
            ) then
        insert into BoughtSeats (FlightId, SeatNo) values (flightIdArg, seatNoArg); 
        return true;
    end if;
    return false;
end;
$$
language plpgsql;

-- select * from buyFree(3, 1);