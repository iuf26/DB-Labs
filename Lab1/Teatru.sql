create database BD_Teatru
go
use BD_Teatru
go

create table Actori(Cod_act int primary key identity,
Nume varchar(50),
Prenume varchar(50),
Varsta int,
Telefon varchar(10),
CV varchar(max))

create table Adrese_actori(Cod_Act int foreign key references Actori(Cod_act),
Loc_act varchar(50),
Strada_act varchar(50),
NrStrada_act int,
Ap_act int,
CONSTRAINT pk_Adrese_actori PRIMARY KEY(Cod_Act))

create table Spectacole(Cod_Spect int primary key identity,
Denumire_spect varchar(50),
Durata int,
Gen varchar(50),
Scenarist varchar(50),
CodC int)

create table Bilete(CodB int primary key identity,
Denumire_spectacol varchar(50),
Durata varchar(50),
Rand int,
Loc int,
Pret int,
Cod_Spect int foreign key references Spectacole(Cod_Spect))



create table Scenarist(CodS int primary key identity,
Nume varchar(50),
Prenume varchar(50),
Varsta int,
Nr_spectacole int,
Denumire_spectacole int foreign key references Spectacole(Cod_Spect),
Telefon varchar(10))

create table Cladire(CodC int primary key identity,
Casa_bilete varchar(50),
Spectacole varchar(10),
Pauza varchar(10),
Email varchar(50),
Telefon varchar(10),
Cod_Spect int foreign key references Spectacole(Cod_Spect))

create table Rol(CodR int primary key identity,
Cod_act int foreign key references Actori(Cod_act))

create table ActoriSpectacole(
Cod_act int foreign key references Actori(Cod_act),
Cod_Spect int foreign key references Spectacole(Cod_Spect),
Nr_actori int,
constraint pk_ActoriSpectacole primary key (Cod_act, Cod_Spect))

create table ElementDecor(CodEl int primary key,
Descriere varchar(50))

create table DecorSpectacol(Cod_Spect int foreign key references Spectacole(Cod_Spect),
CodEl int foreign key references ElementDecor(CodEl),
Nr_elemente int,
constraint pk_DecorSpectacol primary key(Cod_Spect, CodEl))


