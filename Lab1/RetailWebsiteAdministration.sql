Create database RetailWebsiteAdministration
go
use RetailWebsiteAdministration
go

CREATE TABLE Administrator(

	IdA INT PRIMARY KEY,
	Nume varchar(50),
	Prenume varchar(50),
	Varsta int
)

CREATE TABLE Site(

	IdS INT PRIMARY KEY,
	Domeniu varchar(50),
	Adresa varchar(50)
)

CREATE TABLE AdministratorSite(
	
	IdA INT FOREIGN KEY REFERENCES Administrator(IdA),
	IdS INT FOREIGN KEY REFERENCES Site(IdS)
	CONSTRAINT pk_AdministratorSite PRIMARY KEY(IdA, IdS)
)

CREATE TABLE Categorie(

	CodC INT PRIMARY KEY,
	Nume varchar(50),
	Domeniu varchar(50),
	IdS int FOREIGN KEY REFERENCES Site(IdS)
)

CREATE TABLE Produs(

	IdP INT PRIMARY KEY,
	Nume varchar(50),
	Furnizor varchar(50),
	Cantitate int
)

CREATE TABLE CategorieProdus( --Poate Subcategorie ar fi un nume mai bun

	CodC INT FOREIGN KEY REFERENCES Categorie(CodC),
	IdP INT FOREIGN KEY REFERENCES Produs(IdP),
	CONSTRAINT pk_CategorieProdus PRIMARY KEY(CodC, IdP)
)

CREATE TABLE Cos(

	IdCos INT PRIMARY KEY,
	NrProduse int
)

CREATE TABLE ProdusCos(

	IdP INT FOREIGN KEY REFERENCES Produs(IdP),
	IdCos INT FOREIGN KEY REFERENCES Cos(IdCos),
	CONSTRAINT pk_ProdusCos PRIMARY KEY(IdP, IdCos)
)

CREATE TABLE Cont(

	IdCont INT FOREIGN KEY REFERENCES Cos(IdCos),
	NumeUtilizator varchar(50),
	Mail varchar(50),
	Parola varchar(50),
	CONSTRAINT pk_cont PRIMARY KEY(IdCont)
)

CREATE TABLE Persoana(

	IdPers INT FOREIGN KEY REFERENCES Cont(IdCont),
	Nume varchar(50),
	Prenume varchar(50),
	CNP int,
	Card int
	CONSTRAINT pk_persoana PRIMARY KEY(IdPers)
)