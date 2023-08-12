Create database Cartier_v2
go
use Cartier_v2
go 

CREATE TABLE Blocuri(
Adresa varchar(50) PRIMARY KEY,
NrApartamente int,
NrLocatari int)

CREATE TABLE Oameni(
CNP int primary key,
Nume varchar(50),
Prenume varchar(50),
Adresa varchar(50)foreign key references Blocuri(Adresa) )

create table Parcuri(
codP int primary key identity,
nrBanci int,
nrIngirjitori int)

create table Animale(
Cip int primary key identity,
Culoare varchar(50),
Nume varchar(50),
Rasa varchar(50),
codP int foreign key references Parcuri(codP),
CNP int foreign key references Oameni(CNP))


create table Scoli(
NrS int primary key identity,
NrElevi int,
NrProfesori int)

create table Elevi(
nrMatricol int primary key,
Nume varchar(50),
NrS int foreign key references Scoli(NrS),
codP int foreign key references Parcuri(codP))

create table Birouri(
codB int primary key,
NrAngajati int,
NrEtaje int)

create table Masini(
nrM int primary key,
Model varchar(50),
Culoare varchar(50),
AnFabricatie int,
codB int foreign key references Birouri(codB),
Adresa varchar(50) foreign key references Blocuri(Adresa))

create table Magazine(
idM int primary key identity,
nrArticole int,
Nume varchar(50))

create table Cumparaturi(
CNP int foreign key references Oameni(CNP),
idM int foreign key references Magazine(idM),
constraint pk_Cumparaturi primary key(CNP, idM))


