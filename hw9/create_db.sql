create table Flights (
    FlightId int primary key,
    FligtTime timestamp not null,
    PlaneId int not null
);

create table Seats (
    PlaneId int primary key,
    SeatNo int not null
);

create table Users (
    UserId int primary key, 
    Pass text not null
);

create table ReservedSeats (
    UserId int not null,
    FlightId int,
    SeatNo int,
    ReserveTime timestamp not null,
    primary key (FlightId, SeatNo)
);

create table BoughtSeats (
    FlightId int,
    SeatNo int,
    primary key (FlightId, SeatNo)
);

