use PrivateHospital3
go
CREATE TABLE Versiune(
	versiune int default 0
)
select * from Versiune

/*------------------------------A.Modifica tip coloana-------------------------------------------------------*/
/*Modifica tipul coloanei Name din tabelul HeadOfDepartment*/
ALTER TABLE HeadOfDepartment
ALTER COLUMN Name varchar(600);
/*Reface tipul coloanei Nume din tabelul HeadOfDepartment*/
/*Verific daca s-a schimbat corect tipul de data*/
go
CREATE or ALTER PROCEDURE usp_do_operation1
AS
BEGIN
Declare @msg varchar(200)='Column Name from HeadOfDepartment table has data type modified';
begin try
ALTER TABLE HeadOfDepartment
ALTER COLUMN Name varchar(600);
PRINT @msg
end try
begin catch
set @msg=(select ERROR_MESSAGE())
print @msg;
end catch
END;
GO

CREATE or ALTER PROCEDURE usp_undo_operation1
AS
BEGIN
Declare @msg varchar(200);
begin try
ALTER TABLE HeadOfDepartment
ALTER COLUMN Name varchar(300);
PRINT 'Undo operation for column Name data type from table HeadOfDepartment succeeded'
end try
begin catch
set @msg=(select ERROR_MESSAGE())
print @msg;
end catch
END;
GO

select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH from INFORMATION_SCHEMA.COLUMNS 
where table_name='HeadOfDepartment'
EXEC usp_do_operation1;
EXEC usp_undo_operation1;

/*-------------------------B.Adauga constrangere de valoare implicita pentru un camp-----------------------------------------------------------------------*/
/*Modific constrangerea de valoare implicita pentru tabela Medication si campul Brand*/
SELECT * FROM Medication
ALTER TABLE Medication ADD CONSTRAINT DF_Medication_Brand 
DEFAULT 'No_brandName' for Brand
PRINT 'S a adaugat'
go

/*Pentru a scapa de constrangere*/
ALTER TABLE Medication
DROP CONSTRAINT DF_Medication_Brand
GO

CREATE OR ALTER PROCEDURE usp_do_operation2
AS
BEGIN
DECLARE @msg varchar(150)='Setting  default constraint DF_Medication_Brand succeeded!';
begin try
ALTER TABLE Medication ADD CONSTRAINT DF_Medication_Brand 
DEFAULT 'No_brandName' for Brand
PRINT @msg;
end try
begin catch
set @msg=(select ERROR_MESSAGE())
print @msg;
end catch
END;
GO

CREATE OR ALTER PROCEDURE usp_undo_operation2
AS
BEGIN
DECLARE @msg varchar(200)='DF_Medication_Brand constraint has been removed'
begin try
ALTER TABLE Medication
DROP CONSTRAINT DF_Medication_Brand
PRINT @msg;
end try
begin catch
set @msg=(select ERROR_MESSAGE())
print @msg;
end catch
END;
GO
select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS 
where table_name='Medication'
EXECUTE   usp_do_operation2;
EXECUTE   usp_undo_operation2;

/*--------------------------------------------------------------C.Creeaza o tabela------------------------------------------------------------------------------------------------------*/
go
CREATE or ALTER PROCEDURE usp_do_operation3
AS
BEGIN
DECLARE @msg varchar(100)='Successfully created table Laboratory';
BEGIN TRY
CREATE TABLE Laboratory(
	ID int not null PRIMARY KEY IDENTITY,
	research_subject varchar(300),
	location varchar(300)
)
PRINT @msg;
END TRY
BEGIN CATCH
set @msg=(SELECT ERROR_MESSAGE());
PRINT @msg
END CATCH
END;
GO

CREATE or alter PROCEDURE usp_undo_operation3
AS
BEGIN
DECLARE @msg varchar(100)='Successfully removed table Laboratory';
	BEGIN TRY
DROP TABLE Laboratory
PRINT @msg;
	END TRY
	BEGIN CATCH
set @msg=(SELECT ERROR_MESSAGE())
PRINT @msg;
	END CATCH
END;
GO

EXECUTE usp_do_operation3;
EXECUTE usp_undo_operation3;

select TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,COLUMN_DEFAULT from INFORMATION_SCHEMA.COLUMNS 
where table_name='Laboratory'
select * from Laboratory;

/*--------------------------------------------------D.Adauga un camp nou in tabela--------------------------------------------------------------------------------*/
ALTER TABLE Laboratory
ADD Physician_id int null
GO
UPDATE  Laboratory SET Physician_id=0
GO
ALTER TABLE Laboratory ALTER COLUMN Physician_id int not null
GO


select * from Laboratory

ALTER TABLE Laboratory
DROP COLUMN Establishment_date;
GO

CREATE or alter PROCEDURE usp_do_operation4
AS
BEGIN
	DECLARE @msg varchar(100)='Physician_id column added';
	begin try
	ALTER TABLE Laboratory 
	ADD Physician_id int null;
	PRINT @msg;
	end try
	begin catch
	set @msg=(SELECT ERROR_MESSAGE())
	PRINT @msg;
	end catch
END;
GO

CREATE or alter PROCEDURE usp_undo_operation4
AS
BEGIN
DECLARE @msg varchar(100)='Physician_id column removed';
begin try
	ALTER TABLE Laboratory
	DROP COLUMN Physician_id;
	PRINT @msg;
	end try
	begin catch
	set @msg=(SELECT ERROR_MESSAGE());
	PRINT @msg;
end catch
END;
GO
SELECT * FROM Laboratory
EXECUTE usp_do_operation4
EXECUTE usp_undo_operation4

/*---------------------------------------E.Adauga constrangere de cheie straina---------------------------------------------------------------------------------------*/
go
ALTER TABLE Laboratory 
ADD Ph_id int  not null default 0
ALTER TABLE Laboratory
ADD CONSTRAINT FK_Laboratory_Physician FOREIGN KEY(Ph_id) REFERENCES Physician(PhysicianID)

go
CREATE or alter PROCEDURE usp_do_operation5
AS
BEGIN
DECLARE @msg varchar(100)='Successfully added foreign Key constraint for table Laboratory ';
begin try
	
	ALTER TABLE Laboratory
	ADD CONSTRAINT FK_Laboratory_Physician FOREIGN KEY(Physician_id) REFERENCES Physician(PhysicianID)
	PRINT @msg;
	end try
	begin catch
	set @msg=(SELECT ERROR_MESSAGE());
	PRINT @msg;
end catch
END;
GO

ALTER TABLE Laboratory
DROP CONSTRAINT FK_Laboratory_Physician 
go

CREATE or alter PROCEDURE usp_undo_operation5
AS
BEGIN
DECLARE @msg varchar(100)='Foreign Key constraint for table Laboratory removed';
begin try
	ALTER TABLE Laboratory
	DROP CONSTRAINT FK_Laboratory_Physician;
	PRINT @msg;
	end try
	begin catch
	set @msg=(SELECT ERROR_MESSAGE());
	PRINT @msg;
end catch
END;
GO
select * from Laboratory;
EXECUTE usp_do_operation5
EXECUTE usp_undo_operation5

/***************************************************************************************************************************************************/
select * from Versiune
DECLARE @nr2 VARCHAR(10);
select @nr2=(SELECT CAST(25.65 AS varchar(10)));
print @nr2;
DECLARE @v1 VARCHAR(40);  
SET @v1 = 'This is the original.';  
SET @v1 += ' More text.';
PRINT @v1;
GO

INSERT INTo Versiune(versiune) values(0);
go
CREATE OR ALTER PROCEDURE usp_Versiune_dbo @nr int
AS
BEGIN
declare @current_version int
declare @function_toCall varchar(300)
set @current_version=0
select top 1 @current_version=versiune from Versiune;
IF(@nr>5 or @nr<0) 
	PRINT 'Invalid dbo version';
else
IF(@current_version=@nr)
	print 'Baza de date este deja la versiunea dorita';
ELSE
begin

	if(@current_version<@nr)
	begin
	while(@current_version<@nr)
		begin
			declare @aux varchar(10);
			select @aux=(SELECT CAST(@current_version+1 as varchar(10)));
			set @function_toCall='usp_do_operation';
			set @function_toCall +=@aux ;
			EXECUTE @function_toCall
			set @current_version=@current_version+1
		end
	end
	else
		begin
		while(@current_version>@nr)
			begin
			declare @aux2 varchar(10);
			select @aux2=(SELECT CAST(@current_version as varchar(10)));
			set @function_toCall='usp_undo_operation';
			set @function_toCall +=@aux2 ;
			EXECUTE @function_toCall
			set @current_version=@current_version-1
			end
		end
	UPDATE Versiune set versiune=@nr;
	Print 'Executie cu succes';
end

  /*'Baza de date este deja la versiunea dorita';*/
 
END
GO
EXECUTE usp_Versiune_dbo 0;
EXECUTE usp_Versiune_dbo -100;
EXECUTE usp_Versiune_dbo 20;
EXECUTE usp_Versiune_dbo 2;
EXECUTE usp_Versiune_dbo 1;
select * from Versiune;
UPDATE Versiune set versiune=1;