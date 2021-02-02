create or replace function buyReserved(userIdArg int, passArg text, flightIdArg int, seatNoArg int)
returns boolean as
$$
declare
    reservationInterval interval := interval '1 Day';
    currentTime timestamp := now();
    infoCount int;
begin
    if userIdArg not in (select UserId from Users where UserId = userIdArg and Pass = passArg)
       or flightIdArg not in (select FlightId from Flights where FligtTime > currentTime)
       or seatNoArg < 1
       or seatNoArg > (select SeatNo from Seats natural join Flights where FlightId = flightIdArg) then
        return false;
    end if;
    if seatNoArg in (select SeatNo 
                      from ReservedSeats 
                      where 
                          FlightId = flightIdArg 
                          and SeatNo = seatNoArg
                          and UserId = userIdArg
                          and ReserveTime + reservationInterval > currentTime
                     ) then
        insert into BoughtSeats (FlightId, SeatNo) values (flightIdArg, seatNoArg);
        delete from ReservedSeats where FlightId = flightIdArg and SeatNo = seatNoArg and UserId = userIdArg;
        return true;
    end if;
    return false;
end;
$$
language plpgsql;