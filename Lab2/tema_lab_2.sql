USE lab_1
GO

SELECT DISTINCT firma_productie
FROM Case_marcat


SELECT DISTINCT producator
FROM Produse


SELECT c.id_categorie, c.nume, count(r.id_raft) AS NumarRafturi
FROM Categorii_produse c, Rafturi r
WHERE c.id_categorie=r.id_categorie
GROUP BY c.id_categorie, c.nume
HAVING c.nume IN ('Alimente', 'Lichide')


SELECT m.Id_m, m.Nume, m.Prenume, avg(a.salariu) AS MediaSalariuAngajati
FROM Angajati a, Manageri m
WHERE a.id_manager=m.Id_m
GROUP BY m.Id_m, m.Nume, m.Prenume
HAVING m.Id_m>1


SELECT a.id_angajat, a.nume, a.prenume, r.id_raft, r.capacitate
FROM Angajati a, Rafturi r, Angajati_rafturi ar
WHERE ar.id_angajat=a.id_angajat AND ar.id_raft=r.id_raft


SELECT a.id_angajat, a.nume, a.prenume, r.id_raft, r.capacitate
FROM Angajati a, Rafturi r, Angajati_rafturi ar
WHERE r.id_raft>=22 AND a.id_manager=2 AND ar.id_angajat=a.id_angajat AND ar.id_raft=r.id_raft


SELECT r.id_raft, r.capacitate, r.id_raft, c.nume, c.descriere
FROM Categorii_produse c, Rafturi r
WHERE r.id_categorie=c.id_categorie


SELECT c.id_categorie, c.nume, count(p.id_produs) AS NumarProduse
FROM Categorii_produse c, Produse p
WHERE c.id_categorie=p.id_categorie
GROUP BY c.id_categorie, c.nume


SELECT c.id_categorie, c.nume, p.id_produs, p.nume, p.cantitate
FROM Categorii_produse c, Produse p
WHERE c.id_categorie=p.id_categorie AND c.id_categorie=3


SELECT  p.id_produs, p.nume, p.cantitate, d.descriere
FROM Produse p, Descriere_produse d
WHERE p.id_produs=d.id_produs