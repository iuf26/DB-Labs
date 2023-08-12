USE CompanieCosmetice
GO

--Procedure for displaying Views
ALTER PROCEDURE select_view
@id_view int
AS
	DECLARE @view_name varchar(100)
BEGIN
	IF @id_view < 1 OR @id_view > 3
	BEGIN
		PRINT 'NU EXISTA ACEST VIEW'
	END
	ELSE
	BEGIN
		SET @view_name = 'View_' + CONVERT(varchar(5), @id_view)
		PRINT @view_name
		EXEC('SELECT * FROM ' + @view_name)
	END
END;
go

CREATE OR ALTER PROCEDURE delete_inventar100
AS
BEGIN
	DELETE FROM Inventar
END;
GO

CREATE OR ALTER PROCEDURE delete_inventar1000 
AS
BEGIN
	DELETE FROM Inventar
END;
GO

CREATE OR ALTER PROCEDURE delete_colectie100 
AS
BEGIN	
	exec delete_produs100
	DELETE FROM Colectie
END;
GO

CREATE OR ALTER PROCEDURE delete_colectie1000 
AS
BEGIN
	exec delete_produs1000
	DELETE FROM Colectie
END;
GO

CREATE OR ALTER PROCEDURE delete_produs100 
AS
BEGIN
	DELETE FROM Client
	DELETE FROM Comanda
	DELETE FROM Angajat
	DELETE FROM Adresa
	DELETE FROM Fabrica
	DELETE FROM FabricaProdus
	delete from Inventar
	DELETE FROM Produs
END;
GO

CREATE OR ALTER PROCEDURE delete_produs1000 
AS
BEGIN
	DELETE FROM Client
	DELETE FROM Comanda
	DELETE FROM Angajat
	DELETE FROM Adresa
	DELETE FROM Fabrica
	DELETE FROM FabricaProdus
	delete from Inventar
	DELETE FROM Produs
END;
GO

CREATE OR ALTER PROCEDURE insert_colectie100 AS
	DECLARE @n int
	DECLARE @den varchar(100)
	DECLARE @valabilitate int
	DECLARE @produse int
BEGIN
	
	SET @n = 0
	WHILE @n < 100
	BEGIN
		SET @den = 'colectie' + CONVERT(VARCHAR(5), @n)
		SET @valabilitate = @n + 2
		SET @produse = @n + 10
		
		INSERT INTO Colectie (Denumire, Valabilitate,NrProduse)
		VALUES (@den, @valabilitate, @produse)

		SET @n = @n + 1
	END
END;
GO

CREATE OR ALTER PROCEDURE insert_colectie1000 AS
	DECLARE @n int
	DECLARE @den varchar(100)
	DECLARE @valabilitate int
	DECLARE @produse int
BEGIN
	SET @n = 0

	WHILE @n < 1000 
	BEGIN
		SET @den = 'colectie' + CONVERT(VARCHAR(5), @n)
		SET @valabilitate = @n + 2
		SET @produse = @n + 10
		
		INSERT INTO Colectie (Denumire, Valabilitate,NrProduse)
		VALUES (@den, @valabilitate, @produse)

		SET @n = @n + 1
	END
END;
GO

CREATE OR ALTER PROCEDURE insert_produs100 AS
	DECLARE @n int
	DECLARE @den varchar(100)
	DECLARE @cid int
	DECLARE @pret int
	DECLARE @cantitate int
BEGIN

	SET @n = 0

	WHILE @n < 100
	BEGIN
		SET @den = 'produs' + CONVERT(VARCHAR(5), @n)
		SET @pret = @n + 2
		SET @cantitate = @n + 10
		SELECT TOP 1 @cid = MAX(Cid) FROM Colectie
		INSERT INTO Produs (Denumire, Cid, Pret, Cantitate)
		VALUES (@den, @cid, @pret, @cantitate)

		SET @n = @n + 1
	END
END;
GO

CREATE OR ALTER PROCEDURE insert_produs1000 AS
	DECLARE @n int
	DECLARE @den varchar(100)
	DECLARE @cid int
	DECLARE @pret int
	DECLARE @cantitate int
BEGIN

	SET @n = 0

	WHILE @n < 1000 
	BEGIN
		SET @den = 'produs' + CONVERT(VARCHAR(5), @n)
		SET @pret = @n + 2
		SET @cantitate = @n + 10
		SELECT TOP 1 @cid = MAX(Cid) FROM Colectie
		INSERT INTO Produs (Denumire, Cid, Pret, Cantitate)
		VALUES (@den, @cid, @pret, @cantitate)

		SET @n = @n + 1
	END
END;
GO

CREATE OR ALTER PROCEDURE insert_inventar100
AS
BEGIN
	INSERT INTO Inventar(Pid, Mid, Cantitate)
	SELECT TOP (100) Pid, Mid, Cantitate
	FROM Produs CROSS JOIN Magazin

END;
GO

CREATE OR ALTER PROCEDURE insert_inventar1000
AS
BEGIN
	INSERT INTO Inventar(Pid, Mid, Cantitate)
	SELECT TOP (1000) Pid, Mid, Cantitate
	FROM Produs CROSS JOIN Magazin

END;
GO

CREATE OR ALTER PROCEDURE insert_table
@TableID int,
@NoOfRows int
as
begin
	declare @TableName varchar(50)
	select top 1 @TableName = lower(Name) from Tables where TableID = @TableID
	print 'Se introduc datele in ' + @TableName
	declare @rows varchar(50) = convert(varchar(50), @NoOfRows)
	exec ('insert_' + @TableName + @rows)
end 
go

CREATE OR ALTER PROCEDURE delete_table
@TableID int,
@NoOfRows int
as
begin
	declare @TableName varchar(50)
	select top 1 @TableName = lower(Name) from Tables where TableID = @TableID
	print 'Se sterg datele din ' + @TableName
	declare @rows varchar(50) = convert(varchar(50), @NoOfRows)
	exec ('delete_' + @TableName + @rows)
end 
go

