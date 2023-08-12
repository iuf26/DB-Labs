-- 1 PK + 0 FK = Aeroporturi
-- 1 PK + 1+ FK = Avioane
-- 2 PK = AvioaneAeroporturi

USE CompanieAeriana
GO

CREATE OR ALTER VIEW View_1 AS
	SELECT Locatie 
	FROM Aeroporturi

GO

CREATE OR ALTER VIEW View_2 AS
	SELECT av.Nume AS NumeAvion, av.Capacitate, p.Nume AS NumeProducator
	FROM Avioane av INNER JOIN Producatori p ON av.CodP = p.CodP

GO

CREATE OR ALTER VIEW View_3 AS
	SELECT COUNT(*) AS NumarFolosiriAvion, av.Nume
	FROM Avioane av INNER JOIN AvioaneAeroporturi aa ON aa.CodAv = av.CodA INNER JOIN Aeroporturi ap ON aa.CodAp = ap.CodA
	GROUP BY av.Nume
	--SELECT * FROM AvioaneAeroporturi

GO

CREATE OR ALTER PROCEDURE usp_insertAeroporturi AS
BEGIN

	DECLARE @NoOfRows INT
	DECLARE @n INT
	DECLARE @locatie VARCHAR(32)

	SELECT TOP 1 @NoOfRows = NoOfRows FROM TestTables WHERE TestID = 2
	SET @n = 1

	WHILE @n <= @NoOfRows
	BEGIN

		SET @locatie = 'Locatie' + CONVERT (VARCHAR(5), @n)
		INSERT INTO Aeroporturi VALUES (@locatie)

		SET @n = @n + 1

	END

END
GO

CREATE OR ALTER PROCEDURE usp_insertAvioane AS
BEGIN

	DECLARE @NoOfRows INT
	DECLARE @n INT
	DECLARE @nume VARCHAR(32)
	DECLARE @fk INT

	INSERT INTO Producatori VALUES ('ProducatorTest')

	SELECT TOP 1 @fk = CodP FROM Producatori ORDER BY CodP DESC

	SELECT TOP 1 @NoOfRows = NoOfRows FROM TestTables WHERE TestID = 4
	SET @n = 1

	WHILE @n <= @NoOfRows
	BEGIN
		
		SET @nume = 'Nume' + CONVERT(VARCHAR(5), @n)
		
		INSERT INTO Avioane VALUES (@nume, @n, @fk)

		SET @n = @n + 1

	END

	--DELETE FROM Producatori
	--WHERE CodP = @fk

END
GO

CREATE OR ALTER PROCEDURE usp_insertAvioaneAeroporturi AS
BEGIN

	DECLARE @NrAv INT
	DECLARE @NrAp INT
	DECLARE @NrCross INT

	DELETE FROM AvioaneAeroporturi

	INSERT INTO AvioaneAeroporturi
	SELECT av.CodA, ap.CodA
	FROM Avioane av CROSS JOIN Aeroporturi ap

	-- Reintroducem valorile vechi
	--DELETE FROM AvioaneAeroporturi
	--INSERT INTO AvioaneAeroporturi VALUES (1, 1), (1, 2), (2, 2), (3, 3)

END
GO

CREATE OR ALTER PROCEDURE usp_deleteAvioane AS
BEGIN

	DELETE FROM Avioane
	WHERE Nume LIKE 'Nume%'

	DELETE FROM Producatori
	WHERE Nume = 'ProducatorTest'

END
GO

CREATE OR ALTER PROCEDURE usp_deleteAeroporturi AS
BEGIN

	DELETE FROM Aeroporturi
	WHERE Locatie LIKE 'Locatie%'

END
GO

CREATE OR ALTER PROCEDURE usp_deleteAvioaneAeroporturi AS
BEGIN

	DELETE FROM AvioaneAeroporturi

END
GO

CREATE OR ALTER PROCEDURE usp_selectView1 AS
BEGIN

	SELECT * FROM View_1
	SELECT * FROM View_2
	SELECT * FROM View_3

END
GO

CREATE OR ALTER PROCEDURE usp_selectView2 AS
BEGIN

	SELECT * FROM View_2

END
GO

CREATE OR ALTER PROCEDURE usp_selectView3 AS
BEGIN

	SELECT * FROM View_3

END
GO

CREATE OR ALTER PROCEDURE usp_runAll AS
BEGIN

	DECLARE @ds DATETIME
	DECLARE @di DATETIME
	DECLARE @de DATETIME

	DECLARE @nrTests INT
	DECLARE @i INT
	DECLARE @currentID INT
	
	DECLARE @procDel VARCHAR(64)
	DECLARE @procIns VARCHAR(64)
	DECLARE @procSel VARCHAR(64)

	DECLARE @tableName VARCHAR(64)
	DECLARE @tableID INT

	DECLARE @viewID INT

	SELECT @nrTests = COUNT(*) FROM Tests

	SET @i = 1

	WHILE @i <= @nrTests
		BEGIN

			SELECT @tableID = TableID FROM TestTables WHERE TestID = @i
			SELECT @tableName = Name FROM Tables WHERE TableId = @tableID
			
 
			SELECT @procDel = Name FROM Tests WHERE TestID = @i
			SET @i = @i + 1

			SELECT @procIns = Name FROM Tests WHERE TestID = @i
			SET @i = @i + 1

			SELECT @procSel = Name FROM Tests WHERE TestID = @i
			SELECT @viewID = ViewID FROM TestViews WHERE TestID = @i
			SET @i = @i + 1

			SET @ds = GETDATE()

			EXEC @procDel
			EXEC @procIns
			SET @di = GETDATE()

			EXEC @procSel
			SET @de = GETDATE()

			PRINT DATEDIFF(ms, @ds, @di)
			PRINT DATEDIFF(ms, @di, @de)
			PRINT DATEDIFF(ms, @ds, @de)

			INSERT INTO TestRuns VALUES ('Insert+Delete+Select_' + @tableName, @ds, @de)

			SELECT @currentID = MAX(TestRunID) FROM TestRuns
			INSERT INTO TestRunTables VALUES (@currentID, @tableID, @ds, @di)

			INSERT INTO TestRunViews VALUES (@currentID, @viewID, @di, @de)

		END

END
GO

CREATE OR ALTER PROCEDURE usp_restoreData AS
BEGIN

	DELETE FROM AvioaneAeroporturi
	INSERT INTO AvioaneAeroporturi VALUES (1, 1), (1, 2), (2, 2), (3, 3)

	DELETE FROM Avioane
	WHERE nume LIKE 'Nume%'

	DELETE FROM Aeroporturi
	WHERE Locatie LIKE 'Locatie%'

	DELETE FROM Producatori
	WHERE Nume = 'ProducatorTest'

END
GO

EXEC usp_runAll

SELECT * FROM TestRuns
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews

SELECT * FROM Aeroporturi
SELECT * FROM Avioane
SELECT * FROM AvioaneAeroporturi
SELECT * FROM Producatori

-- EXEC usp_restoreData

GO