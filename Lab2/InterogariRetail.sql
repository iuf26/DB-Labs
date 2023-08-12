use RetailWebsiteAdministration
go

-- Interogare 1: 1 x Where, 1 x Distinct, 1 x m-n, 1 x min(3)
-- Afiseasza toti administratorii ce au cel putin un site in administrare
SELECT DISTINCT A.Nume, A.Prenume
FROM Administrator A, AdministratorSite ADS, Site S
WHERE A.IdA = ADS.IdA and ADS.IdS = S.IdS

-- Interogare 2: 1 x Where, 1 x m-n, 1 x min(3)
-- Afiseaza toate produsele ce apartin unei categorii, iar domeniul acelei
-- categorii este IT
SELECT P.IdP, P.Nume, P.Furnizor
FROM Categorie C, CategorieProdus CP, Produs P
WHERE C.CodC = CP.CodC and CP.IdP = P.IdP and C.Domeniu LIKE 'IT'

-- Interogare 3:  1 x Where, 1 x GroupBy, 1 x Having, 1 x min(3)
-- Afiseaza adresa site-ului ce contine cel mai scump produs 
SELECT S.Adresa, P.Nume, P.Pret
FROM Site S, Categorie C, CategorieProdus CP, Produs P
WHERE S.IdS = C.IdS and C.CodC = CP.CodC and CP.IdP = P.IdP 
GROUP BY S.Adresa, P.nume, P.Pret
HAVING P.Pret = (SELECT MAX(PRET) FROM Produs) --Verificam sa aiba pretul egal cu pretul maxim de pe coloana pretului

-- Interogare 4: 1 x Where, 1 x GroupBy, 1 x Having, 1 x min(3)
-- Afisam numele utilizatorului si adresa de mail a utilizatorului cu cel mai ieftin produs din cos
SELECT C.NumeUtilizator, C.Mail, P.Nume, P.Pret
FROM Cont C, Cos CS, ProdusCos PC, Produs P
WHERE C.IdCont = CS.IdCos and CS.IdCos = PC.IdCos and PC.IdP = P.IdP
GROUP BY C.NumeUtilizator, C.Mail, P.Nume, P.Pret
HAVING P.Pret = (SELECT MIN(PRET) FROM Produs) -- vedem care este pretul minim

-- Interogare 5: 1 x Where, 1 x GroupBy, 1 x min(3)
-- Afisam cosurile sortate crescator dupa valoarea totala a produselor
SELECT C.IdCos, C.NrProduse, SUM(P.pret) as Cheltuit
FROM Cos C, ProdusCos PC, Produs P
WHERE C.IdCos = PC.IdCos and PC.IdP = P.IdP
GROUP BY C.IdCos, C.NrProduse
ORDER BY Cheltuit

-- Interogare 6: 1 x Distinct, 1 x min(3) 
-- Afiseaza toate cosurile ce au cel putin un produs in acestea
SELECT DISTINCT C.IdCos, C.NrProduse
FROM COS C, ProdusCos PC, Produs P
WHERE C.IdCos = PC.IdCos and PC.IdP = P.IdP

-- Interogare 7: 1 x min(3) 
-- Afiseasza vanzarea fiecarui site in parte
SELECT S.Adresa,C.Domeniu,P.Nume, SUM(P.Pret) as Vanzari
FROM Site S, Categorie C, CategorieProdus CP, Produs P, ProdusCos PC, Cos CS
WHERE S.IdS = C.IdS and C.CodC = CP.CodC and CP.IdP = P.IdP and P.IdP = PC.IdP and PC.IdCos = CS.IdCos
GROUP BY S.Adresa,C.Domeniu,P.Nume
ORDER BY Vanzari DESC

-- Interogare 8:
-- Afiseaza toti utilizatorii ce au adrese de mail de forma @yahoo
SELECT C.NumeUtilizator, C.Mail
FROM Cont C
WHERE C.Mail LIKE '%@yahoo%'

-- Interogare 9:
-- Afiseaza cat cheltuie un client in medie pe un site de retail
SELECT AVG(P.pret) as ChletuialaMedie
FROM Cos C, ProdusCos PC, Produs P
WHERE C.IdCos = PC.IdCos and PC.IdP = P.IdP

-- Interogare 10:
-- Afiseaza adresele de mail ce se termina cu .com
SELECT C.NumeUtilizator, C.Mail
FROM Cont C
WHERE C.Mail LIKE '%.com'
