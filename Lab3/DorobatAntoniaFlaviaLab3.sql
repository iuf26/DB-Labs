USE InstallationCompany
GO 


--modifica tipul coloanei Nume
--din varchar(50) in varchar (100) 

CREATE PROCEDURE do_1
AS 
BEGIN 
ALTER TABLE Plumbers
ALTER COLUMN Name nvarchar(100)
Print 'Coloana a fost modificata cu succes! -----> VERSIUNEA 1' 
END; 

--reface tipul coloanei
--din varchar(100) in varchar(50) 

CREATE PROCEDURE undo_1
AS 
BEGIN 
ALTER TABLE Plumbers
ALTER COLUMN Name varchar(50)
Print 'Coloana a fost modificata cu succes! ------> VERSIUNEA 0'
END; 


--constrangerea care adauga o valoare implicita pntru un camp
--campul Nume va fi default cu valoarea 'Bob' pentru orice instalator adaugat 

CREATE PROCEDURE do_2
AS 
BEGIN 
ALTER TABLE Plumbers 
ADD CONSTRAINT df_2 DEFAULT 'Bob' FOR Name
Print 'Constrangerea pt nume a fost adaugata cu succes! ---------> VERSIUNEA 2' 
END; 


--sterge constrangerea adaugata pentru camp 
CREATE PROCEDURE undo_2
AS 
BEGIN 
ALTER TABLE Plumbers
DROP CONSTRAINT df_2;
Print 'Constrangerea pt nume a fost stearsa!  ---------> VERSIUNEA 1' 
END; 


--creeaza o tabela noua, corespunzatoare clientilor
CREATE PROCEDURE do_3
AS
BEGIN 
CREATE TABLE Clients
(id_client int PRIMARY KEY IDENTITY, 
Name varchar(50), 
Address varchar(50), 
PhoneNo bigint
);
Print 'Tabela a fost creata cu succes! ---------> VERSIUNEA 3'
END; 

--sterge tabela creata 
CREATE PROCEDURE undo_3
AS 
BEGIN 
DROP TABLE Clients
Print 'Tabela a fost stearsa cu succes! ---------> VERSIUNEA 2' 
END; 


--se adauga un camp nou la tabela Clienti
--campul Age
CREATE PROCEDURE do_4
AS
BEGIN
ALTER TABLE Clients
ADD Age int
Print 'Campul a fost adaugat cu succes la tabela Clients! --------> VERSIUNEA 4'
END; 

--sterge campul anterior adaugat Age din tabela Clients

CREATE PROCEDURE undo_4
AS
BEGIN 
ALTER TABLE Clients
DROP COLUMN Age
Print 'Campul a fost sters cu succes din tabela Clients! --------> VERSIUNEA 3' 
END; 


--adauga constrangerea foreign key pt Clienti, referind un instalator

CREATE PROCEDURE do_5
AS 
BEGIN 

ALTER TABLE Clients
ADD Pid INT NOT NULL 

ALTER TABLE Clients
ADD CONSTRAINT fk_id_plumber FOREIGN KEY (Pid) REFERENCES Plumbers(Pid)
Print 'Constrangerea foreign key a fost adaugata! ------------> VERSIUNEA 5'
END; 



--sterge constrangerea fk 
CREATE PROCEDURE undo_5
AS
BEGIN
ALTER TABLE Clients
DROP CONSTRAINT fk_id_plumber

ALTER TABLE Clients
DROP COLUMN Pid
Print 'Constrangerea foreign key a fost stearsa! -----------> VERSIUNEA 4'
END; 



--creez tabelul de versiuni  
CREATE TABLE VersiuneCurenta
(versiune int)


--incep de la versiunea 0
insert into VersiuneCurenta values (0);

CREATE PROCEDURE main
@versiune int  --primim un intreg, reprezentand nr versiunii la care vrem sa ajungem
AS
BEGIN
	IF @versiune>5  OR @versiune<0
	BEGIN
		RAISERROR('Versiunea dorita nu este disponibila!',11,1);
	END
	ELSE
	BEGIN
		DECLARE @versiuneTabela int
		SET @versiuneTabela=( SELECT V.versiune FROM VersiuneCurenta V)
		IF @versiune=@versiuneTabela
		BEGIN
			RAISERROR('Versiunea este deja cea dorita!',9,1);
		END
		ELSE
		BEGIN
			DECLARE @numeProcedura varchar(30)  --un sir de caractere in care o sa formez numele procedurilor
			IF @versiune<@versiuneTabela
			BEGIN
				WHILE @versiune<@versiuneTabela
				BEGIN
					SET @numeProcedura='undo_'+CAST(@versiuneTabela AS CHAR);
					EXEC @numeProcedura;
					SET @versiuneTabela=@versiuneTabela-1;
				END
			END
			ELSE
			BEGIN
				SET @versiuneTabela=@versiuneTabela+1
				WHILE @versiuneTabela<=@versiune
				BEGIN
					SET @numeProcedura='do_'+CAST(@versiuneTabela AS CHAR);
					EXEC @numeProcedura;
					SET @versiuneTabela=@versiuneTabela+1;
				END
			END
			UPDATE VersiuneCurenta
			SET versiune=@versiune
		END
	END
END


exec main -1;
exec main 1;
exec main 0;
exec main 2; 
exec main 3;
exec main 4; 
exec main 5; 
exec main 6; 
exec main 100;
                   
SELECT *From Plumbers; 
--SELECT *From Clients;