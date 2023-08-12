--TABELE 
--O CHEIE PRIMARA: Plumbers
--O CHEIE PRIMARA SI CEL PUTIN O CHEIE STRAINA: Tools
--DOUA CHEI PRIMARE: EngineersPlumbers


USE InstallationCompany; 
GO 


--inserez cele 3 tabele in Tabels
INSERT INTO Tables(Name)
VALUES ('Plumbers'), ('Tools'), ('EngineersPlumbers');
GO 
SELECT * FROM Tables



--creez cele 3 view-uri
--pe o tabela
--VIEW1: Toti instalatorii
CREATE OR ALTER VIEW View1 AS
SELECT * FROM Plumbers
GO 



--pe doua tabele folosind group by 
--VIEW2: Afisam instalatorii (id, nume) si la cati ingineri este subordonat fiecare instalator
CREATE OR ALTER VIEW View2 AS 
SELECT Plumbers.Pid as Id_instalator, Plumbers.Name as NumeInstalator, COUNT(Plumbers.Pid) as NrRepartizari 
FROM Plumbers INNER JOIN EngineersPlumbers ON Plumbers.Pid=EngineersPlumbers.Pid
GROUP BY Plumbers.Name, Plumbers.Pid
GO 




--pe 2 tabele
--VIEW3:Afisam toate tool-urile si id-ul si numele instalatorului caruia ii apartine acel tool
CREATE OR ALTER VIEW View3 AS 
SELECT t.Tid as Id_tool, t.Name as Nume_tool, p.Pid as Id_instalator_apartinator, p.Name as Nume_instalator_apartinator
FROM Plumbers as p INNER JOIN Tools as t ON p.Pid=t.Pid
GO 



--inserez cele 3 view-uri in Views
INSERT INTO Views(Name)
VALUES ('View1'),('View2'),('View3'); 
GO 
SELECT * FROM Views 



--inserez numele testelor in Tests
INSERT INTO Tests(Name) 
VALUES ('stergere'), ('inserare'), ('evaluare'); 
GO 
SELECT * From Tests



--inserez in TestViews
INSERT INTO TestViews(TestID,ViewID)
VALUES (3,1),(3,2),(3,3);
GO
SELECT * FROM TestViews



--inserez in TestTables

INSERT INTO TestTables(TestID,TableID,NoOfRows,Position)
VALUES (1,1,0,3), (1,3,0,2),(1,2,0,1),(2,1,9000,1),(2,2,9000,2),(2,3,36000,3);
GO
SELECT * FROM TestTables
--DELETE  FROM TestTables



--proceduri de stergere-
--DELETE1: Sterge toate relatiile de subordonare dintre ingineri si instalatori (tabela3)
CREATE OR ALTER PROCEDURE delete1 AS
BEGIN 
DELETE FROM EngineersPlumbers; 
END;
GO 



--DELETE2: Sterge toate tool-urile din tabela 2
CREATE OR ALTER PROCEDURE delete2 AS
BEGIN 
DELETE FROM Tools; 
END; 
GO 


--DELETE3: Sterge toti instalatorii
--stergem inainte toate inregistrarile din tabelele care depind de tabela Plumbers
CREATE OR ALTER PROCEDURE delete3 AS
BEGIN 
EXEC delete1;
DELETE From Tools
DELETE From Materials
DELETE FROM Cars
DELETE FROM Plumbers; 
END; 
GO 


--proceduri de inserare
--tabela cu o cheie primara
--INSERT1: insereaza instalatori in tabela Plumbers
CREATE OR ALTER PROCEDURE insert1 AS
BEGIN 
	DECLARE @n int;
	
	DECLARE @Name varchar(50);
	DECLARE @valoriInserate int; 
	SET @valoriInserate = (SELECT NoOfRows FROM TestTables where TestID = 2 AND Position = 1);
	SET @n=1;

	DECLARE @review int;
	DECLARE @experience int; 

	WHILE @n<=@valoriInserate
		BEGIN 
			SET @Name='Name'+ CONVERT(VARCHAR(25),@n); 
			SET @review= (SELECT FLOOR(RAND()*(10-5+1)+5));
			SET @experience= (SELECT RAND()*(10-5)+8);

			INSERT INTO Plumbers(Name, Experience, Review)
			VALUES(@Name, @experience, @review )

			SET @n=@n+1
		END

	END
GO


--tabela cu o cheie primara si cel putin una straina
--INSERT2: insereaza tool-uri in tabela Tools
CREATE OR ALTER PROCEDURE insert2 AS
BEGIN 
	DECLARE @n int; 
	DECLARE @Name varchar(50);
	DECLARE @valoriInserate int; 
	SET @valoriInserate=(SELECT NoOfRows FROM TestTables where TestID=2 AND Position=2);
	SET @n=1;
	DECLARE @price int;
	DECLARE @quantity int;

	DECLARE @Pid int= (SELECT TOP 1 Pid FROM Plumbers); 
	DECLARE @Did int= (SELECT TOP 1 Did FROM Deposits); 

	WHILE @n <= @valoriInserate
		 BEGIN 
			SET @Name = 'Tool' + CONVERT(VARCHAR(25), @n); 

			SET @price= (SELECT FLOOR(RAND()*(100-5+1)+10));
			SET @quantity= (SELECT RAND()*(10-5)+10);
			
			INSERT INTO Tools(Name, Quantity, Price, Pid, Did) 
			VALUES (@Name, @quantity, @price, @Pid, @Did);
			SET @n= @n +1; 
		END
END
GO


--tabela cu 2 chei primare
--INSERT3: insereaza repartizari ingineri-instalatori
CREATE OR ALTER PROCEDURE insert3 AS
BEGIN 
	DECLARE @n int; 
	DECLARE @valoriInserate int; 
	SET @n=1; 
	SET @valoriInserate= (SELECT NoOfRows FROM TestTables where TestID=2 AND Position=3); 

	DECLARE cursorEngineers CURSOR FAST_FORWARD FOR SELECT Eid from Engineers; 
	DECLARE cursorPlumbers CURSOR FAST_FORWARD FOR SELECT Pid from Plumbers; 

	OPEN cursorEngineers; 

	DECLARE @Eid int; 
	DECLARE @Pid int; 
	FETCH NEXT FROM cursorEngineers INTO @Eid; 

	WHILE @n<@valoriInserate and @@FETCH_STATUS=0
	BEGIN 
		OPEN cursorPlumbers; 
		FETCH NEXT FROM cursorPlumbers INTO @Pid; 
		WHILE @n<=@valoriInserate and @@FETCH_STATUS=0
		BEGIN 
			INSERT INTO EngineersPlumbers(Eid, Pid) 
			VALUES (@Eid, @Pid); 
			set @n=@n+1
			FETCH NEXT FROM cursorPlumbers INTO @Pid; 
		END 
		CLOSE cursorPlumbers; 
		FETCH NEXT FROM cursorEngineers into @Eid; 
	END
	CLOSE cursorEngineers; 
	DEALLOCATE cursorPlumbers; 
	DEALLOCATe cursorEngineers; 

END; 
GO

--proceduri pentru View-uri
CREATE PROCEDURE selectView1 AS
BEGIN
SELECT * FROM View1
END
GO

CREATE PROCEDURE selectView2 AS
BEGIN
SELECT * FROM View2
END
GO

CREATE PROCEDURE selectView3 AS
BEGIN
SELECT * FROM View3
END
GO

--testele
--test1: tabela 1 si view 1
--se sterg toti instalatorii
--se afiseaza toti instalatorii generati
CREATE OR ALTER PROCEDURE test1 AS
BEGIN
	DECLARE @ds DATETIME; 
	DECLARE @di DATETIME; 
	DECLARE @df DATETIME; 
	SET @ds = GETDATE();
	EXEC delete3;
	EXEC insert1;
	SET @di = GETDATE();
	EXEC selectView1;
	SET @df = GETDATE();
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Test tabela 1 view 1', @ds, @df);
	DECLARE @testRunID int = (SELECT TOP 1 TestRunID FROM TestRuns ORDER BY TestRunID DESC);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@testRunID, 1, @ds, @di);
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@testRunID, 1, @di, @df);	
END
GO

--test2: tabela 2 si view 3
--se sterg toate tool-urile
--se afiseaza toate tool-urile si instalatorul apartinator
CREATE OR ALTER PROCEDURE test2 AS
BEGIN
	DECLARE @ds DATETIME; 
	DECLARE @di DATETIME; 
	DECLARE @df DATETIME; 
	SET @ds = GETDATE();
	EXEC delete2;
	EXEC insert2;
	SET @di = GETDATE();
	EXEC selectView3;
	SET @df = GETDATE();
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Test tabela 2 view 3', @ds, @df);
	DECLARE @testRunID int = (SELECT TOP 1 TestRunID FROM TestRuns ORDER BY TestRunID DESC);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@testRunID, 2, @ds, @di);
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@testRunID, 3, @di, @df);	
END
GO

--test3: tabela 3 si view 2
--se sterg toate repartizarile inginer-instalator
--se afiseaza toate repartizarile noi generate
CREATE OR ALTER PROCEDURE test3 AS
BEGIN
	DECLARE @ds DATETIME; 
	DECLARE @di DATETIME; 
	DECLARE @df DATETIME; 
	SET @ds = GETDATE();
	EXEC delete1;
	EXEC insert3;
	SET @di = GETDATE();
	EXEC selectView2;
	SET @df = GETDATE();
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES ('Test tabela 3 view 2', @ds, @df);
	DECLARE @testRunID int = (SELECT TOP 1 TestRunID FROM TestRuns ORDER BY TestRunID DESC);
	INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
	VALUES (@testRunID, 3, @ds, @di);
	INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt)
	VALUES (@testRunID, 2, @di, @df);	
END
GO


EXEC test1; 
SELECT* FROM TestRuns;
SELECT* FROM TestRunTables;
SELECT* FROM TestRunViews;

EXEC test2
SELECT* FROM Tools;
SELECT* FROM TestRuns;
SELECT* FROM TestRunTables;  
SELECT* FROM TestRunViews;

EXEC test3
SELECT * FROM Engineers;
SELECT* FROM Plumbers;
SELECT* FROM EngineersPlumbers
SELECT* FROM TestRuns;
SELECT* FROM TestRunTables;
SELECT* FROM TestRunViews;



DELETE FROM TestRuns;
DELETE FROM TestRunTables;
DELETE FROM TestRunViews;



