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

use Cartier_v2
go 

insert into Blocuri(Adresa,NrApartamente,NrLocatari)
values ('Str.Mihai Viteazu nr.4', 120, 340)
insert into Blocuri(Adresa,NrApartamente,NrLocatari)
values ('Str.Mihai Viteazu nr.12', 25, 90)
insert into Blocuri(Adresa,NrApartamente,NrLocatari)
values ('Str.Lalelelor nr.11', 65, 170)

insert into Oameni(CNP, Nume, Prenume, Adresa)
values (123, 'Doica', 'Razvan', 'Str.Mihai Viteazu nr.4')
insert into Oameni(CNP, Nume, Prenume, Adresa)
values (456, 'Popescu', 'Maria', 'Str.Lalelelor nr.11')
insert into Oameni(CNP, Nume, Prenume, Adresa)
values (765, 'Andrei', 'Filip', 'Str.Mihai Viteazu nr.12')
insert into Oameni(CNP, Nume, Prenume, Adresa)
values (021, 'Doica', 'Filip', 'Str.Mihai Viteazu nr.4')

insert into Parcuri(nrBanci, nrIngirjitori)
values (24,4)
insert into Parcuri(nrBanci, nrIngirjitori)
values (10,1)
insert into Parcuri(nrBanci, nrIngirjitori)
values (54,7)

insert into Animale(Culoare,Nume,Rasa,codP,CNP)
values ('negru','Rex','caine', 1, 123)
insert into Animale(Culoare,Nume,Rasa,codP,CNP)
values ('gri','Spick','caine', 2, 123)
insert into Animale(Culoare,Nume,Rasa,codP,CNP)
values ('negru','Tania','pisica', 1, 765)
insert into Animale(Culoare,Nume,Rasa,codP,CNP)
values ('maro','Tina','pisica', 3, 456)

insert into Scoli(NrElevi, NrProfesori)
values (230, 23)
insert into Scoli(NrElevi, NrProfesori)
values (400, 44)
insert into Scoli(NrElevi, NrProfesori)
values (102, 10)
insert into Scoli(NrElevi, NrProfesori)
values (900, 88)

insert into Elevi(nrMatricol, Nume, NrS, codP)
values (301,'Emil', 3, 2)
insert into Elevi(nrMatricol,Nume, NrS, codP)
values (401,'Razvan', 4, 1)
insert into Elevi(nrMatricol,Nume, NrS, codP)
values (201,'Andrei', 2, 2)
insert into Elevi(nrMatricol,Nume, NrS, codP)
values (302,'Maria', 3, 3)
insert into Elevi(nrMatricol,Nume, NrS, codP)
values (101,'Cristina', 1, 1)
insert into Elevi(nrMatricol,Nume, NrS, codP)
values (303,'Stefan', 3, 3)

insert into Birouri(codB, NrAngajati, NrEtaje)
values (101,240,5)
insert into Birouri(codB, NrAngajati, NrEtaje)
values (102,500,7)
insert into Birouri(codB, NrAngajati, NrEtaje)
values (103,800,15)

insert into Masini(nrM, Model, Culoare, AnFabricatie, codB, Adresa)
values (10, 'BMW i8', 'alb', 2020, 101, 'Str.Mihai Viteazu nr.4')
insert into Masini(nrM, Model, Culoare, AnFabricatie, codB, Adresa)
values (11, 'Audi A8', 'negru', 2020, 101, 'Str.Mihai Viteazu nr.12')
insert into Masini(nrM, Model, Culoare, AnFabricatie, codB, Adresa)
values (12, 'BMW X6', 'alb', 2019, 103, 'Str.Mihai Viteazu nr.4')
insert into Masini(nrM, Model, Culoare, AnFabricatie, codB, Adresa)
values (13, 'Skoda Octavia', 'rosu', 2021, 101, 'Str.Lalelelor nr.11')

insert into Magazine(nrArticole, Nume)
values (340, 'Mega Image')
insert into Magazine(nrArticole, Nume)
values (1700, 'Auchan')
insert into Magazine(nrArticole, Nume)
values (500, 'Carrefour')
insert into Magazine(nrArticole, Nume)
values (1100, 'Altex')

insert into Cumparaturi(CNP, idM)
values (123, 2)
insert into Cumparaturi(CNP, idM)
values (765, 2)
insert into Cumparaturi(CNP, idM)
values (456, 1)
insert into Cumparaturi(CNP, idM)
values (123, 4)



select * from Blocuri
select * from Oameni
select * from Parcuri
select * from Animale
select * from Scoli
select * from Elevi
select * from Birouri
select * from Masini
select * from Magazine
select * from Cumparaturi

delete from Animale where Cip >4
delete from Scoli where NrS>4
delete from Magazine where idM >4

select Culoare
from Masini
select distinct Culoare
from Masini

select Rasa
from Animale
select distinct Rasa
from Animale


select *
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
--toate strazi unde sunt mai mult de 50 apartamente si ma multi de 500 angajati
select *
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
where bl.NrApartamente > 50 and bi.NrAngajati > 500

select *
from Elevi e inner join Scoli s on s.NrS=e.NrS
--toti elevii de la scoli care merg in parcul 2
select *
from Elevi e inner join Scoli s on s.NrS=e.NrS
where codP=2

select *
from Oameni o inner join Animale a on o.CNP=a.CNP
inner join Parcuri p on p.codP=a.codP --toti oamenii care au caini si ii duc in parc
select *
from Oameni o inner join Animale a on o.CNP=a.CNP
inner join Parcuri p on p.codP=a.codP 
where a.rasa='caine' and nrIngirjitori >2

select*
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
--toti oamnii care si-au facut cumparaturile in magazine cu numele 'Auchan'
select*
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
where m.Nume='Auchan'

select*
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
--toate magazinele cu articole intre 1 si 1200
--in care oamenii fac cumparaturi
select*
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
where m.nrArticole between 1 and 1200

select *
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
--toate magzinele in care au fost facute cumparaturi
--grupate dupu suma numerelor de articole > 1000
select SUM(m.nrArticole) as nrArticole_Total, m.Nume
from Oameni o inner join Cumparaturi c on o.CNP=c.CNP 
inner join Magazine m on m.idM=c.idM
group by m.Nume
having SUM(m.nrArticole) > 2000

select *	
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
--media angajatilor totali din birouri grupati dupa culoarea masini
select m.Culoare, AVG(bi.nrAngajati) as nrAngajati_mediu	
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
group by m.Culoare

select *
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
--toate strazile unde masinile au media anului de fabricatie este >2020 grupate
select AVG(m.AnFabricatie) as AnFabricatie_Mediu, bl.Adresa
from Blocuri bl inner join Masini m on bl.Adresa=m.Adresa 
inner join Birouri bi on bi.codB=m.codB
group by bl.Adresa
having  AVG(m.AnFabricatie) >=2020

