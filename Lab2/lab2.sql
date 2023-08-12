USE farmacie_database

INSERT INTO farmacie(farmacie_id, denumire, oras)
VALUES (1, 'Catena', 'Cluj'), (2, 'Sensiblu', 'Oradea'), (3, 'Dona', 'Timisoara'), (4, 'Catena', 'Arad'), (5, 'Dona', 'Cluj'), (6, 'Sensiblu', 'Cluj')

INSERT INTO manager(manager_id, nume, prenume, vechime)
VALUES (1, 'Pop', 'Andreea', 2), (2, 'Bogdan', 'Tudor', 3), (3, 'Popescu', 'Alexandra', 1), (4, 'Ilie', 'Roxana', 5), (5, 'Maxim', 'Claudiu', 7), (6, 'Costin', 'Tudor', 8)

INSERT INTO farmacist(farmacist_id, nume, prenume, farmacie_id)
VALUES (1, 'Ilea', 'Dan', 1), (2, 'Tatar', 'Oana', 2), (3, 'Pintea', 'Dorin', 3), (4, 'Pasca', 'Serban', 4), (5, 'Calauz', 'Marian', 5), (6, 'Filip', 'Sebastian', 4), (7, 'Marinescu', 'Daniela', 2), (8, 'Bud', 'David', 6)

INSERT INTO client(client_id, nume, prenume, farmacie_id)
VALUES (1, 'Sofron', 'Vasile', 1), (2, 'Pop', 'Horatiu', 1), (3, 'Chiuzbaian', 'Rares', 2), (4, 'Munteanu', 'Mihai', 2), (5, 'Berende', 'David', 3), (6, 'Curac', 'Mihai', 4),
(7, 'Vele', 'Radu', 5), (8, 'Ferne', 'Raul', 5), (9, 'Domocos', 'Rebeca', 2), (10, 'Coste', 'Ioana', 3), (11, 'Deac', 'Denisa', 4), (12, 'Moldovan', 'Bogdana', 1)

INSERT INTO reteta(reteta_id, valoare, numar_medicamente, client_id)
VALUES (1, 100, 5, 1), (2, 150, 2, 2), (3, 200, 3, 3), (4, 70, 3, 4), (5, 600, 9, 5),(6, 200, 2, 6), (7, 110, 4, 6), (8, 140, 3, 11), (9, 170, 4, 10), (10, 240, 5, 9)

INSERT INTO card_client(card_client_id, nume, prenume, data_expirare)
VALUES (1, 'Sofron', 'Vasile', '2022-12-15'), (2, 'Pop', 'Horatiu', '2022-07-17'), (3, 'Chiuzbaian', 'Rares', '2023-03-22')

INSERT INTO producator(producator_id, nume, sediu, numar_angajati)
VALUES (1, 'Pfizer', 'New York', '2500'), (2, 'Zentiva', 'Praga', '4500')

INSERT INTO medicament(medicament_id, denumire, substanta, producator_id, pret)
VALUES (1, 'Advil', 'Ibuprofen', '1', 50), (2, 'Sab Simplex', 'Dimeticon', '1', 70), (3, 'Dicarbocalm', 'Carbonat de calciu', '2', 20), (4, 'Furosemid', 'Furosemida', '2', 30)

INSERT INTO medicament_farmacie(medicament_id, farmacie_id)
VALUES (1, 2), (1, 3), (1, 5), (2, 4), (3, 4), (3, 3), (4, 5), (4, 1), (4, 2), (3, 5), (2, 5) 

INSERT INTO vanzare(vanzare_id, suma, data_vanzare, farmacie_id)
VALUES (1, 7000, '2021-10-24', 1), (2, 9000, '2021-10-24', 2), (3, 2500, '2021-10-25', 6)


-- Afisati managerul fiecarei farmacii si vechimea acestuia

select denumire, nume, prenume, vechime
from farmacie, manager
where farmacie.farmacie_id = manager.manager_id


-- Afisati in ordine descrescatoare numarul de farmacii din fiecare oras

select distinct farmacie.oras, count(farmacie.oras) as numar_farmacii_in_oras
from farmacie
group by farmacie.oras
order by numar_farmacii_in_oras DESC


-- Afisati managerii care au o vechime mai mica de 5 ani

select  manager.vechime, nume, prenume
from manager, farmacie
group by manager.vechime, manager.nume, manager.prenume
having manager.vechime < 5


-- Afisati numele si prenumele managerilor care administreaza farmacii in Cluj, unde exista incasari zilnice ce nu depasesc 3000 de lei

select manager.nume, prenume
from manager, farmacie, vanzare
where manager.manager_id = farmacie.farmacie_id and farmacie.oras = 'Cluj' and farmacie.farmacie_id = vanzare.farmacie_id and vanzare.suma < 3000


-- Afisati numarul de vanzari pe baza de reteta medicala din fiecare farmacie

select farmacie.farmacie_id, farmacie.denumire, count(reteta.numar_medicamente) as NumarRetete
from farmacie, reteta, client
where farmacie.farmacie_id = client.farmacie_id and reteta.client_id = client.client_id
group by farmacie.farmacie_id, farmacie.denumire


-- Afisati o lista cu fiecare farmacist si seful sau

select farmacist.nume as NumeFarmacist, farmacist.prenume as PrenumeFarmacist, manager.nume as NumeSef, manager.prenume as PrenumSef
from farmacist, farmacie, manager
where farmacist.farmacie_id = farmacie.farmacie_id and manager.manager_id = farmacie.farmacie_id


-- Afisati numele producatorilor care fac medicamente ce se vand in farmaciile din Cluj

select distinct producator.nume
from producator, medicament, medicament_farmacie, farmacie
where producator.producator_id=medicament.producator_id and medicament.medicament_id=medicament_farmacie.medicament_id and medicament_farmacie.farmacie_id=farmacie.farmacie_id and farmacie.oras='Cluj'


-- Afisati ID-urile clietilor ce au carduri valabile pana la sfarsitul anului 2022

select card_client.card_client_id, card_client.nume as Nume, card_client.prenume as Prenume
from card_client, client, farmacie
where client.client_id=card_client.card_client_id and client.farmacie_id = farmacie.farmacie_id
group by card_client.card_client_id, card_client.data_expirare, card_client.nume, card_client.prenume
having card_client.data_expirare < '2023-01-01'


-- Afisati pretul mediu al unui medicament in fiecare farmacie

select farmacie.farmacie_id, farmacie.denumire, avg(medicament.pret) as average
from farmacie, medicament, medicament_farmacie
where medicament.medicament_id = medicament_farmacie.medicament_id and farmacie.farmacie_id = medicament_farmacie.farmacie_id
group by farmacie.farmacie_id, farmacie.denumire


-- Afisati ID-urile cardurilor clientilor ale caror retete depasesc suma de 100 lei

select card_client.card_client_id
from card_client, client, reteta
where client.client_id=card_client.card_client_id and reteta.client_id=client.client_id and reteta.valoare>100
group by card_client.card_client_id


-- Afisati toate lanturile de farmacii

select distinct farmacie.denumire
from farmacie


