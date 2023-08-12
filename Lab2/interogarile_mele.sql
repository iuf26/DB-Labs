use CompanieCosmetice
go

-- 1.) top 5 cele mai cumparate (populare) produse
select top 5 p.Denumire, sum(c.Cantitate) as Cantitate_totala
from Comanda c, Produs p 
where c.Pid=p.Pid
group by p.Denumire, c.Cantitate
having sum(c.Cantitate) > 0
order by c.Cantitate desc

select * from Comanda
select * from Produs



-- 2.) inventarul total din magazinul Clear Skin
select a.Denumire_aux as Denumire, a.Pret_aux as Pret, a.Cantitate_aux as Nr_bucati
from (select p.Denumire as Denumire_aux, p.Pret as Pret_aux, i.Cantitate as Cantitate_aux 
from Produs p, Magazin m, Inventar i
where p.Pid=i.Pid and m.Mid=i.Mid and m.Denumire like 'Clear Skin') a

select * from Magazin
select * from Produs
select * from Inventar



-- 3.) clientii care au comandat peste 200 de lei pt a oferi transport gratuit
select cl.Nume, cl.Prenume, Pret_total=sum(p.Pret*c.Cantitate)-sum(c.Discount)
from Client cl, Comanda c, Produs p
where cl.ClId=c.ClId and c.Pid=p.Pid 
group by cl.Nume, cl.Prenume
having sum(p.Pret*c.Cantitate)-sum(c.Discount)>=200

select * from Client
select * from Comanda 
select * from Produs



-- 4.) toate colectiile de produse din magazinul My Little Shop
select distinct c.Denumire
from Colectie c, Magazin m, Produs p, Inventar i
where c.Cid=p.Cid and p.Pid=i.Pid and i.Mid=m.Mid and m.Denumire like 'My Little Shop'

select * from Magazin
select * from Colectie
select * from Produs
select * from Inventar



-- 5.) adresa la care lucreaza fiecare angajat din fabrici
select distinct a.Nume as Angajat, d.Localitate, d.Strada, d.Nr
from Angajat a, Fabrica f, Adresa d
where a.Fid=f.Fid and f.Fid=d.Aid
order by a.Nume

select * from Angajat
select * from Fabrica
select * from Adresa



-- 6.) stocul de produse din fabrici
select f.Denumire, sum(s.Cantitate) as Stoc
from FabricaProdus s, Fabrica f
where s.Fid=f.Fid
group by f.Denumire

select * from FabricaProdus
select * from Fabrica



-- 7.) top magazine cu cele mai bune vanzari
select m.Denumire, count(m.Denumire)-1 as NrVanzari
from Magazin m left outer join Inventar i on m.Mid=i.Mid left outer join Produs p on i.Pid=p.Pid left outer join Comanda c on p.Pid=c.Pid
group by m.Denumire
order by m.Denumire desc

select * from Magazin
select * from Produs
select * from Inventar
select * from Comanda



-- 8.) ce produse sunt fabricate in fabrica principala
select p.Denumire
from Fabrica f, FabricaProdus a, Produs p
where f.Fid=a.Fid and a.Pid=p.Pid and f.Denumire like 'Fabrica principala'

select * from Produs
select * from FabricaProdus
select * from Fabrica



-- 9.) produsele din colectia vara 2022 care sunt la reducere
select p.Denumire, c.Discount
from Produs p, Comanda c, Colectie l
where l.Cid=p.Cid and p.Pid=c.Pid and l.Denumire like 'vara 2022' and c.Discount>0

select * from Produs
select * from Comanda
select * from Colectie



-- 10.) sumarul comenzii clientei 'Nicolescu Corina'
select p.Denumire, p.Pret, m.Discount,m.Cantitate 
from Client c, Comanda m, Produs p
where m.ClId=c.ClId and c.Nume like 'Nicolescu' and c.Prenume like 'Corina' and m.Pid=p.Pid

select * from Client
select * from Produs
select * from Comanda