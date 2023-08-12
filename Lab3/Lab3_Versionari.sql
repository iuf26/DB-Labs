USE CompanieAeriana
GO

DROP TABLE Versiune
CREATE TABLE Versiune
(
	CodV INT PRIMARY KEY IDENTITY,
	NrVersiune INT NOT NULL
)

INSERT INTO Versiune VALUES(0)

GO

CREATE OR ALTER PROCEDURE V1 AS 
BEGIN
	
	ALTER TABLE Piloti
	ALTER COLUMN Varsta SMALLINT

	PRINT('V1: Tipul coloanei Varsta a fost modificat din INT in SMALLINT.')

END
GO

CREATE OR ALTER PROCEDURE IV1 AS
BEGIN
	
	ALTER TABLE Piloti
	ALTER COLUMN Varsta INT

	PRINT('IV1: Tipul coloanei Varsta a fost modificat inapoi din SMALLINT in INT.')

END
GO

CREATE OR ALTER PROCEDURE V2 AS
BEGIN

	ALTER TABLE Pasageri
	ADD CONSTRAINT df_NrRezervari DEFAULT 1 FOR NrRezervari
	
	PRINT('V2: Am adaugat constrangerea ca NrRezervari sa fie, by DEFAULT, 1.')

END
GO

CREATE OR ALTER PROCEDURE IV2 AS
BEGIN

	ALTER TABLE Pasageri
	DROP CONSTRAINT df_NrRezervari

	PRINT('IV2: Am eliminat constrangerea ca NrRezervari sa fie, by DEFAULT, 1.')

END
GO

CREATE OR ALTER PROCEDURE V3 AS
BEGIN
	
	CREATE TABLE Vehicule
	(
		CodV INT PRIMARY KEY IDENTITY,
		Tip VARCHAR(64) NOT NULL,
	)

	PRINT('V3: Am creat tabelul Vehicule, cu coloanele CodV (INT) si Tip (VARCHAR).')

END
GO

CREATE OR ALTER PROCEDURE IV3 AS
BEGIN

	DROP TABLE Vehicule

	PRINT('IV3: Am eliminat tabelul Vehicule.')

END
GO

CREATE OR ALTER PROCEDURE V4 AS
BEGIN
	
	ALTER TABLE Vehicule
	ADD Numar INT

	PRINT('V4: Am adaugat coloana Numar(INT).')

END
GO

CREATE OR ALTER PROCEDURE IV4 AS
BEGIN
	
	ALTER TABLE Vehicule
	DROP COLUMN Numar

	PRINT('IV4: Am eliminat coloana Numar(INT).')

END
GO

CREATE OR ALTER PROCEDURE V5 AS
BEGIN

	ALTER TABLE Vehicule
	ADD CodA INT NOT NULL

	ALTER TABLE Vehicule
	ADD CONSTRAINT fk_Vehicule FOREIGN KEY (CodA) REFERENCES Aeroporturi(CodA)

	PRINT('V5: Am adaugat coloana CodA(INT, NOT NULL) care este foreign key catre tabelul Aeroporturi.')

END
GO

CREATE OR ALTER PROCEDURE IV5 AS
BEGIN
	
	ALTER TABLE Vehicule
	DROP CONSTRAINT fk_Vehicule

	ALTER TABLE Vehicule
	DROP COLUMN CodA

	PRINT('IV5: Am eliminat coloana CodA care este foreign key catre tabelul Aeroporturi.')

END
GO

CREATE OR ALTER PROCEDURE Principala
(
	@NrVersiune VARCHAR(64)
)
AS
BEGIN

	IF ISNUMERIC(@NrVersiune) = 0
		RAISERROR('Trebuie introdus un numar pentru versiune!', 12, 1)

	ELSE
		BEGIN

			SET @NrVersiune = CAST(@NrVersiune AS INT)

		IF @NrVersiune < 0 OR @NrVersiune > 5
			RAISERROR('Nu exista o versiune cu acest numar!', 12, 1)

		ELSE
			BEGIN

				DECLARE @NrVersiuneCurenta INT
				SET @NrVersiuneCurenta = (SELECT TOP 1 NrVersiune FROM Versiune)

				DECLARE @Comanda VARCHAR(8)

				IF @NrVersiuneCurenta = @NrVersiune
					print('Baza de date se afla deja in aceasta versiune!')

				ELSE IF @NrVersiuneCurenta < @NrVersiune
					BEGIN
					
						SET @NrVersiuneCurenta = @NrVersiuneCurenta + 1

						WHILE @NrVersiuneCurenta <= @NrVersiune
							BEGIN

								SET @Comanda = 'V' + CONVERT(VARCHAR(8), @NrVersiuneCurenta)
							
								print('Executam ' + @Comanda)
								EXEC @Comanda

								SET @NrVersiuneCurenta = @NrVersiuneCurenta + 1

							END

						UPDATE Versiune
						SET NrVersiune = @NrVersiuneCurenta - 1

					END

				ELSE
					BEGIN

						WHILE @NrVersiuneCurenta > @NrVersiune
							BEGIN

								SET @Comanda = 'IV' + CONVERT(VARCHAR(8), @NrVersiuneCurenta)
							
								print('Executam ' + @Comanda)
								EXEC @Comanda

								SET @NrVersiuneCurenta = @NrVersiuneCurenta - 1

							END

						UPDATE Versiune
						SET NrVersiune = @NrVersiuneCurenta

					END

			END
		END
END
GO

SELECT * FROM Versiune

EXEC Principala -9
EXEC Principala 'Blabla'
EXEC Principala 0 
EXEC Principala 3
EXEC Principala 5
EXEC Principala 2
EXEC Principala 2
EXEC Principala 1