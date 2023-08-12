create database LumeaCartilor
go
use LumeaCartilor
go

create table GenulCartii(
IdGen int primary key identity,
Gen varchar(50) default 'Mister',
Descriere varchar(100),
NrCartiCuAcelasiGen int)

create table Carti(
IdCarte int primary key, 
Titlu varchar(50) NOT NULL,
Autor varchar(50), 
NrSerie int,
NrPagini int check (NrPagini > 20),
IdGen int foreign key references GenulCartii(IdGen)
)

create table Biblioteci(
IdBiblioteca int primary key identity(1,1),
AdresaB varchar(50),
OrarBiblioteca float,
NrCititori int
)

create table CartiBiblioteci(
IdBiblioteca int foreign key references Biblioteci(IdBiblioteca),
IdCarte int foreign key references Carti(IdCarte),
constraint pk_CartiBiblioteci primary key (IdBiblioteca, IdCarte)
)

create table AdministratorBiblioteca (
IdAdmin int foreign key references Biblioteci(IdBiblioteca), 
Nume varchar(50),
Prenume varchar(50),
Experienta int, 
constraint pk_AdministratorBiblioteca primary key (IdAdmin)
)

create table Cititori (
IdCititor int primary key, 
Nume varchar(50),
Prenume varchar(50),
Varsta int,
NrDeTelefon int,
Email varchar(50),
)

create table CartiImprumutate(
IdCarteImprum int primary key,
DataImprumut int,
DataReturn int,
nrCopiiDeCarti int
)


create table CategoriiDeVarsta(
IdCategoriiDeVarsta int primary key,
IntervalVarsta varchar(100)
)

create table CititoriCartiImprumutate(
IdCarteImprum int foreign key references CartiImprumutate(IdCarteImprum),
IdCititor int foreign key references Cititori(IdCititor), 
NrCartiImprumutate int,
constraint pk_CititoriCartiImprumutate primary key (IdCarteImprum, IdCititor)
)

create table CititoriCategoriiDeVarsta(
IdCategoriiDeVarsta int foreign key references CategoriiDeVarsta(IdCategoriiDeVarsta),
IdCititor int foreign key references Cititori(IdCititor), 
constraint pk_CititoriCategoriiDeVarsta primary key (IdCategoriiDeVarsta, IdCititor)
)

create table GenulCartiiImprumutate(
IdCarteImprum int foreign key references CartiImprumutate(IdCarteImprum),
IdGen int foreign key references GenulCartii(IdGen)
constraint pk_GenulCartiiImprumutate primary key (IdCarteImprum, IdGen)
)
