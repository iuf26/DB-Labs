use RetailWebsiteAdministration
go

-- Cu ajutorul acestei tabele retinem versiunea curenta a bazei noastre de date
CREATE TABLE Versiune(

	VId int primary key identity,
	NrVersiune int
)

-- Script 1 - Modifica tipul unei coloane
GO
CREATE OR ALTER PROCEDURE V1 AS
BEGIN
	ALTER TABLE Cos
	ALTER COLUMN NrProduse SMALLINT
	PRINT 'V1: Coloanei NrProduse i-a fost schimbat tipul in SMALLINT din INT';
END;
--EXEC V1;
GO
CREATE OR ALTER PROCEDURE IV1 AS
BEGIN
	ALTER TABLE Cos
	ALTER COLUMN NrProduse INT
	PRINT 'IV1: Coloanei NrProduse i-a fost schimbat tipul in INT';
END;
--EXEC IV1;

-- Script 2 - adauga o constrangere de "valoare implicita" pentru un camp
GO
CREATE OR ALTER PROCEDURE V2 AS
BEGIN
	ALTER TABLE Cos
	ADD CONSTRAINT df_NrProduse DEFAULT 0 FOR NrProduse
	PRINT 'V2: Coloanei NrProduse i s-a pus ca valoare implicita 0';
END;
--EXEC V2
--INSERT INTO Cos(IdCos) VALUES (6)
--DELETE FROM Cos WHERE IdCos = 6
--SELECT * FROM Cos

GO
CREATE OR ALTER PROCEDURE IV2 AS
BEGIN
	ALTER TABLE Cos
	DROP CONSTRAINT df_NrProduse
	PRINT 'IV2: A fost stearsa valoarea implicita pentru coloana NrProduse'
END;
--EXEC IV2

-- Script 3 - Creea / sterge o tabela
GO
CREATE OR ALTER PROCEDURE V3 AS
BEGIN
	CREATE TABLE Reminder(
		RId INT PRIMARY KEY IDENTITY,
		Mesaj VARCHAR(50)
	)
	PRINT 'V3: A fost adaugat tabelul cu numele Reminder'
END;
--EXEC V3
GO
CREATE OR ALTER PROCEDURE IV3 AS
BEGIN
	DROP TABLE Reminder
	PRINT 'IV3: A fost sters tabelul cu numele reminder';
END;
--EXEC IV3

-- Script 4: Adauga un camp nou
GO
CREATE OR ALTER PROCEDURE V4 AS
BEGIN
	ALTER TABLE Reminder
	ADD Prioritate INT
	PRINT 'V4: A fost adaugata coloana Prioritate in tabela Reminder';
END;

GO
CREATE OR ALTER PROCEDURE IV4 AS
BEGIN
	ALTER TABLE Reminder
	DROP COLUMN Prioritate
	PRINT 'IV4: A fost stearsa coloana Prioritate din tabela Reminder';
END;

-- Script 5: creea / sterge o constrangere de cheie straina
GO
CREATE OR ALTER PROCEDURE V5 AS
BEGIN
	ALTER TABLE Reminder
	ADD IdPers INT NOT NULL
	PRINT 'V5: A fost adaugat coloana IdPers'

	ALTER TABLE Reminder
	ADD CONSTRAINT fk_Reminder FOREIGN KEY (IdPers) REFERENCES Persoana(IdPers)
	PRINT 'V5: A fost adaugata constrangerea de cheie straina pe coloana IdPers'
END;

GO
CREATE OR ALTER PROCEDURE IV5 AS
BEGIN
	ALTER TABLE Reminder
	DROP CONSTRAINT fk_Reminder
	PRINT 'IV5: A fost stearsa constrangerea de cheie straina pe coloana IdPers'

	ALTER TABLE Reminder
	DROP COLUMN IdPers
	PRINT 'IV5: A fost stearsa coloana IdPers'
END;

SELECT * FROM Versiune 

GO
CREATE OR ALTER PROCEDURE schimbareVersiune(
@Ver VARCHAR(50)
)
AS
BEGIN

	IF ISNUMERIC(@Ver) = 0

		RAISERROR('Valoarea introdusa nu este un numar!',12,1);

	ELSE
	BEGIN
		Set @Ver = CAST(@Ver AS INT)	
		IF @Ver < 0 or @Ver > 5

			RAISERROR('Numarul introdus nu este numarul unei versiuni!',12,1);

		ELSE
		BEGIN
			DECLARE @versiunea_curenta INT
			SELECT @versiunea_curenta = NrVersiune FROM Versiune
			
			IF @Ver = @versiunea_curenta

				print 'Ne aflam deja in versiunea introdusa!';

			ELSE
			BEGIN
				IF @Ver < @versiunea_curenta -- inseamna ca trebuie sa realizam operatiile inverse IVX, x e {1, 2, 3, 4, 5}
				BEGIN
					DECLARE @Comanda VARCHAR(50);
					WHILE (@Ver < @versiunea_curenta)
					BEGIN
						SET @Comanda = 'IV' + CAST(@versiunea_curenta AS VARCHAR)
						PRINT 'Executam comanda ' + @Comanda
						EXEC @Comanda
						SET @versiunea_curenta = @versiunea_curenta - 1
					END;
					UPDATE Versiune
					SET NrVersiune = @versiunea_curenta
					PRINT 'Am ajuns la versiunea ' + CAST(@versiunea_curenta AS VARCHAR(10))
				END;
				ELSE -- inseamna ca trebuie sa realizam operatiile normal VX, x e {1, 2, 3, 4, 5}
				BEGIN
					WHILE (@versiunea_curenta != @Ver)
					BEGIN
						SET @versiunea_curenta = @versiunea_curenta + 1
						SET @Comanda = 'V' + cast(@versiunea_curenta as VARCHAR)
						PRINT 'Executam comanda ' + @Comanda
						EXEC @Comanda
					END;
					UPDATE Versiune
					SET NrVersiune = @versiunea_curenta
					PRINT 'Am ajuns la versiunea ' + CAST(@versiunea_curenta AS VARCHAR(10))
				END;
			END;
		END;
	END;
END;

EXEC schimbareVersiune 0
EXEC schimbareVersiune 1
EXEC schimbareVersiune 2
EXEC schimbareVersiune 3
EXEC schimbareVersiune 4
EXEC schimbareVersiune 5
EXEC schimbareVersiune 'a'
EXEC schimbareVersiune -1
EXEC schimbareVersiune 6

SELECT * FROM Versiune