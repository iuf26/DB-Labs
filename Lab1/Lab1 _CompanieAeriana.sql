CREATE DATABASE CompanieAeriana
GO

USE CompanieAeriana
GO


CREATE TABLE Producatori
(
	CodP INT PRIMARY KEY IDENTITY,
	Nume VARCHAR(64)
)


CREATE TABLE Avioane
(
	CodA INT PRIMARY KEY IDENTITY,
	Nume VARCHAR(64) NOT NULL,
	Capacitate INT,
	CodP INT FOREIGN KEY REFERENCES Producatori(CodP)
)


CREATE TABLE Pasageri
(
	CNP BIGINT PRIMARY KEY,
	Nume VARCHAR(64) NOT NULL,
	Varsta INT,
	Adresa VARCHAR(256),
	NrRezervari INT,
	CodA INT FOREIGN KEY REFERENCES Avioane(CodA)
)


CREATE TABLE AgentiiVoiaj
(
	CodA INT PRIMARY KEY IDENTITY,
	Adresa VARCHAR(256)
)


CREATE TABLE Rezervari
(
	CodR INT PRIMARY KEY IDENTITY,
	CNPPasager BIGINT FOREIGN KEY REFERENCES Pasageri(CNP),
	LocP VARCHAR(64),
	LocS VARCHAR(64),
	CodAV INT FOREIGN KEY REFERENCES AgentiiVoiaj(CodA)
)


CREATE TABLE Zboruri
(
	CodZ INT PRIMARY KEY IDENTITY,
	LocP VARCHAR(64),
	LocS VARCHAR(64),
	OraP DATETIME,
	OraS DATETIME,
	CodAV INT FOREIGN KEY REFERENCES AgentiiVoiaj(CodA)
)


CREATE TABLE Aeroporturi
(
	CodA INT PRIMARY KEY IDENTITY,
	Locatie VARCHAR(256)
)


CREATE TABLE PersonalAuxiliar
(
	CNP BIGINT PRIMARY KEY,
	Nume VARCHAR(64) NOT NULL,
	Varsta INT,
	Rol VARCHAR(64),
	CodA INT FOREIGN KEY REFERENCES Aeroporturi(CodA)
)


CREATE TABLE Piloti
(
	CodP INT FOREIGN KEY REFERENCES Zboruri(CodZ),
	Nume VARCHAR(64),
	Varsta INT,
	CONSTRAINT pk_Piloti PRIMARY KEY(CodP)
)


CREATE TABLE AvioaneAeroporturi
(
	CodAv INT FOREIGN KEY REFERENCES Avioane(CodA),
	CodAp INT FOREIGN KEY REFERENCES Aeroporturi(CodA),
	CONSTRAINT pk_AvioaneAeroporturi PRIMARY KEY (CodAv, CodAp)
)