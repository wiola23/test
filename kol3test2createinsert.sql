create database hotel2;
go

use hotel2;
go

create table Hotels (
HotelCode int NOT NULL,
HotelName varchar(10),
City varchar(100),
Description text NULL,
CONSTRAINT PK_h PRIMARY KEY (HotelCode));

create table HotelRooms (
RoomCode int NOT NULL,
HotelCode int,
NumberOfGuests int,
CostOfANight money,
CONSTRAINT  FK_hotelroom_hotels FOREIGN KEY (HotelCode) REFERENCES Hotels(HotelCode),
CONSTRAINT PK_hr PRIMARY KEY (RoomCode));

create table Reservations (
ReservationCode int IDENTITY(1,1),
RoomCode int,
DateFrom date,
DateTo date,
TotalCost money NULL,
CONSTRAINT PK_r PRIMARY KEY (ReservationCode),
CONSTRAINT  FK_hotelroom_reservation FOREIGN KEY (RoomCode) REFERENCES HotelRooms(RoomCode));

alter table HotelRooms add IsReserved bit default 0;
alter table hotels alter column HotelName varchar(100);

INSERT INTO Hotels (HotelCode, HotelName, City, Description)
VALUES 
(1, 'Hilton', 'Warsaw', 'Luxury hotel in the city center'),
(2, 'Ibis', 'Krakow', NULL);

INSERT INTO HotelRooms (RoomCode, HotelCode, NumberOfGuests, CostOfANight)
VALUES 
(101, 1, 2, 500.00),
(102, 1, 4, 800.00),
(201, 2, 1, 150.00),
(202, 2, 2, 200.00);

INSERT INTO Reservations (RoomCode, DateFrom, DateTo, TotalCost)
VALUES 
(101, '2023-06-01', '2023-06-05', 2000.00),
(102, '2023-07-10', '2023-07-12', 1600.00),
(201, '2023-08-01', '2023-08-03', 300.00),
(201, '2023-09-15', '2023-09-20', 750.00);


