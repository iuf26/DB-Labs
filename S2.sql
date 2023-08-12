USE master
GO
IF(EXISTS(SELECT * FROM sys.databases WHERE name='S2'))
DROP DATABASE S2
ELSE CREATE DATABASE S2;
GO
USE S2;
GO

CREATE TABLE TipuriMasini(
Tid INT PRIMARY KEY IDENTITY,
Tip VARCHAR(100),
Descriere VARCHAR(100));

CREATE TABLE Masini(
Mid INT PRIMARY KEY IDENTITY,
Marca VARCHAR(50),
Model VARCHAR(50),
Carburant VARCHAR(50),
Tid INT FOREIGN KEY REFERENCES TipuriMasini(Tid) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE TipuriCurse(
TCid INT PRIMARY KEY IDENTITY,
Denumire VARCHAR(50),
Descriere VARCHAR(50));

CREATE TABLE Curse(
Cid INT PRIMARY KEY IDENTITY,
Denumire VARCHAR(200),
DataIncepere DATE,
DataFinalizare DATE, 
TaxaParticipare INT,
TCid INT FOREIGN KEY REFERENCES TipuriCurse(TCid) ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE RulariPiste(
Mid INT FOREIGN KEY REFERENCES Masini(Mid) ON UPDATE CASCADE ON DELETE CASCADE,
Cid INT FOREIGN KEY REFERENCES Curse(Cid)ON UPDATE CASCADE ON DELETE CASCADE,
Timp INT,
Premiu INT
CONSTRAINT PK_RulariPiste PRIMARY KEY(Mid, Cid));

-- insert
INSERT INTO TipuriMasini VALUES ('Hibrid', 'descriere Hibrid'), ('Electric', 'descriere Electric')

INSERT INTO Masini VALUES ('Toyota', 'TS040 Hybrid Race Car', 'Hibrid', 1), ('NIssan', 'TS040 Hybrid Race Car', 'Electric', 2)

INSERT INTO TipuriCurse VALUES ('Internationale', 'high level'), ('Locale', 'medii'), ('Regionale', 'medii')

INSERT INTO Curse VALUES ('Le Mans', '02/09/2022', '12/09/2022', 500, 1), ('Roterdam Race', '05/05/2022', '10/05/2022', 380, 2)

INSERT INTO RulariPiste VALUES (1, 1, 230, 3), (1, 2, 490, 0)

-- select
SELECT * FROM TipuriMasini
SELECT * FROM Masini
SELECT * FROM TipuriCurse
SELECT * FROM Curse
SELECT * FROM RulariPiste

-- 1-n: TipuriCurse - Curse




