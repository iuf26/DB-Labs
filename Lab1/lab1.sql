create database CompanieCosmetice
go
use CompanieCosmetice
go

create table Fabrica
(
Fid int primary key identity,
Denumire varchar(50) not null,
NrAngajati int not null
)

create table Adresa
(
Aid int foreign key references Fabrica(Fid),
Strada varchar(50) not null,
Localitate varchar(50) not null,
Nr int not null
constraint pk_Adresa primary key(Aid)
)

create table Angajat
(
AnId int primary key identity,
Fid int foreign key references Fabrica(Fid),
Nume varchar(50) not null,
Salariu int
)

create table Colectie
(
Cid int primary key identity,
Denumire varchar(50),
Valabilitate int,
NrProduse int
)

create table Produs
(
Pid int primary key identity,
Denumire varchar(50),
Cid int foreign key references Colectie(Cid),
Pret int,
Cantitate int
)

create table FabricaProdus
(
Fid int foreign key references Fabrica(Fid),
Pid int foreign key references Produs(Pid),
Cantitate int,
constraint pk_FabricaProdus primary key (Fid, Pid)
)

create table Client 
(
ClId int primary key identity,
Nume varchar(50),
Prenume varchar(50),
Email varchar(50) 
)

create table Comanda 
(
ClId int foreign key references Client(ClId),
Pid int foreign key references Produs(Pid),
Discount int,
Cantitate int
constraint pk_Comanda primary key(ClId, Pid) 
)

create table Magazin
(
Mid int primary key identity,
Denumire varchar(50),
NrClienti int
)

create table Inventar
(
Pid int foreign key references Produs(Pid),
Mid int foreign key references Magazin(Mid),
cantitate int
constraint pk_Inventar primary key(Pid, Mid)
)

