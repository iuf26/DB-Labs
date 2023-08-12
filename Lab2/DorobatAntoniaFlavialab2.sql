USE InstallationCompany
go 




--vrem sa vedem pentru fiecare magazin, cati vanzatori lucreaza in el 
--relatie n-m 
--aici se afiseaza si magazinele in care nu lucreaza niciun vanzator (inaugurate recent)

SELECT shop.ShopId, shop.Name,  COUNT(ss.ShopId) as noOfEmployees
FROM ShopsSellers ss RIGHT JOIN Shops shop ON shop.ShopId=ss.ShopId
GROUP BY shop.ShopId, shop.Name
ORDER BY shop.Name

--vrem sa vedem numele inginerilor care au instalatori subordonati si nr de subordonati pt fiecare
--relatie n-m
--group by
--Inginerul Rares nu apare aici ptc el nu are instalatori subordonati 
SELECT e.name as nameEngineer, COUNT(ep.Pid) as noOfWorkers
FROM EngineersPlumbers ep LEFT JOIN Engineers e ON e.Eid=ep.Eid
GROUP BY e.Eid, e.Name
ORDER BY e.Name


--vrem sa vedem magazinele care au mai mult de 3 angajati
--having, group by
--in magazinele 3 si 4 lucreaza doar 2 angajati
SELECT shop.ShopId, shop.Name, COUNT(ss.ShopId) as noOfEmployees
FROM ShopsSellers ss RIGHT JOIN Shops shop ON shop.ShopId=ss.ShopId 
GROUP BY shop.ShopId, shop.Name
HAVING COUNT(ss.ShopId)>3
ORDER BY COUNT(ss.ShopId) DESC


--vrem sa vedem inginerii care au mai mult de 2 instalatori subordonati 
--having, group by, date din mai multe tabele

SELECT e.name as nameEngineer, COUNT(ep.Pid) as noOfWorkers
FROM EngineersPlumbers ep LEFT JOIN Engineers e ON e.Eid=ep.Eid
GROUP BY e.Eid, e.Name
HAVING COUNT(ep.Pid)>2
ORDER BY COUNT(ep.Pid) DESC


--vrem acei ingineri care are review-ul mai mare de 8
SELECT e.Eid as id, e.name as name, e.Review as Review
FROM Engineers e 
WHERE e.Review>8
ORDER BY Review DESC

--vrem sa afisam tool-urile care se gasesc in cantitate mai mica de 100
SELECT t.Tid as id, t.name as name 
FROM Tools t 
WHERE t.Quantity<100
ORDER BY Quantity DESC 




--toate strazile distincte pe care exista depozite ale firmei, indiferent daca pe acea strada sunt mai multe depozite
SELECT DISTINCT d.Address as address 
FROM Deposits d
ORDER BY address


--toate ustensilele distincte ale firmei, indiferent de instalatorul caruia ii apartin sau de depozitul la care se afla
SELECT DISTINCT t.Name as Tool
FROM Tools t
ORDER by Tool

--id-ul si numele inginerilor care au instalatori subordonati cu mai putin de 10 ani experienta
--relevanta pt concedieri 
SELECT DISTINCT e.Eid as idEngineer, e.name as nameEngineer 
FROM Engineers e INNER JOIN EngineersPlumbers ep ON e.Eid=ep.Eid INNER JOIN Plumbers p ON ep.Pid=p.Pid
WHERE p.Experience<10

--id-ul si numele inginerilor care au instalatori subordonat cu review mai mic de 8
--relevanta pt concedieri
SELECT DISTINCT e.Eid as idEngineer, e.name as nameEngineer 
FROM Engineers e INNER JOIN EngineersPlumbers ep ON e.Eid=ep.Eid INNER JOIN Plumbers p ON ep.Pid=p.Pid
WHERE p.Review<8

--id-ul si numele inginerilor care lucreaza cu instalatori cu masini mai vechi de 2010
--relevanta pt atunci cand se doreste sa se inlocuiasca niste masini vechi cu altele noi
SELECT DISTINCT e.Eid as idEngineer, e.name as nameEngineer 
FROM Engineers e INNER JOIN EngineersPlumbers ep ON e.Eid=ep.Eid INNER JOIN Cars c ON ep.Pid=c.Cid
WHERE c.DateOfPurchase<2010

--id-ul si numele inginerilor care lucreaza cu instalatori care au masini cu capacitate 75
SELECT DISTINCT e.Eid as idEngineer, e.name as nameEngineer 
FROM Engineers e INNER JOIN EngineersPlumbers ep ON e.Eid=ep.Eid INNER JOIN Cars c ON ep.Pid=c.Cid
WHERE c.Capacity=75

--id-ul si numele inginerilor care lucreaza cu instalatori care au masini cu capacitate 90
--relevanta pentru atunci cand la o lucrare este nevoie de o echipa de instalatori cu masini mai incapatoare

SELECT DISTINCT e.Eid as idEngineer, e.name as nameEngineer 
FROM Engineers e INNER JOIN EngineersPlumbers ep ON e.Eid=ep.Eid INNER JOIN Cars c ON ep.Pid=c.Cid
WHERE c.Capacity=90


--numele si adresa magazinelor care sunt aprovizionate de la depozite cu capacitate 1000
--magazinul4 este aprovizionat de la un depozit cu 2000 si doar de la acesta
SELECT DISTINCT shop.name as shopName, shop.Address as shopAddress
FROM Shops shop INNER JOIN DepositsShops depos ON shop.ShopId=depos.ShopId INNER JOIN Deposits depo ON depos.Did=depo.Did
WHERE depo.Capacity=10000


--numele si adresa magazinelor care sunt aprovizionate de la depozite cu capacitate 2000
--magazinul2 este aprovizionat de la un depozit cu 1000 si doar de la acesta
SELECT DISTINCT shop.name as shopName, shop.Address as shopAddress
FROM Shops shop INNER JOIN DepositsShops depos ON shop.ShopId=depos.ShopId INNER JOIN Deposits depo ON depos.Did=depo.Did
WHERE depo.Capacity=20000