create or replace function flightStatistics(userIdArg int, passArg text)
returns table (fId int, canReserve boolean, canBuy boolean, freeCount bigint, reservedCount bigint, boughtCount bigint) as
$$
declare
    reservationInterval interval := interval '1 Day';
    currentTime timestamp := now();
    infoCount int;
begin
    return query select FlightId as fId,
                 (select count(unnest) > 0 from unnest(freeSeats(Flights.FlightId))) as canReserve,
                 (select count(unnest) > 0
                    from
                    (select unnest
                    from unnest(freeSeats(Flights.FlightId))
                    union 
                    select seatNo as unnest 
                        from ReservedSeats natural join users
                        where
                            FlightId = Flights.FlightId 
                            and ReserveTime + reservationInterval > currentTime
                            and UserId = userIdArg
                            and Pass = passArg) subreq
                 ) as canBuy ,
                 (select count(unnest) from unnest(freeSeats(Flights.FlightId))) as freeCount,
                 (select count(seatNo) from BoughtSeats where flightId = Flights.FlightId) as boughtCount,
                 (select count(seatNo) 
                  from ReservedSeats 
                  where FlightId = Flights.FlightId 
                    and ReserveTime + reservationInterval > currentTime) as reservedCount
                 from Flights
                 ;
end;
$$
language plpgsql;