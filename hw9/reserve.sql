create or replace function reserve(userIdArg int, passArg text, flightIdArg int, seatNoArg int)
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
    if seatNoArg not in (select SeatNo from BoughtSeats where FlightId = flightIdArg and SeatNo = seatNoArg) and
            seatNoArg not in (select SeatNo 
              from ReservedSeats 
              where 
                  FlightId = flightIdArg 
                  and SeatNo = seatNoArg 
                  and ReserveTime + reservationInterval > currentTime
             ) then
        delete from ReservedSeats where FlightId = flightIdArg and SeatNo = seatNoArg;
        insert into ReservedSeats (UserId, FlightId, SeatNo, ReserveTime) 
            values (userIdArg, flightIdArg, seatNoArg, currentTime); 
        return true;
    end if;
    return false;
end;
$$
language plpgsql;

-- select * from reserve(1, 'Hello', 1, 1);