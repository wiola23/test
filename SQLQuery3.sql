CREATE PROCEDURE arciwumorderdetails @N int AS
BEGIN 
begin tran
INSERT INTO ArchivedOrders SELECT *, SYSDATETIME() FROM Orders WHERE DATEDIFF(YEAR, OrderDate, SYSDATETIME()) > @N;
INSERT INTO ArchivedOrdersDetails SELECT od.* FROM [order details] od join orders o on
o.orderid=od.orderid where DATEDIFF(YEAR, OrderDate, SYSDATETIME()) > @N;


DELETE FROM [Order Details] where exists (select * from orders o where DATEDIFF(YEAR, OrderDate, SYSDATETIME()) > @N and [Order Details].orderid=o.orderid);
DELETE FROM Orders where DATEDIFF(YEAR, OrderDate, SYSDATETIME()) > @N;
UPDATE ArchivedOrders SET ArchiveDate=SYSDATETIME();

commit
END