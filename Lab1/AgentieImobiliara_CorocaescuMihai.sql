CREATE DATABASE DiebmannImobiliare;
GO
USE DiebmannImobiliare;
GO

CREATE TABLE Sedii (
	idSediu INT PRIMARY KEY IDENTITY,
	oras VARCHAR(50) NOT NULL CHECK (oras NOT LIKE '% %'),
	adresa VARCHAR(200),
	telefon VARCHAR(15),
	email AS 'dimob'+LOWER(oras)+TRIM(STR(idSediu,10))+'@gmail.com'
)

GO

CREATE TABLE Agenti (
	idAgent INT PRIMARY KEY IDENTITY,
	idSediuAsignat INT FOREIGN KEY REFERENCES Sedii(idSediu),
	nume VARCHAR(100) NOT NULL,
	telefon VARCHAR(15),
	email VARCHAR(100)
)

CREATE TABLE Clienti (
	idClient INT PRIMARY KEY IDENTITY(1000, 27),
	nume VARCHAR(100) NOT NULL,
	telefon VARCHAR(15) NOT NULL,
	email VARCHAR(100)
)

CREATE TABLE Proprietari (
	idProprietar INT PRIMARY KEY IDENTITY(700,2),
	nume VARCHAR(100) NOT NULL,
	telefon VARCHAR(15) NOT NULL,
	email VARCHAR(100),
)

GO

CREATE TABLE ProprietateGeneral (
	idProprietate INT PRIMARY KEY IDENTITY(2100, 1),
	idProprietar INT FOREIGN KEY REFERENCES Proprietari(idProprietar),
	idAgentAsignat INT FOREIGN KEY REFERENCES Agenti(idAgent),
	tip VARCHAR(10) NOT NULL,
	oras VARCHAR(50) NOT NULL,
	zona VARCHAR(59) NOT NULL,
	adresa VARCHAR(200) NOT NULL,
	suprafata INT NOT NULL,
	CONSTRAINT ck_supraf CHECK(suprafata > 0),
	CONSTRAINT ck_tipProp CHECK(LOWER(tip) IN ('locuinta', 'spatiu', 'teren'))
)

CREATE TABLE Locuinte (
	idLocuinta INT FOREIGN KEY REFERENCES ProprietateGeneral(idProprietate),
	tipLoc VARCHAR(10) NOT NULL,
	compartimentare VARCHAR(10),
	camere INT,
	CONSTRAINT ck_idLoc PRIMARY KEY(idLocuinta),
	CONSTRAINT ck_comprt CHECK(LOWER(compartimentare) IN ('decomandat', 'semidecomandat', 'comandat')),
	CONSTRAINT ck_tipLoc CHECK(LOWER(tipLoc) IN ('apartament', 'casa', 'penthouse', 'garsoniera'))
)

CREATE TABLE Spatii (
	idSpatiu INT FOREIGN KEY REFERENCES ProprietateGeneral(idProprietate),
	tipSpatiu VARCHAR(10) NOT NULL,
	camere INT,
	CONSTRAINT ck_tipSpatiu CHECK(LOWER(tipSpatiu) IN ('comercial', 'industrial','birou')),
	CONSTRAINT ck_idSpatiu PRIMARY KEY(idSpatiu)
)

CREATE TABLE Terenuri (
	idTeren INT FOREIGN KEY REFERENCES ProprietateGeneral(idProprietate),
	tipTeren VARCHAR(10) NOT NULL,
	CONSTRAINT ck_tipTeren CHECK(LOWER(tipTeren) IN ('intravilan', 'extravilan')),
	CONSTRAINT ck_idTeren PRIMARY KEY(idTeren)
)

GO

CREATE TABLE Anunturi (
	idAnunt INT PRIMARY KEY IDENTITY(10200, 2),
	idProprietateAnunt INT FOREIGN KEY REFERENCES ProprietateGeneral(idProprietate),
	tip VARCHAR(10) NOT NULL,
	pret INT NOT NULL,
	CONSTRAINT ck_pret CHECK(pret > 0),
	CONSTRAINT ck_tip CHECK(LOWER(tip) IN ('vanzare', 'inchiriere'))
)

GO

CREATE TABLE Vizionari (
	idVizionare INT PRIMARY KEY IDENTITY(5000, 61),
	idClientSolicitant INT FOREIGN KEY REFERENCES Clienti(idClient),
	idAnuntReferent INT FOREIGN KEY REFERENCES Anunturi(idAnunt),
	dataProgramarii DATETIME NOT NULL
)

GO

CREATE TABLE Contracte (
	idContract INT PRIMARY KEY IDENTITY(78000, 71),
	idProprietateContract INT FOREIGN KEY REFERENCES ProprietateGeneral(idProprietate),
	idClientContract INT FOREIGN KEY REFERENCES Clienti(idClient),
	valoare INT NOT NULL,
	lunaTranz INT NOT NULL,
	anTranz INT NOT NULL,
	tip VARCHAR(10) NOT NULL,
	CONSTRAINT ck_tipTranz CHECK(LOWER(tip) IN ('vanzare', 'inchiriere')),
	perioada INT NOT NULL,
	CONSTRAINT ck_perioada CHECK(perioada > 5)
)
