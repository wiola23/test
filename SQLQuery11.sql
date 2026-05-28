create table ArchievedOrders (
	OrderID int NOT NULL,
	OrderDate datetime,
	RequiredDate datetime,
	ShippedDate datetime,
	Freight money,
	ShipName nvarchar(40),
	ShipAddress nvarchar(60),
	ShipCity nvarchar(15),
	ShipRegion nvarchar(15),
	ShipPostalCode nvarchar(10),
	ShipCountry nvarchar(15),
	CustomerID nchar(5),
	EmployeeID int,
	ArchiveDate datetime,
	CONSTRAINT klucz PRIMARY KEY (OrderID),
	CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT fk_employee FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID));

	