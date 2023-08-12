-- Creati operatii CRUD incapsulate in proceduri stocate 
-- pentru cel putin 3 tabele din baza de date (care sa includa o relatie many-to-many).

-- Trebuie să folosiți:
-- - parametri de intrare/ieșire;
-- - funcţii (de exemplu pentru formatarea/validarea datelor de intrare);
-- - constrângeri pe tabelă/coloană pentru a asigura validitatea datelor.

-- De asemenea, creați cel puțin 2 view-uri peste tabelele selectate pentru operațiile CRUD.

-- Pentru tabelele folosite în view, creați indecși non-clustered. 
-- Pentru a vă asigura că indecșii pe care i-ați creat sunt utili, 
-- puteți verifica utilizarea acestora cu Dynamic Management Views.

-- În cazul în care constatați că nu vă sunt de ajutor, 
-- este necesar să reconsiderați alegerea indecșilor 
-- sau să populați tabelele cu mai multe date.

-- CREATE = INSERT
-- READ = SELECT
-- UPDATE = UPDATE
-- DELETE = DELETE

USE CompanieAeriana
GO

SELECT * FROM Avioane
GO

-- ==================================================================================== --

CREATE OR ALTER FUNCTION usf_validateString(@nume VARCHAR(64))
RETURNS INT
AS
BEGIN

	DECLARE @value INT

	IF @nume = ''
		SET @value = 0

	ELSE
		SET @value = 1

	RETURN @value
	
END
GO

-- ==================================================================================== --

CREATE OR ALTER FUNCTION usf_validateCapacitate(@cap INT)
RETURNS INT AS
BEGIN

	DECLARE @value INT

	IF @cap < 0 OR @cap > 1000
		SET @value = 0

	ELSE 
		SET @value = 1

	RETURN @value

END
GO

-- ==================================================================================== --

CREATE OR ALTER FUNCTION usf_validateCodP(@CodP INT)
RETURNS INT AS
BEGIN

	DECLARE @value INT, @result INT

	SET @result = -1

	SELECT @result = CodP FROM Producatori WHERE @CodP = CodP

	IF @result = -1
		SET @value = 0

	ELSE
		SET @value = 1

	RETURN @value

END
GO

-- ==================================================================================== --

CREATE OR ALTER FUNCTION usf_validateCodAv(@CodAv INT)
RETURNS INT AS
BEGIN

	DECLARE @value INT, @result INT

	SET @result = -1

	SELECT @result = CodA FROM Avioane WHERE @CodAv = CodA

	IF @result = -1
		SET @value = 0

	ELSE
		SET @value = 1

	RETURN @value

END
GO

-- ==================================================================================== --

CREATE OR ALTER FUNCTION usf_validateCodAp(@CodAp INT)
RETURNS INT AS
BEGIN

	DECLARE @value INT, @result INT

	SET @result = -1

	SELECT @result = CodA FROM Aeroporturi WHERE @CodAp = CodA

	IF @result = -1
		SET @value = 0

	ELSE
		SET @value = 1

	RETURN @value

END
GO

-- ==================================================================================== --

DECLARE @a INT
EXEC @a = usf_validateString ''
PRINT @a
GO

CREATE OR ALTER PROCEDURE usp_CRUD_Avioane 

	@flag BIT OUTPUT,
	@nume VARCHAR(64),
	@capacitate INT,
	@CodP INT

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ok INT

	SET @flag = 1

	EXEC @ok = usf_validateString @nume
	IF @ok = 0
	BEGIN

		PRINT 'Numele avionului este invalid!'
		SET @flag = 0

	END

	EXEC @ok = usf_validateCapacitate @capacitate
	IF @ok = 0
	BEGIN

		PRINT 'Capacitatea avionului este invalida!'
		SET @flag = 0

	END

	EXEC @ok = usf_validateCodP @CodP
	IF @ok = 0
	BEGIN

		PRINT 'Producatorul nu exista!'
		SET @flag = 0

	END

	IF @flag = 1
	BEGIN
		INSERT INTO Avioane VALUES (@nume, @capacitate, @CodP)

		IF @@ERROR != 0
			SET @flag = 0	

		IF @flag = 1
		BEGIN

			SELECT * FROM Avioane

			UPDATE Avioane
			SET Nume = 'Cessna'
			WHERE Nume = @nume

			SELECT * FROM Avioane

			DELETE FROM Avioane
			WHERE Nume = 'Cessna'

		END

	END

END
GO

-- ==================================================================================== --

CREATE OR ALTER PROCEDURE usp_CRUD_Aeroporturi 

	@flag BIT OUTPUT,
	@locatie VARCHAR(64)

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @ok INT

	SET @flag = 1

	EXEC @ok = usf_validateString @locatie
	IF @ok = 0
	BEGIN

		PRINT 'Locatia Aeroportului nu e valida!'
		SET @flag = 0

	END

	IF @flag = 1
	BEGIN
		INSERT INTO Aeroporturi VALUES (@locatie)

		IF @@ERROR != 0
			SET @flag = 0

		IF @flag = 1
		BEGIN

			SELECT * FROM Aeroporturi

			UPDATE Aeroporturi
			SET Locatie = 'Otopeni'
			WHERE Locatie = @locatie

			SELECT * FROM Aeroporturi

			DELETE FROM Aeroporturi
			WHERE Locatie = 'Otopeni'

		END
	END

END
GO

-- ==================================================================================== --

CREATE OR ALTER PROCEDURE usp_CRUD_AvioaneAeroporturi

	@flag BIT OUTPUT,
	@CodAv INT,
	@CodAp INT

AS
BEGIN

	SET NOCOUNT ON;

	SET @flag = 1

	DECLARE @ok INT
	EXEC @ok = usf_validateCodAv @CodAv

	IF @ok = 0
	BEGIN

		PRINT 'Codul Avionului nu exista!'
		SET @flag = 0

	END

	EXEC @ok = usf_validateCodAp @CodAp
	IF @ok = 0
	BEGIN

		PRINT 'Codul Aeroportului nu exista!'
		SET @flag = 0

	END

	IF @flag = 1
	BEGIN

		INSERT INTO AvioaneAeroporturi VALUES (@CodAv, @CodAp)

		IF @@ERROR != 0
			SET @flag = 0

		IF @flag = 1
		BEGIN

			SELECT * FROM AvioaneAeroporturi

			PRINT 'Cannot update because all the columns are Foreign Keys!'

			DELETE FROM AvioaneAeroporturi
			WHERE CodAv = @CodAv AND CodAp = @CodAp

		END

	END

END
GO

-- ==================================================================================== --

SELECT * FROM Avioane
SELECT * FROM Aeroporturi
SELECT * FROM AvioaneAeroporturi

DECLARE @flag BIT
EXEC usp_CRUD_Avioane @flag OUTPUT, 'AvionTest', 200, 1

IF @flag = 1
	PRINT 'CRUD Operations for Avioane table executed!'

ELSE
	PRINT 'Error occured for Avioane table!'

DECLARE @flag2 BIT
EXEC usp_CRUD_Aeroporturi @flag2 OUTPUT, 'Fundulea'

IF @flag2 = 1
	PRINT 'CRUD Operations for Aeroporturi table executed!'

ELSE
	PRINT 'Error occured for Aeroporturi table!'

-- INSERT INTO Avioane VALUES ('AvionTest', 200, 1)
-- INSERT INTO Aeroporturi VALUES ('AeroportTest')

DECLARE @flag3 BIT
EXEC usp_CRUD_AvioaneAeroporturi @flag3 OUTPUT, 32009, 32006

IF @flag3 = 1
	PRINT 'CRUD Operations for AvioaneAeroporturi table executed!'

ELSE
	PRINT 'Error occured for AvioaneAeroporturi!'

-- ==================================================================================== --

SELECT name FROM sys.indexes

SELECT * FROM Avioane
ORDER BY Capacitate
GO

CREATE OR ALTER VIEW view_Lab5_Avioane AS
SELECT Nume, Capacitate FROM Avioane av, Aeroporturi ap, AvioaneAeroporturi aa
WHERE av.CodA = aa.CodAv AND ap.CodA = aa.CodAp AND (ap.Locatie = 'Suceava' OR ap.Locatie = 'Cluj-Napoca')
GO

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name = 'N_idx_avioane_capacitate')
DROP INDEX N_idx_avioane_capacitate ON Avioane
CREATE NONCLUSTERED INDEX N_idx_avioane_capacitate ON Avioane(Capacitate)
GO

SELECT * FROM view_Lab5_Avioane ORDER BY Capacitate DESC

-- ==================================================================================== --

GO
CREATE OR ALTER VIEW view_Lab5_Aeroporturi AS
SELECT Locatie FROM Avioane av, Aeroporturi ap, AvioaneAeroporturi aa
WHERE av.CodA = aa.CodAv AND ap.CodA = aa.CodAp AND av.Capacitate > 200
GO

IF EXISTS (SELECT NAME FROM sys.indexes WHERE name = 'N_idx_aeroporturi_locatie')
DROP INDEX N_idx_aeroporturi_locatie ON Aeroporturi
CREATE NONCLUSTERED INDEX N_idx_aeroporturi_locatie ON Aeroporturi(Locatie)
GO

SELECT * FROM view_Lab5_Aeroporturi ORDER BY Locatie