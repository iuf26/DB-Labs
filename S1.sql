USE master
GO
IF(EXISTS(SELECT * FROM sys.databases WHERE name='S1')) 
DROP DATABASE S1 
ELSE CREATE DATABASE S1;
GO
USE S1;
GO

CREATE TABLE TipuriMuzee(
Tid INT PRIMARY KEY IDENTITY,
Tip VARCHAR(100),
Descriere VARCHAR(100));

CREATE TABLE Muzee(
Mid INT PRIMARY KEY IDENTITY,
Denumire VARCHAR(50),
Localitate VARCHAR(50),
Strada VARCHAR(50),
Numar INT,
Tid INT FOREIGN KEY REFERENCES TipuriMuzee(Tid)
ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE Angajati(
Aid INT PRIMARY KEY IDENTITY,
Nume VARCHAR(50),
Prenume VARCHAR(60), 
Varsta INT,
Experienta INT,
Mid INT FOREIGN KEY REFERENCES Muzee(Mid)
ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE Vizitatori(
Vid INT PRIMARY KEY IDENTITY,
Nume VARCHAR(200),
Varsta INT);

CREATE TABLE Vizite(
Mid INT FOREIGN KEY REFERENCES Muzee(Mid) ON UPDATE CASCADE ON DELETE CASCADE,
Vid INT FOREIGN KEY REFERENCES Vizitatori(Vid)ON UPDATE CASCADE ON DELETE CASCADE,
DataVizita DATE,
PretBilet INT
CONSTRAINT PK_Vizite PRIMARY KEY(Mid, Vid));

-- insert
INSERT INTO TipuriMuzee VALUES ('Stiinta', 'inventii realizate de-a lungul secolelor'),
('Istorie', 'artefacte conservate pe parcusul secolelor XIX, XX')

INSERT INTO Muzee VALUES ('Muzeul National de Stiinta', 'Bucuresti', 'B-dul 1 Decembrie', 14, 1),
('Muzeul de Istorie Conteporana', 'Cluj Napoca', 'Eroilor', 10, 2)

INSERT INTO Angajati VALUES ('Popescu', 'Dan', 34, 5, 1), ('Dan', 'Bianca', 41, 12, 2)

INSERT INTO Vizitatori VALUES ('Alin', 19), ('Paula', 35)

INSERT INTO Vizite VALUES (1, 1, '04/05/2022', 30), (1, 2, '02/03/2022', 60), (2, 1, '10/04/2022', 45)

-- select
SELECT * FROM TipuriMuzee
SELECT * FROM Muzee
SELECT * FROM Angajati
SELECT * FROM Vizitatori
SELECT * FROM Vizite

-- 1-n: Muzee - Angajati




