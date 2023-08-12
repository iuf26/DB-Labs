go
use BD_Teatru
go


---1.Toti actorii dintr-o anumita piesa de teatru
select a.Nume
from Spectacole s, ActoriSpectacole act, Actori a
where a.Cod_act = act.Cod_act and s.Cod_Spect = act.Cod_Spect and s.Denumire_spect = 'O noapte furtunoasa'
group by a.Nume


---2.Toate elementele de decor dintr-o anumita piesa de teatru
select e.CodEl, e.Descriere
from ElementDecor e, DecorSpectacol d, Spectacole s
where e.CodEl = d.CodEl and s.Cod_Spect = d.Cod_Spect and s.Denumire_spect = 'D-ale carnavalului'
group by e.CodEl, e.Descriere


---3.Autorii pentru fiecare spectacol
Select distinct Denumire_spect, Autor
from Spectacole


--4.Numarul de bilete vandute la fiecare spectacol
select Denumire_spectacol,
count(CodB) as [Numar bilete]
from Bilete
group by Denumire_spectacol



--5.Organizatorii dintr-o anumita piesa de teatru
select o.Nume
from Organizatori o , Organizare org, Spectacole s
where o.CodO = org.CodO and s.Cod_Spect = org.Cod_Spect and s.Denumire_spect = 'D-ale carnavalului'
group by o.Nume


--6.Afisarea actorilor care au jucat in mai mult de 2 piese
select a.Nume, count(*) as [Piese jucate]
from Actori a, Spectacole s, ActoriSpectacole asp
where a.Cod_act = asp.Cod_act and s.Cod_Spect = asp.Cod_Spect
group by a.Nume
having count(*) > 2


--7.Afisarea organizatorilor care s-au implicat  in mai mult de 2 piese
select a.Nume, count(*) as [Numar piese]
from Organizatori a, Spectacole s, Organizare asp
where a.CodO = asp.CodO and s.Cod_Spect = asp.Cod_Spect
group by a.Nume
having count(*) > 2


--8.Afisarea spectacolelor care au cel putin 2 melodii
select a.Denumire_spect, count(*) as [Numar melodii]
from Spectacole a, Melodie m, Playlist p
where a.Cod_Spect = p.Cod_Spect and m.CodM = p.CodM
group by a.Denumire_spect
having count(*) > 1


--9.Afisearea melodiilor dintr o anumita piesa de teatru
select * from Melodie m inner join Playlist p on m.CodM = p.CodM
inner join Spectacole s on s.Cod_Spect = p.Cod_Spect
where s.Denumire_spect = 'D-ale carnavalului'


--10.Afisarea pretului pt fiecare spectacol
Select distinct Pret, Denumire_spectacol
from Bilete
