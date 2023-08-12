USE CompanieAeriana
GO

-- ============================================================================= --

---- Sa se afiseze numele pasagerilor cu varsta mai mare de 30 de ani.
---- WHERE
--SELECT * FROM Pasageri

--SELECT Nume, Varsta FROM Pasageri 
--WHERE Varsta > 30

---- Sa se afiseze numele si numarul de rezervari ale pasagerilor care locuiesc in Cluj-Napoca.
---- WHERE
--SELECT * FROM Pasageri

--SELECT Nume, NrRezervari AS NumarRezervari, Adresa FROM Pasageri
--WHERE Adresa LIKE '%Cluj-Napoca%'

---- Sa se afiseze Codul Rezervarii si CNP-ul Pasagerilor care au rezervari care ajung in Cluj-Napoca.
---- WHERE
--SELECT * FROM Rezervari

--SELECT CodR AS CodulRezervarii, CNPPasager, LocP AS LocatiaPlecarii, LocS AS LocatiaSosirii FROM Rezervari
--WHERE LocS = 'Cluj-Napoca'

-- ============================================================================= --

-- 1. Sa se afiseze toate avioanele cu capacitatea mai mica de 400 de pasageri.
-- WHERE

SELECT * FROM Avioane

SELECT Nume, Capacitate FROM Avioane
WHERE Capacitate < 400

-- 2. Sa se selecteze varstele maxime ale Pasagerilor, grupate dupa numarul de rezervari.
-- GROUP BY
SELECT * FROM Pasageri

SELECT MAX(Varsta) AS VarstaMaxima, NrRezervari FROM Pasageri
GROUP BY NrRezervari

-- 3. Sa se numere Personalul Auxiliar, grupati dupa rolul acestora, daca sunt mai putin de 3 persoane cu acest rol.
-- GROUP BY, HAVING
SELECT * FROM PersonalAuxiliar

SELECT Rol, COUNT(CNP) AS NumarPersoane FROM PersonalAuxiliar
GROUP BY Rol
HAVING COUNT(CNP) < 3

-- 4. Sa se afiseze numele distincte ale avioanelor care transporta pasageri cu rezervari ce ajung in Cluj-Napoca.
-- DISTINCT, WHERE, MAI MULT DE 2 TABELE
SELECT * FROM Avioane
SELECT * FROM Pasageri
SELECT * FROM Rezervari

SELECT DISTINCT a.Nume 
FROM Avioane a, Pasageri p, Rezervari r
WHERE p.CNP = r.CNPPasager AND p.CodA = a.CodA AND r.LocS = 'Cluj-Napoca'

-- 5. Sa se afiseze numele distincte si capacitatile ale avioanelor care opereaza la aeroportul Bucuresti.
-- DISTINCT, WHERE, MAI MULT DE 2 TABELE, TABELA M-N
SELECT * FROM Avioane
SELECT * FROM Aeroporturi
SELECT * FROM AvioaneAeroporturi

SELECT DISTINCT av.Nume, av.Capacitate
FROM Avioane av, Aeroporturi ae, AvioaneAeroporturi aa
WHERE av.CodA = aa.CodAv AND aa.CodAp = ae.CodA AND ae.Locatie = 'Bucuresti'

-- 6. Sa se afiseze varstele pilotilor care executa zboruri operate de agentii de voiaj din Cluj-Napoca, doar daca sunt macar 2 cu acea varsta.
-- GROUP BY, WHERE, HAVING, MAI MULT DE 2 TABELE
SELECT * FROM AgentiiVoiaj
SELECT * FROM Zboruri
SELECT * FROM Piloti

SELECT p.Varsta, COUNT(p.Varsta) AS PilotiCuVarsta
FROM Piloti p, Zboruri z, AgentiiVoiaj av
WHERE p.CodP = z.CodZ AND z.CodAV = av.CodA AND av.Adresa LIKE '%Cluj-Napoca%'
GROUP BY p.Varsta
HAVING COUNT(p.Varsta) >= 2

-- 7. Sa se afiseze numele distincte ale avioanelor care opereaza pe aeroporturi unde lucreaza curatatori.
-- DISTINCT, WHERE, MAI MULT DE 2 TABELE, TABELA M-N
SELECT * FROM PersonalAuxiliar
SELECT * FROM Avioane
SELECT * FROM Aeroporturi
SELECT * FROM AvioaneAeroporturi

SELECT DISTINCT av.Nume
FROM Avioane av, Aeroporturi ae, AvioaneAeroporturi aa, PersonalAuxiliar pa
WHERE av.CodA = aa.CodAv AND aa.CodAp = ae.CodA AND pa.CodA = ae.CodA AND pa.Rol = 'Curatator'

-- 8. Sa se afiseze numele distincte ale producatorilor care au fabricat avioane in care calatoresc pasageri cu varsta mai mare de 50 de ani.
-- WHERE, DISTINCT, MAI MULT DE 2 TABELE

SELECT * FROM Producatori
SELECT * FROM Avioane
SELECT * FROM Pasageri

SELECT DISTINCT pr.Nume
FROM Producatori pr, Avioane a, Pasageri pa
WHERE pr.CodP = a.CodP AND pa.CodA = a.CodA AND pa.Varsta > 50

-- 9. Sa se afiseze numele pasagerilor care calatoresc cu un 747 si au o rezervare din Suceava.
-- WHERE, MAI MULT DE 2 TABELE
SELECT * FROM Rezervari
SELECT * FROM Pasageri
SELECT * FROM Avioane

SELECT p.Nume
FROM Pasageri p, Rezervari r, Avioane a
WHERE p.CNP = r.CNPPasager AND p.CodA = a.CodA AND a.Nume = '747' AND r.LocP = 'Suceava'

-- 10. Sa se afiseze adresele distincte ale agentiilor de voiaj care opereaza zboruri pilotate de piloti cu varsta mai mare de 40 de ani.
-- WHERE, DISTINCT, MAI MULT DE 2 TABELE

SELECT * FROM AgentiiVoiaj
SELECT * FROM Zboruri
SELECT * FROM Piloti

SELECT DISTINCT av.Adresa
FROM AgentiiVoiaj av, Zboruri z, Piloti p
WHERE z.CodAV = av.CodA AND z.CodZ = p.CodP AND p.Varsta > 40

-- ============================================================================= --
