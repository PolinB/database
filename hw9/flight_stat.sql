create or replace function flightStat(userIdArg int, passArg text, flightIdArg int)
returns table (canReserve boolean, canBuy boolean, freeCount bigint, reservedCount bigint, boughtCount bigint) as
$$
declare
    reservationInterval interval := interval '1 Day';
    currentTime timestamp := now();
    infoCount int;
begin
    return query select req4.canReserve, req5.canBuy, req1.freeCount, req3.reservedCount, req2.boughtCount 
                 from 
                     (select count(unnest) > 0 as canReserve from unnest(freeSeats(flightIdArg))) req4,
                     (select count(unnest) > 0 as canBuy
                        from
                        (select unnest
                        from unnest(freeSeats(flightIdArg))
                        union 
                        select seatNo as unnest 
                            from ReservedSeats natural join users
                            where
                                FlightId = flightIdArg 
                                and ReserveTime + reservationInterval > currentTime
                                and UserId = userIdArg
                                and Pass = passArg) subreq
                     ) req5 ,
                     (select count(unnest) as freeCount from unnest(freeSeats(flightIdArg))) req1,
                     (select count(seatNo) as boughtCount from BoughtSeats where flightId = flightIdArg) req2,
                     (select count(seatNo) as reservedCount 
                      from ReservedSeats 
                      where FlightId = flightIdArg 
                        and ReserveTime + reservationInterval > currentTime) req3
                     ;
end;
$$
language plpgsql;