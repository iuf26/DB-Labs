/*use master;
ALTER DATABASE InstallationCompany SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
drop database InstallationCompany
*/

Create database  InstallationCompany
go 
use InstallationCompany
go 


Create TABLE Plumbers
(Pid INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Experience INT DEFAULT 0, 
Review INT NOT NULL) 

INSERT INTO Plumbers (Name, Experience, Review) VALUES ('Radu', 12, 10), ('Mihai',11,9), ('Adi', 9, 7), ('Mircea', 8, 8); 
SELECT *FROM Plumbers; 

Create TABLE Engineers
(Eid INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Experience INT DEFAULT 0,
Review INT NOT NULL)

INSERT INTO Engineers(Name, Experience, Review) VALUES ('Florin',12,10), ('Paul',8,9), ('Rares',10,10); 
SELECT *FROM Engineers; 


Create TABLE EngineersPlumbers
(Eid INT FOREIGN KEY REFERENCES Engineers(Eid), 
Pid INT FOREIGN KEY REFERENCES Plumbers(Pid), 
CONSTRAINT pk_EngineersPlumbers PRIMARY KEY(Eid, Pid)
) 

INSERT INTO EngineersPlumbers(Eid, Pid) VALUES (1,2), (2,1);
SELECT *FROM EngineersPlumbers; 

Create TABLE Sellers
(Sid INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Experience INT DEFAULT 0, 
Review INT NOT NULL) 

INSERT INTO Sellers(Name, Experience, Review) VALUES ('Adina',5,5), ('Iasmina',10,3), ('Geanina',9,9); 
SELECT *FROM Sellers;

Create TABLE Shops
(ShopId INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Address varchar(50) NOT NULL, 
NoOfClients int DEFAULT 0, 
NoOfMaterials int DEFAULT 0, 
NoOfTools int DEFAULT 0) 

INSERT INTO Shops(Name, Address, NoOfClients, NoOfMaterials, NoOfTools) VALUES ('Magazin1', 'str Rapsodiei', 100, 1000, 300), ('Magazin2', 'str Republicii', 60, 300, 200); 
SELECT *From Shops; 


Create TABLE ShopsSellers
(Sid INT FOREIGN KEY REFERENCES Sellers(Sid), 
ShopId INT FOREIGN KEY REFERENCES Shops(ShopId),
CONSTRAINT pk_ShopsSellers PRIMARY KEY(Sid, ShopId) 
) 

INSERT INTO ShopsSellers(Sid, ShopId) VALUES (1,1) , (1,2), (2,2), (3,1), (3,2); 
SELECT *From ShopsSellers; 

Create TABLE Deposits
(Did INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Address varchar(50) NOT NULL, 
NoOfMaterials int DEFAULT 0, 
NoOfTools int DEFAULT 0, 
Capacity int CHECK (Capacity=10000 OR Capacity=20000),
) 

INSERT INTO Deposits(Name, Address, NoOfMaterials, NoOfTools, Capacity) VALUES ('Depozit1', 'str Aviatorilor', 100, 1000, 10000), 
('Depozit2', 'str Bucovina', 100, 1000, 20000), ('Depozit3', 'str Bistritei', 200, 200, 20000); 
SELECT *From Deposits; 


Create TABLE Materials
(Mid INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Quantity int, 
Price int, 
Pid int FOREIGN KEY REFERENCES Plumbers(Pid),

Did int FOREIGN KEY REFERENCES Deposits(Did)


) 

INSERT INTO Materials(Name, Quantity, Price, Pid, Did) VALUES ('Tevi', 500, 100, 1, 1), ('Silicon',100,100,1,2), ('Robinete',330,400,2,2);
SELECT *From Materials; 


Create TABLE Tools
(Tid INT PRIMARY KEY IDENTITY, 
Name varchar(50) NOT NULL, 
Quantity int, 
Price int, 
Pid int FOREIGN KEY REFERENCES Plumbers(Pid),
Did int FOREIGN KEY REFERENCES Deposits(Did))

INSERT INTO Tools(Name, Quantity, Price, Pid, Did) VALUES ('Pistol cu silicon', 100, 100, 1, 2), ('Ciocan',230,20, 2, 1), ('Surubelnita',13,3,2,2); 
SELECT *From Tools; 

Create TABLE DepositsShops
(Did INT FOREIGN KEY REFERENCES Deposits(Did), 
ShopId INT FOREIGN KEY REFERENCES Shops(ShopId), 
CONSTRAINT pk_DepositsShops PRIMARY KEY(Did, ShopId) 
)


Create TABLE Cars
(Cid INT FOREIGN KEY REFERENCES Plumbers(Pid), 
Brand varchar(50), 
Capacity int CHECK (Capacity=75 OR Capacity=90),
DateOfPurchase int,
CONSTRAINT pk_Cars PRIMARY KEY(Cid) 
) 



INSERT INTO Cars(Cid, Brand, Capacity, DateOfPurchase) VALUES (1,'Ford',75,2009), (2,'Skoda',90,2012), (3,'VW',75,2016), (4,'Mazda',75,2011);
SELECT *From Cars; 




