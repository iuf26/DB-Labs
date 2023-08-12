CREATE DATABASE OnlineShop
GO
USE OnlineShop
GO

CREATE TABLE Firms
(
FirmTIN varchar(12) PRIMARY KEY NOT NULL,
FirmName varchar(100) NOT NULL,
FirmAddress varchar(150)
);

CREATE TABLE Products
(
ProductCode int PRIMARY KEY NOT NULL,
ProductName varchar(200) NOT NULL,
ProductFirm varchar(12) FOREIGN KEY REFERENCES Firms (FirmTIN) NOT NULL,
ProductPrice float NOT NULL,
ProductCategory varchar(30),
ProductDescription text,
ProductQuentity int
);


CREATE TABLE DeliveryFirms
(
DeliveryFirmTIN varchar(12) PRIMARY KEY NOT NULL,
DeliveryFirmName varchar(100) NOT NULL,
DeliveryFirmAddress varchar(150),
DeliveryFirmCost float NOT NULL
);


CREATE TABLE Users
(
Username varchar(40) PRIMARY KEY NOT NULL,
UserPasswordHash varchar(64) NOT NULL,
UserFirstName varchar(30),
UserLastName varchar(30),
UserAddress varchar(150)
);

CREATE TABLE Orders
(
OrderID int PRIMARY KEY NOT NULL,
OrderAWB varchar(30) NOT NULL,
OrderDateTime smalldatetime NOT NULL,
OrderDeliveryFirm varchar(12) FOREIGN KEY REFERENCES DeliveryFirms (DeliveryFirmTIN) NOT NULL,
OrderUser varchar(40) FOREIGN KEY REFERENCES Users(Username) NOT NULL
);

CREATE TABLE ProductsOrders
(
PCode int FOREIGN KEY REFERENCES Products (ProductCode) NOT NULL,
OID int FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
CONSTRAINT pk_ProductsOrders PRIMARY KEY (PCode, OID),
Quantity int NOT NULL
);


CREATE TABLE Reviews
(
ReviewUser varchar(40) FOREIGN KEY REFERENCES Users(Username) NOT NULL,
ReviewProduct int FOREIGN KEY REFERENCES Products(ProductCode) NOT NULL,
CONSTRAINT pk_Reviews PRIMARY KEY (ReviewUser, ReviewProduct),
ReviewStars float NOT NULL,
ReviewText varchar(8000)
);

CREATE TABLE WarrantyProducts
(
WarrantyID varchar(100) PRIMARY KEY NOT NULL,
WarrantyProduct int FOREIGN KEY REFERENCES Products(ProductCode) NOT NULL,
WarrantyDescription text
);

CREATE TABLE ReturnedProducts
(
ReturnID varchar(100) PRIMARY KEY NOT NULL,
ReturnProduct int FOREIGN KEY REFERENCES Products(ProductCode) NOT NULL,
ReturnOrder int FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
ReturnDescription text
);

CREATE TABLE ResealedProducts
(
ResealID int PRIMARY KEY NOT NULL,
ResealedProduct int FOREIGN KEY REFERENCES Products(ProductCode) NOT NULL,
ResealPrice float NOT NULL
)
