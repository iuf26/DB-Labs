-- Varianta cu functii ce au variabile de iesire + de vazut faza cu constraint
USE RetailWebsiteAdministration
GO

-- Pentru acest laborator am ales sa lucrez pe tabelele
-- Administrator + AdministratorSite + Site, intre Administrator si Site fiind o relatie m:n, iar tabela de la mijloc este cea de legatura

-- Aceasta functie se ocupa cu validarea datelor pentru administrator
GO
CREATE OR ALTER FUNCTION dbo.validareParametriiAdministratorF(@IdA VARCHAR(50),@Nume VARCHAR(50),@Prenume VARCHAR(50),@Varsta VARCHAR(50))
RETURNS VARCHAR(1024)
AS
BEGIN

	DECLARE @erori VARCHAR(1024)
	SET @erori = ''

	--Ca si validari pentru id verificam sa fie numeric, in caz afirmativ verificam daca este mai mare strict decat 0
	IF (ISNUMERIC(@IdA) = 0)

		SELECT @erori = @erori + 'Id-ul poate sa fie doar numeric!' + CHAR(13)	-- Folosim CHAR(13) pt \n

	ELSE IF (CAST(@IdA AS INT) <= 0)

		SELECT @erori = @erori + 'Id-ul nu poate sa fie mai mic sau egal decat 0!' + CHAR(13)

	--Ca si validari pentru nume, verificam sa nu fie vid, in caz afirmativ verificam daca contine litere
	IF (@Nume = '')

		SELECT @erori = @erori + 'Numele nu poate sa fie vid!' + CHAR(13)

	ELSE IF (@Nume NOT LIKE '[a-zA-Z]%')

		SELECT @erori = @erori + 'Numele trebuie sa contina litere!' + CHAR(13)

	--Analog pentru prenume ca la nume
	IF (@Prenume = '')

		SELECT @erori = @erori + 'Prenumele nu poate sa fie vid!' + CHAR(13)

	ELSE IF (@Prenume NOT LIKE '[a-zA-Z]%')

		SELECT @erori = @erori + 'Prenumele trebuie sa contina litere!' + CHAR(13)

	-- Analog pentru varsta ca la id
	IF (ISNUMERIC(@Varsta) = 0)

		SELECT @erori = @erori + 'Varsta poate sa fie doar numerica!' + CHAR(13)	-- Folosim CHAR(13) pt \n

	ELSE IF (CAST(@Varsta AS INT) <= 0)

		SELECT @erori = @erori + 'Varsta nu poate sa fie mai mica sau egala decat 0!' + CHAR(13)

	RETURN @erori

END
GO

DECLARE @err VARCHAR(1024)

--Exemple de date invalide pentru validareParametriiAdministrator
PRINT(dbo.validareParametriiAdministratorF ('-2', '2', '2', '-2'))
PRINT(dbo.validareParametriiAdministratorF ('a', '', '', 'a'))

--Exemple de date valide pentru validareParametriiAdministrator
PRINT(dbo.validareParametriiAdministratorF (2, 'Farca', 'Stefan', 20))
PRINT(dbo.validareParametriiAdministratorF (3, 'Popa', 'Alex', 21))
--------------------------------------------------------------------------------------------------------------------
-- Aceasta functie se ocupa cu validarea datelor pentru Site
GO
CREATE OR ALTER FUNCTION dbo.validareParametriiSiteF(@IdS VARCHAR(50),@Domeniu VARCHAR(50),@Adresa VARCHAR(50))
RETURNS VARCHAR(1024)
AS
BEGIN

	DECLARE @erori VARCHAR(1024)
	SET @erori = ''

	--Ca si validari pentru id verificam sa fie numeric, in caz afirmativ verificam daca este mai mare strict decat 0
	IF (ISNUMERIC(@IdS) = 0)

		SELECT @erori = @erori + 'Id-ul poate sa fie doar numeric!' + CHAR(13)

	ELSE IF (CAST(@IdS AS INT) <= 0)

		SELECT @erori = @erori + 'Id-ul nu poate sa fie mai mic sau egal decat 0!' + CHAR(13)

	--Ca si validari pentru domeniu, verificam sa nu fie vid, in caz afirmativ verificam sa contina o secventa de caractere si la final .com / .ro

	IF(@Domeniu = '')

		SELECT @erori = @erori + 'Domeniul site-ului nu poate sa fie vid!' + CHAR(13)

	ELSE IF (@Domeniu NOT LIKE '[a-zA-Z]%.[a-zA-Z]%')

		SELECT @erori = @erori + 'Domeniul site-ului este invalid!' + CHAR(13)

	--Ca si validari pentru adresa, verificam sa nu fie vida, in caz afirmativ verificam daca respecta un pattern - www.(nume).(ro/com/...)

	IF(@Adresa = '')

		SELECT @erori = @erori + 'Adresa site-ului nu poate sa fie vida!' + CHAR(13)

	ELSE IF (@Adresa NOT LIKE '[wW][wW][wW].[a-zA-Z]%.%')

		SELECT @erori = @erori + 'Adresa site-ului este invalida!' + CHAR(13)

	RETURN @erori

END
GO

--Exemple de validari pe care functia validareParametriiSite ridica erori
PRINT(dbo.validareParametriiSiteF ('a', '', ''))
PRINT(dbo.validareParametriiSiteF ('-2', 'invalid.', '.da.com'))

--Exemple de validari pe care functia validareParametriiSite nu ridica erori
PRINT(dbo.validareParametriiSiteF (2, 'altex.ro', 'www.altex.ro'))
PRINT(dbo.validareParametriiSiteF (3, 'emag.ro', 'www.emag.ro'))
--------------------------------------------------------------------------------------------------------------------
-- Aceasta functie se ocupa cu validarea parametriilor pentru tabelul AdministratorSite
GO
CREATE OR ALTER FUNCTION dbo.validareParametriiAdministratorSiteF(@IdA VARCHAR(50),@IdS VARCHAR(50))
RETURNS VARCHAR(1024)
AS
BEGIN

	DECLARE @erori VARCHAR(1024)
	SET @erori = ''

	--Ca si validari pentru idA verificam sa fie numeric, in caz afirmativ verificam daca este mai mare strict decat 0
	IF (ISNUMERIC(@IdA) = 0)

		SELECT @erori = @erori + 'Id-ul administratorului poate sa fie doar numeric!' + CHAR(13)

	ELSE IF (CAST(@IdA AS INT) <= 0)

		SELECT @erori = @erori + 'Id-ul administratorului nu poate sa fie mai mic sau egal decat 0!' + CHAR(13)

	--Ca si validari pentru idS verificam sa fie numeric, in caz afirmativ verificam daca este mai mare strict decat 0
	IF (ISNUMERIC(@IdS) = 0)

		SELECT @erori = @erori + 'Id-ul site-ului poate sa fie doar numeric!' + CHAR(13)

	ELSE IF (CAST(@IdS AS INT) <= 0)

		SELECT @erori = @erori + 'Id-ul site-ului nu poate sa fie mai mic sau egal decat 0!' + CHAR(13)

	RETURN @erori

END
GO

--Exemple pentru care functia validareParametriiAdministratorSite ridica erori
PRINT(dbo.validareParametriiAdministratorSiteF ('', ''))
PRINT(dbo.validareParametriiAdministratorSiteF (-2, -2))

--Exemple pentru care functia validareParametriiAdministratorSite nu ridica erori
PRINT(dbo.validareParametriiAdministratorSiteF (2, 2))
PRINT(dbo.validareParametriiAdministratorSiteF (3, 10))

--------------------------------------------------------------------------------------------------------------------
--Definim o functie ce verifica daca exista deja id-ul trimis ca si parametru in Administrator 
GO
CREATE OR ALTER FUNCTION dbo.verificareExistentaIdAdministratorF(@IdA INT)
RETURNS INT
AS
BEGIN

	IF EXISTS(SELECT * FROM Administrator WHERE IdA = @IdA)

		RETURN 1	-- true

	RETURN 0 -- false

END
GO

--Exemple pentru functia verificareExistentaIdAdministrator
PRINT(dbo.verificareExistentaIdAdministratorF(1))
PRINT(dbo.verificareExistentaIdAdministratorF(100))
--------------------------------------------------------------------------------------------------------------------
--Definim o functie ce verifica daca exista deja id-ul trimis ca si parametru in Site
GO
CREATE OR ALTER FUNCTION dbo.verificareExistentaIdSiteF(@IdS INT)
RETURNS INT
AS
BEGIN

	IF EXISTS(SELECT * FROM Site WHERE IdS = @IdS)

		RETURN 1	-- true

	RETURN 0	-- false

END
GO

--Exemple pentru functia verificareExistentaIdSite
PRINT(dbo.verificareExistentaIdSiteF(1))
PRINT(dbo.verificareExistentaIdSiteF(100))
--------------------------------------------------------------------------------------------------------------------
--Definim o functie ce verifica daca exista deja o inregistrare in tabelul AdministratorSite
GO
CREATE OR ALTER FUNCTION dbo.verificareExistentaIdAdministratorSiteF(@IdA INT,@IdS INT)
RETURNS INT
AS
BEGIN
	
	IF EXISTS(SELECT * FROM AdministratorSite WHERE IdA = @IdA AND IdS = @IdS)

		RETURN 1	-- true

	RETURN 0	-- false

END
GO

--Exemple pentru functia verificareExistentaIdAdministratorSite
PRINT(dbo.verificareExistentaIdAdministratorSiteF(1, 1))
PRINT(dbo.verificareExistentaIdAdministratorSiteF(100, 100))
--------------------------------------------------------------------------------------------------------------------
--Aceasta este procedura ce se ocupa cu realizarea operatiilor CRUD pe tabelul Administrator
GO
CREATE OR ALTER PROCEDURE CRUD_AdministratorF
@IdA VARCHAR(50),
@Nume VARCHAR(50),
@Prenume VARCHAR(50),
@Varsta VARCHAR(50),
@result VARCHAR(1024) OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @id_convertit INT
	DECLARE @varsta_convertita INT
	DECLARE @valid VARCHAR(1024)

	SET @valid = dbo.validareParametriiAdministratorF (@IdA, @Nume, @Prenume, @Varsta)

	IF (@valid = '')	-- daca trecem de validari putem face conversia
	BEGIN

		SET @id_convertit = CONVERT(INT, @IdA)

		SET @varsta_convertita = CONVERT(INT, @Varsta)

		IF (dbo.verificareExistentaIdAdministratorF(@id_convertit) = 1)

			SET @result = 'Mai exista un administrator cu acest ID!'

		ELSE
		BEGIN

			-- CREATE
			INSERT INTO Administrator(IdA, Nume, Prenume, Varsta) VALUES (@id_convertit, @Nume, @Prenume, @varsta_convertita)
			PRINT('S-a realizat cu succes operatia de Insert pentru Administrator!')

			-- READ
			SELECT * FROM Administrator
			PRINT('S-a realizat cu succes operatia de citire a tuturor Administratorilor!')

			-- UPDATE
			UPDATE Administrator SET Nume = 'UPDATE' WHERE IdA = @id_convertit
			PRINT('S-a modificat un Administrator cu succes!')

			-- DELETE
			DELETE FROM Administrator WHERE IdA = @id_convertit
			PRINT('Administratorul a fost sters cu succes!')

			SET @result = 'S-au efectuat cu succes operatiile CRUD pe tabela Administrator!'

		END
	END
	ELSE
		
		SET @result = @valid

END

-- Exemple de teste 2 bune, 2 ce arunca erori
DECLARE @err VARCHAR(1024)
EXEC CRUD_AdministratorF 7, 'Popa', 'Andrei', 25, @err OUTPUT
PRINT (@err + CHAR(13))
EXEC CRUD_AdministratorF 8, 'Popescu', 'Popel', 35, @err OUTPUT
PRINT (@err + CHAR(13))
EXEC CRUD_AdministratorF 1, 'Popa', 'Andrei', 25, @err OUTPUT
PRINT (@err + CHAR(13))
EXEC CRUD_AdministratorF -2, '', '', 'a', @err OUTPUT
PRINT (@err)

--------------------------------------------------------------------------------------------------------------------
--Aceasta este procedura ce se ocupa cu realizarea operatiilor CRUD pe tabelul Site
GO
CREATE OR ALTER PROCEDURE CRUD_SiteF
@IdS VARCHAR(50),
@Domeniu VARCHAR(50),
@Adresa VARCHAR(50),
@result VARCHAR(1024) OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @exista INT
	DECLARE @id_convertit INT
	DECLARE @valid VARCHAR(1024)

	SET @valid = dbo.validareParametriiSiteF(@IdS, @Domeniu, @Adresa)

	IF (@valid = '')	-- inseamna ca e valid
	BEGIN

		SET @id_convertit = CONVERT(INT, @IdS)

		IF (dbo.verificareExistentaIdSiteF(@id_convertit) = 1)

			SET @result = 'Exista deja un site cu acest ID!';

		ELSE
		BEGIN

			--CREATE
			INSERT INTO Site(IdS, Domeniu, Adresa) VALUES (@id_convertit, @Domeniu, @Adresa)
			PRINT('S-a realizat cu succes operatie de insert in tabelul Site!')

			--READ
			SELECT * FROM Site
			PRINT('S-a realizat cu succes operatia de citire pe tabelul Site!')

			--UPDATE
			UPDATE Site SET Domeniu = 'test.com' WHERE IdS = @id_convertit
			PRINT('S-a realizat cu succes modificarea pe tabelul Site!')

			--DELETE
			DELETE FROM Site WHERE IdS = @id_convertit
			PRINT('S-a realizat cu succes stergerea pe tabelul Site!')

			SET @result = 'S-au efectuat cu succes toate operatiile crud pe tabela Site!'

		END
	END
	ELSE

		SET @result = @valid

END

-- Exemple de teste 2 bune, 2 ce arunca erori
DECLARE @err2 VARCHAR(1024)
EXEC CRUD_SiteF 7, 'google.ro', 'www.google.ro', @err2 OUTPUT
PRINT(@err2 + CHAR(13))
EXEC CRUD_SiteF 8, 'facebook.com', 'WWW.facebook.com', @err2 OUTPUT
PRINT(@err2 + CHAR(13))
EXEC CRUD_SiteF 1, 'google.ro', 'www.google.ro', @err2 OUTPUT
PRINT(@err2 + CHAR(13))
EXEC CRUD_SiteF -1, 'google', 'wgoogle.ro', @err2 OUTPUT
PRINT(@err2)

--------------------------------------------------------------------------------------------------------------------
-- Aceasta este procedura ce se ocupa cu realizarea operatiilor CRUD pe tabelul AdministratorSite
GO
CREATE OR ALTER PROCEDURE CRUD_AdministratorSiteF
@IdA VARCHAR(50),
@IdS VARCHAR(50),
@result VARCHAR(1024) OUTPUT
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @id_admin INT
	DECLARE @id_site INT
	DECLARE @erori_business VARCHAR(100)
	DECLARE @valid VARCHAR(1024)

	SET @valid = dbo.validareParametriiAdministratorSiteF (@IdA, @IdS)

	IF (@valid = '') -- inseamna ca e valid
	BEGIN

		SET @id_admin = CONVERT(INT, @IdA)
		SET @id_site = CONVERT(INT, @IdS)

		SET @erori_business = ''	-- verificam daca avem extremele in tabel

		IF (dbo.verificareExistentaIdAdministratorF(@id_admin) = 0)

			SELECT @erori_business = @erori_business + 'Nu exista un administrator cu id-ul introdus!' + CHAR(13)

		IF (dbo.verificareExistentaIdSiteF(@id_site) = 0)
		
			SELECT @erori_business = @erori_business + 'Nu exista un site cu id-ul introdus!' + CHAR(13)

		IF (@erori_business != '')

			SET @result = @erori_business

		ELSE
		BEGIN

			IF (dbo.verificareExistentaIdAdministratorSiteF(@id_admin, @id_site) = 1)

				SET @result = 'Mai exista deja o inregistrare cu aceste date!'

			ELSE
			BEGIN
	
				--CREATE
				INSERT INTO AdministratorSite(IdA, IdS) VALUES (@id_admin, @id_site)
				PRINT('S-a realizat cu succes operatia de insert in tabelul AdministratorSite!')

				--READ
				SELECT * FROM AdministratorSite
				PRINT('S-a realizat cu succes operatia de citire in tabelul AdministratorSite!')

				--UPDATE
				PRINT('Nu se poate realiza operatia de update pentru ca tabela intermediara contine doar Primary Keys si Foreign Keys!')

				--DELETE
				DELETE FROM AdministratorSite WHERE IdA = @id_admin AND IdS = @id_site
				PRINT('S-a realizat cu succes operatia de stergere in tabelul AdministratorSite!')

				SET @result = 'S-au realizat cu succes operatiile CRUD pe tabelul AdministratorSite!'

			END
		END
	END
	ELSE

		SET @result = @valid

END

-- Exemple de teste 2 bune, 4 ce arunca erori
DECLARE @err3 VARCHAR(1024)
EXEC CRUD_AdministratorSiteF 1, 3, @err3 OUTPUT
PRINT(@err3 + CHAR(13))
EXEC CRUD_AdministratorSiteF 2, 5, @err3 OUTPUT
PRINT(@err3 + CHAR(13))
EXEC CRUD_AdministratorSiteF 1, 2, @err3 OUTPUT
PRINT(@err3 + CHAR(13))
EXEC CRUD_AdministratorSiteF 'a', 'a', @err3 OUTPUT
PRINT(@err3 + CHAR(13))
EXEC CRUD_AdministratorSiteF 1, 8, @err3 OUTPUT
PRINT(@err3 + CHAR(13))
EXEC CRUD_AdministratorSiteF 8, 1, @err3 OUTPUT
PRINT(@err3)

--------------------------------------------------------------------------------------------------------------------
-- Acest index este facut pe coloana Varsta
IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='index_Administrator')
DROP INDEX index_Administrator ON Administrator
CREATE NONCLUSTERED INDEX index_Administrator ON Administrator(Varsta) 

GO
CREATE OR ALTER VIEW view1
AS
SELECT A.IdA, A.Nume, A.Prenume, A.Varsta, S.Adresa FROM Administrator as A, AdministratorSite as AdminSite, Site as S 
WHERE A.IdA = AdminSite.IdA AND AdminSite.IdS = S.IdS
GO

SELECT * FROM view1
ORDER BY Varsta

--------------------------------------------------------------------------------------------------------------------
-- Acest index este facut pe coloana Domeniu din tabelul Site
IF EXISTS (SELECT NAME FROM sys.indexes WHERE name='index_Site')
DROP INDEX index_Site ON Site
CREATE NONCLUSTERED INDEX index_Site ON Site(Domeniu) 

GO
CREATE OR ALTER VIEW view2
AS
SELECT S.Domeniu, A.Nume, A.Prenume FROM Administrator as A, AdministratorSite as AdminSite, Site as S 
WHERE A.IdA = AdminSite.IdA AND AdminSite.IdS = S.IdS
GO

SELECT * FROM view2
ORDER BY Domeniu