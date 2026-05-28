create procedure procedura2 @hotelname varchar(100), @nrguests int, @datefrom date, @dateto date as
BEGIN
declare @rc int;
select top 1 @rc=RoomCode from Hotels h join HotelRooms hr on hr.HotelCode=h.HotelCode where HotelName=@hotelname and NumberOfGuests=@nrguests and IsReserved=1;
if @rc is not null
begin
declare @cost money;

insert into Reservations (roomcode, DateFrom, DateTo, TotalCost) values (@rc, @datefrom, @dateto, @cost);
end
END