create table CategorieProdus
(cID int primary key,
denumire varchar(10),
descriere varchar(10))

create table Producator
(pID int primary key,
denumire_companie varchar(10) not null,
telefon_companie varchar (10) not null,
adresa_companie varchar (30) not null,
tara varchar (15))

create table Suvenir
(suvID int primary key,
denumire varchar(10) not null,
pID int foreign key references Producator(pID),
cID int foreign key references CategorieProdus(cID),
material varchar(10) not null,
marime varchar(10) not null,
disponibilitate varchar(2),
constraint CHK_disp check (disponibilitate='da' or disponibilitate='nu'))

create table Patron
(patID int primary key,
adresa varchar(15),
telefon varchar(10))

create table TipMagazin
(tmID int primary key,
tipul varchar(15),
constraint CHK_tip check (tipul='hipermarket' or tipul='supermarket' or tipul='minimarket'),
numar_produse int,
medie_zilnica_clienti int)

create table Magazin
(mID int primary key,
nr_angajati int,
adresa varchar(15),
rating int,
tipID int foreign key references TipMagazin(tmID),  
constraint CHK_rating check (rating>0 and rating<6),
patID int foreign key references Patron(patID))

create table Suvenir_Magazin
(mID int foreign key references Magazin(mID),
suvID int foreign key references Suvenir(suvID),
primary key(mID,suvID))

create table Client
(clientID int primary key,
adresa varchar(15) not null,
telefon varchar(10) not null)  

create table FirmaTransport
(fID int primary key,
nume varchar(10),
capacitate int,
metoda_transport varchar(10),
constraint CHK_metoda check (metoda_transport='apa' or metoda_transport='aer' or metoda_transport='sol'))

create table Comanda
(comandaID int primary key,
clientID int foreign key references Client(clientID),
suvID int foreign key references Suvenir(suvID),
fID int foreign key references FirmaTransport(fID),
cantitate int,
pret float,
zi date)
