USE farmacie_database
GO

CREATE TABLE versiune (
versiune_id INT PRIMARY KEY DEFAULT 0)
GO

INSERT INTO versiune(versiune_id)
VALUES (0)
GO

CREATE PROCEDURE UPGRADE1
AS
	BEGIN
		ALTER TABLE vanzare 
		ALTER COLUMN suma BIGINT NOT NULL
		UPDATE versiune SET versiune_id = 1
		PRINT 'Tipul coloanei "suma" din tabela "vanzare" este acum BIGINT'
	END
GO

CREATE PROCEDURE DOWNGRADE1
AS
	BEGIN
		ALTER TABLE vanzare 
		ALTER COLUMN suma INT NOT NULL
		UPDATE versiune SET versiune_id = 0
		PRINT 'Tipul coloanei "suma" din tabela "vanzare" este acum INT'
	END
GO

CREATE PROCEDURE UPGRADE2
AS
	BEGIN
		ALTER TABLE card_client
		ADD CONSTRAINT df_data_expirare DEFAULT '2023-01-01' FOR data_expirare
		UPDATE versiune SET versiune_id = 2
		PRINT 'data_expirare are acum valoarea implicita "2023-01-01"'
	END
GO

CREATE PROCEDURE DOWNGRADE2
AS
	BEGIN
		ALTER TABLE card_client
		DROP CONSTRAINT df_data_expirare
		UPDATE versiune SET versiune_id = 1
		PRINT 'data_expirare nu are o valoare implicita'
	END
GO

CREATE PROCEDURE UPGRADE3
AS
	BEGIN
		CREATE TABLE studiu(
		studiu_id INT PRIMARY KEY,
		denumire VARCHAR(50) NOT NULL,
		promotie INT)
		UPDATE versiune SET versiune_id = 3
		PRINT 'Tabela "studiu" a fost creata'
	END
GO

CREATE PROCEDURE DOWNGRADE3
AS
	BEGIN
		DROP TABLE studiu
		UPDATE versiune SET versiune_id = 2
		PRINT 'Tabela "studiu" a fost stearsa'
	END
GO

CREATE PROCEDURE UPGRADE4
AS
	BEGIN
		ALTER TABLE studiu
		ADD manager_id INT
		UPDATE versiune SET versiune_id = 4
		PRINT 'Coloana "manager_id" a fost adaugata in tabela "studiu"'
	END
GO

CREATE PROCEDURE DOWNGRADE4
AS
	BEGIN
		ALTER TABLE studiu
		DROP COLUMN manager_id
		UPDATE versiune SET versiune_id = 3
		PRINT 'Coloana "manager_id" a fost stearsa din tabela "studiu"'
	END
GO

CREATE PROCEDURE UPGRADE5
AS
	BEGIN
		ALTER TABLE studiu
		ADD CONSTRAINT fk_studiu_manager FOREIGN KEY(manager_id) REFERENCES manager(manager_id)
		UPDATE versiune SET versiune_id = 5
		PRINT 'Constrangere cheie straina fk_studiu_manager adaugata'
	END		
GO

CREATE PROCEDURE DOWNGRADE5
AS
	BEGIN
		ALTER TABLE studiu
		DROP CONSTRAINT fk_studiu_manager
		UPDATE versiune SET versiune_id = 4
		PRINT 'Constrangere cheie straina fk_studiu_manager stearsa'
	END
GO


CREATE PROCEDURE MAIN
@versiune_noua INT
AS
	DECLARE @versiune_veche INT
	DECLARE @comanda VARCHAR(50)
	SELECT TOP 1 @versiune_veche = versiune_id
	FROM versiune

	IF @versiune_noua = @versiune_veche
	BEGIN
		PRINT 'Versiunea bazei de date este deja ' + CONVERT(VARCHAR(5), @versiune_veche) 
	END
	ELSE
		IF @versiune_noua < 0 or @versiune_noua > 5
		BEGIN
			PRINT 'Versiunea introdusa trebuie sa fie cumprinsa intre 0 si 5'
		END
		ELSE
		BEGIN
			IF @versiune_veche < @versiune_noua
			BEGIN
				SET @versiune_veche = @versiune_veche + 1
				WHILE @versiune_veche <= @versiune_noua
				BEGIN
					SET @comanda = 'UPGRADE' + CONVERT(VARCHAR(5), @versiune_veche)
					EXECUTE @comanda
					PRINT 'Baza de date a trecut de la versiunea ' + CONVERT(VARCHAR(5), @versiune_veche - 1) + ' la versiunea ' + CONVERT(VARCHAR(5), @versiune_veche) 
					SET @versiune_veche = @versiune_veche + 1
				END
			END
			ELSE
			BEGIN
				IF @versiune_veche > @versiune_noua
				BEGIN
					WHILE @versiune_veche > @versiune_noua
					BEGIN
						SET @comanda = 'DOWNGRADE' + CONVERT(VARCHAR(5), @versiune_veche)
						EXECUTE @comanda
						PRINT 'Baza de date a trecut de la versiunea ' + CONVERT(VARCHAR(5), @versiune_veche) + ' la versiunea ' + CONVERT(VARCHAR(5), @versiune_veche - 1) 
						SET @versiune_veche = @versiune_veche - 1
					END
				END
			END
		END
GO


EXECUTE MAIN 1

SELECT * FROM VERSIUNE