CREATE TABLE Category (
    CategoryID    integer     PRIMARY KEY,
	CategoryName  varchar(50) NOT NULL,
	Tax           decimal     NOT NULL
);

CREATE TABLE Branch (
    BranchID      integer     PRIMARY KEY,
	BranchName    varchar(50) NOT NULL
);

CREATE TABLE Customer (
    CustomerID    integer     PRIMARY KEY,
	CustomerName  varchar(50) NOT NULL
);

CREATE TABLE SalesRep (
    SalesRepID    integer     PRIMARY KEY,
	SalesRepName  varchar(50) NOT NULL,
	BranchID      integer     NOT NULL REFERENCES Branch (BranchID)
);

CREATE TABLE Orders (
    OrderID       integer     PRIMARY KEY,
	OrderDate     date        NOT NULL,
	CustomerID    integer     NOT NULL REFERENCES Customer (CustomerID),
	SalesRepID    integer     NULL REFERENCES SalesRep (SalesRepID)
);

CREATE TABLE Product (
    ProductID     integer     PRIMARY KEY,
    ProductName   varchar(50) NOT NULL,
    CategoryID    integer     NOT NULL REFERENCES Category (CategoryID),
    Price         decimal     NOT NULL
);

CREATE TABLE OrderDetail (
    OrderDetailID integer     PRIMARY KEY,
    OrderID       integer     NOT NULL REFERENCES Orders (OrderID),
	ProductID     integer     NOT NULL REFERENCES Product (ProductID),
	Discount      decimal     NULL,
	Quantity      integer     NOT NULL
);


