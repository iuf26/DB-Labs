
--ALTER TABLE Rafturi

USE lab_1
GO

--procedura pentru modificarea tipului unei coloane
--modifica tipul coloanei capacitate din int in varchar(10) din Rafturi
CREATE PROCEDURE do_proc_1
AS
BEGIN
	ALTER TABLE Rafturi
	ALTER COLUMN capacitate varchar(10)
END
GO

--procedura pentru revenirea la tipul de coloana initial
CREATE PROCEDURE undo_proc_1
AS
BEGIN
	ALTER TABLE Rafturi
	ALTER COLUMN capacitate int
END
GO

--procedura pentru adaugarea unei valori default
--adauga valoare default pentru coloana Salariu din Manageri
CREATE PROCEDURE do_proc_2
AS
BEGIN
ALTER TABLE Manageri
	ADD CONSTRAINT df_18 DEFAULT 2500 
	FOR Salariu
END
GO

--procedura pentru stergerea unei valori default
CREATE PROCEDURE undo_proc_2
AS
BEGIN
	ALTER TABLE Manageri
	DROP CONSTRAINT df_18;
END
GO

--creeaza tabel
--creeaza un tabel Persoane
CREATE PROCEDURE do_proc_3
AS
BEGIN
	CREATE TABLE Persoane(
	id int NOT NULL PRIMARY KEY,
	nume varchar(50),
	prenume varchar(50),
	id_m int
	);
END
GO

--sterge tabelul Persoane
CREATE PROCEDURE undo_proc_3
AS
BEGIN
	DROP TABLE Persoane
END
GO

--adauga camp nou
--adauga un camp nou in tabelul Persoane
CREATE PROCEDURE do_proc_4
AS
BEGIN
	ALTER TABLE Persoane
	ADD data_nasterii date
END
GO

--sterge camp nou
CREATE PROCEDURE undo_proc_4
AS 
BEGIN
	ALTER TABLE Persoane
	DROP COLUMN data_nasterii
END
GO

--creeaza constrangere cheie straina
--creeaza o cheie straina intre Mangeri si Persoane
CREATE PROCEDURE do_proc_5
AS
BEGIN
	ALTER TABLE Persoane
	ADD CONSTRAINT fk_Persoane_Manageri FOREIGN KEY (id_m) REFERENCES Manageri(id_m)
END
GO

--sterge constrangere cheie straina
CREATE PROCEDURE undo_proc_5
AS
BEGIN
	ALTER TABLE Persoane
	DROP CONSTRAINT fk_Persoane_Manageri;
END
GO

CREATE PROCEDURE main
@version int
AS
BEGIN
	
	IF @version<0 or @version>5
	BEGIN
		PRINT 'Versiune incorecta!'
	END
	ELSE
	BEGIN
		print 'Versiune corecta!'
		DECLARE @current_version INT
		SELECT @current_version = nr FROM Versiune WHERE nume='nume'
		DECLARE @cmd varchar(50)
		DECLARE @current_version_varchar varchar(50)

		WHILE @current_version != @version
		BEGIN
			IF @current_version < @version
			BEGIN
				SET @current_version = @current_version + 1
				SET @current_version_varchar = CONVERT(varchar(50), @current_version)
				SET @cmd = 'do_proc_' + @current_version_varchar
				EXEC @cmd
			END
			IF @current_version > @version
			BEGIN
				SET @current_version_varchar = CONVERT(varchar(50), @current_version)
				SET @current_version = @current_version - 1
				SET @cmd = 'undo_proc_' + @current_version_varchar
				EXEC @cmd
			END
		END
		UPDATE Versiune SET nr = @current_version WHERE nume='nume'
		PRINT 'Versiune actualizata!'
	END

END
GO

--executarea
EXEC main 3

