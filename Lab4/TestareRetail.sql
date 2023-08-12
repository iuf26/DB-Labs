--Ca si tabele alese am mers pe:
--	o tabela cu PK si fara FK - Produs
--	o tabela cu PK si cu FK - Cos
--	o tabela cu 2 campuri PK - Produs/Cos
--	practim o sa testam relatia m:n

USE RetailWebsiteAdministration
GO

--INSERT INTO Tables(Name) VALUES 
--('Cos'),
--('Produs'),
--('ProdusCos');

--SELECT * FROM Tables

---------------------------------------------------------------------------------------------------------------

--Trei view-uri:
-- un view ce contine o comanda SELECT pe o tabela - View_1
-- un view ce contine o comanda SELECT aplicata pe cel putin doua tabele - View_2
-- un view ce contine o comanda SELECT aplicata pe cel putin doua tabele si avand o clauza GROUP BY - View_3

GO
CREATE OR ALTER VIEW View_1 AS
	SELECT * FROM Produs
GO

CREATE OR ALTER PROCEDURE run_view1
AS
BEGIN
	SELECT * FROM View_1
END
----------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW View_2 AS
	
	SELECT cont.NumeUtilizator, cont.Mail FROM Cos c INNER JOIN Cont cont ON c.IdCos = cont.IdCont

GO
CREATE OR ALTER PROCEDURE run_view2
AS
BEGIN
	SELECT * FROM View_2
END
-----------------------------------------------------------------------------------------------------------
GO
CREATE OR ALTER VIEW View_3 AS
	SELECT p.IdP, p.Nume, p.Pret, p.Furnizor, COUNT(c.IdCos) AS Nr_prod_vandute FROM Cos c INNER JOIN ProdusCos pc ON c.IdCos = pc.IdCos INNER JOIN Produs p ON pc.IdP = p.IdP
	GROUP BY p.IdP, p.Nume, p.Pret, p.Furnizor
GO

CREATE OR ALTER PROCEDURE run_view3
AS
BEGIN
	SELECT * FROM View_3
END
------------------------------------------------------------------------------------------------------------

--INSERT INTO Views(Name) VALUES
--('View_1'),
--('View_2'),
--('View_3');

--SELECT * FROM Views

---------------------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE insertIntoCos
AS
BEGIN
	DECLARE @NoOfRows int
	DECLARE @i int
	DECLARE @n int
	DECLARE @nume varchar(50)
	DECLARE @id_test int
	
	SELECT @i = Max(IdPers) FROM Persoana
	SET @i = @i + 1
	
	SET @n = 0
	--SET @NoOfRows = 100	-- aici o sa fie un select
	SELECT @id_test = TestID FROM Tests WHERE Name = 'insertIntoCos'
	SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestID = @id_test

	WHILE @n < @NoOfRows
	BEGIN
		SET @nume = 'Test' + CONVERT(VARCHAR(5), @i);
		
		INSERT INTO Persoana(IdPers, CNP, Nume, Prenume, Card) VALUES (@i, @i, @nume, @nume, @i)
		INSERT INTO Cont(IdCont, NumeUtilizator, Mail, Parola) VALUES (@i, @nume, @nume, @nume)
		INSERT INTO Cos(IdCos, NrProduse) VALUES (@i, @i)

		SET @i = @i + 1
		SET @n = @n + 1
	END
END
GO

CREATE OR ALTER PROCEDURE deleteCos
AS
BEGIN

	DELETE FROM Cos
	DELETE FROM Cont WHERE NumeUtilizator LIKE 'Test%'
	DELETE FROM Persoana WHERE Nume Like 'Test%'

END

--------------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE insertIntoProdus
AS
BEGIN
	DECLARE @NoOfRows int
	DECLARE @i int
	DECLARE @n int
	DECLARE @nume varchar(50)
	DECLARE @id_test int

	SELECT @i = Max(IdP) FROM Produs
	SET @i = @i + 1

	SET @n = 0
	--SET @NoOfRows = 100 -- aici o sa vina select-ul din tabel
	SELECT @id_test = TestID FROM Tests WHERE Name = 'insertIntoProdus'
	SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestID = @id_test

	WHILE @n < @NoOfRows
	BEGIN

		SET @nume = 'Test' + CONVERT(VARCHAR(5), @i);

		INSERT INTO Produs(IdP, Nume, Pret, Furnizor, Cantitate) VALUES (@i, @nume, @i, @nume, @i)

		SET @i = @i + 1
		SET @n = @n + 1
	END
END

---------------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE deleteProdus
AS
BEGIN

	DELETE FROM Produs WHERE Nume LIKE 'Test%'

END

---------------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE insertIntoProdusCos
AS
BEGIN
	
	DECLARE @NoOfRows int
	DECLARE @i int
	DECLARE @j int
	DECLARE @n2 int
	DECLARE @n int
	DECLARE @min int
	DECLARE @id_test int

	SELECT @i = MIN(IdP) FROM Produs WHERE Nume LIKE 'Test%'

	SET @min = @i

	SET @n = 0

	--SET @NoOfRows = 100	-- aici o sa vina un select

	SELECT @id_test = TestID FROM Tests WHERE Name = 'insertIntoProdusCos'
	SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestID = @id_test

	WHILE @n < @NoOfRows
	BEGIN

		SET @n2 = 0
		SET @j = @min

		WHILE @n2 < @NoOfRows
		BEGIN

			INSERT INTO ProdusCos(IdP, IdCos) VALUES (@i, @j)
			SET @j = @j + 1
			SET @n2 = @n2 + 1

		END
		
		SET @i = @i + 1
		SET @n = @n + 1
	END

END

---------------------------------------------------------------------------------------------

GO
CREATE OR ALTER PROCEDURE deleteProdusCos
AS
BEGIN
	DELETE FROM ProdusCos
END

---------------------------------------------------------------------------------------------
-- ordinea
--GO
--insertIntoCos
--GO
--insertIntoProdus
--GO
--insertIntoProdusCos
--GO
--deleteProdusCos
--GO
--deleteProdus
--GO
--deleteCos

---------------------------------------------------------------------------------------------

--SELECT * FROM Tables
--SELECT * FROM Views

--INSERT INTO Tests(Name) VALUES 
--('deleteCos'),
--('insertIntoCos'),
--('run_view1'),
--('deleteProdus'),
--('insertIntoProdus'),
--('run_view2'),
--('deleteProdusCos'),
--('insertIntoProdusCos'),
--('run_view3')

--SELECT * FROM Tests

--INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
--(1, 1, 1000, 1),
--(2, 1, 1000, 2),
--(4, 2, 1000, 4),
--(5, 2, 1000, 5),
--(7, 3, 1000, 7),
--(8, 3, 1000, 8)

--DELETE FROM TestTables

--INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
--(1, 1, 100, 1),
--(2, 1, 100, 2),
--(4, 2, 100, 4),
--(5, 2, 100, 5),
--(7, 3, 100, 7),
--(8, 3, 100, 8)


--SELECT * FROM TestTables

--INSERT INTO TestViews(TestID, ViewID) VALUES
--(3, 1),
--(6, 2),
--(9, 3)

--SELECT * FROM TestViews

GO
CREATE OR ALTER PROCEDURE TestareDB
AS
BEGIN

	DECLARE @dateStart DATETIME
	DECLARE @dateIntermediate DATETIME
	DECLARE @dateEnd DATETIME
	DECLARE @i int
	DECLARE @nr_tests int
	DECLARE @delete VARCHAR(50)
	DECLARE @insert VARCHAR(50)
	DECLARE @select VARCHAR(50)
	DECLARE @table VARCHAR(50)
	DECLARE @index int
	DECLARE @table_id int

	SET @i = 1

	SELECT @nr_tests = COUNT(*) FROM Tests

	WHILE @i <= @nr_tests
	BEGIN

		SELECT @table = t.Name FROM TestTables tt INNER JOIN Tables t ON tt.TableID = t.TableID WHERE tt.TestID = @i
		SELECT @table_id = TableID FROM TestTables WHERE TestID = @i

		SELECT @delete = Name FROM Tests WHERE TestID = @i
		SET @i = @i + 1

		SELECT @insert = Name FROM Tests WHERE TestID = @i
		SET @i = @i + 1

		SELECT @select = Name FROM Tests WHERE TestID = @i
		SET @i = @i + 1

		SET @dateStart = GETDATE()

		EXEC @delete
		EXEC @insert

		SET @dateIntermediate = GETDATE()

		EXEC @select

		SET @dateEnd = GETDATE()

		PRINT DATEDIFF(ms, @dateStart, @dateEnd)

		INSERT INTO TestRuns(Description, StartAt, EndAt) VALUES ('Delete-Insert-Select-' + @table, @dateStart, @dateEnd)

		SELECT @index = MAX(TestRunID) FROM TestRuns

		INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@index, @table_id, @dateStart, @dateIntermediate)

		INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@index, @table_id, @dateIntermediate, @dateEnd)

	END
END

EXEC TestareDB -- pentru 1000 de rows in fiecare tabel dureaza 2 min
			   -- pentru 100 de rows in fiecare tabel dureaza 5 secunde, 2 secunde, chiar si o secunda	

---------------------------------------------------------------------------------------------

--SELECT * FROM Produs
--SELECT * FROM ProdusCos	

--SELECT * FROM Persoana
--SELECT * FROM Cont
--SELECT * FROM Cos	
--SELECT * FROM TestRunTables
--SELECT * FROM TestRunViews
--SELECT * FROM TestRuns
