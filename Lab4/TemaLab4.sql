/*Modified Tables table*/
USE PrivateHospital3
GO
INSERT INTO Tables(Name) VALUES ('Patient'),('Stay'),('MedicalPrescription');
SELECT * FROM Tables;

SELECT * FROM Patient;
/*VIEW 1:Selecteaza numele pacientilor din Bucuresti*/
GO
CREATE VIEW vw_BucurestiPatients AS
SELECT Name,Adress
FROM Patient
WHERE Adress LIKE '%Bucuresti%';
GO
SELECT * FROM vw_BucurestiPatients
GO


/*View 2:Pacientii care au primit prescriptii medicale si care au stat in spital in anul 2002*/
GO
CREATE VIEW vw_2002StaysWithPrescribedMedicine AS
SELECT distinct p.Name,p.PatientID FROM Patient p
INNER JOIN MedicalPrescription mp on mp.PatientID=p.PatientID
INNER JOIN Stay s ON s.PatientID=p.PatientID
WHERE s.start_time  LIKE '%2002%' OR s.end_time LIKE '%2002%'
go
select * from MedicalPrescription
select * from Stay
select * from Tables;

/*VIEW 3: Numarul total de sederi al pacientilor in spital*/
GO
CREATE VIEW vw_TotalPatientStays AS
SELECT p.Name,count(s.PatientID) as Stays FROM Patient p 
INNER JOIN Stay s ON p.PatientID=s.PatientID
GROUP BY p.Name
GO

/***************************************Partea  de introducere a multor date in baza de date************************/
/**1.Tabelul Tests*****/
INSERT INTO Tests(Name) VALUES 
('select_view')
SELECT * FROM Tests
INSERT INTO Tests(Name) VALUES
('insert_Patient'),('insert_Stay'),('delete_Patient'),('delete_Stay')
,('insert_MedicalPrescription'),('delete_MedicalPrescription')

/*******Proceduri stocate pentru a introduce/sterge date din tabele*************/

/*Patient-insert   insereaza @rows linii in tabelul Patient*/

GO
CREATE or ALTER PROCEDURE usp_insert_Patient @rows int
AS
BEGIN
 DECLARE @current_number INT;
 SET @current_number=0;
 WHILE (@current_number<@rows) 
	BEGIN
		DECLARE @entity_name VARCHAR(30);
		DECLARE @phone_number VARCHAR(6);
		DECLARE @adress VARCHAR(30);
		DECLARE @string_value_of_current_number VARCHAR(20);
		DECLARE @aux int;
		DECLARE @city VARCHAR(20);
		SET @string_value_of_current_number = (SELECT CAST(@current_number as varchar(20)));

		SET @entity_name='Patient';
		SET @entity_name += @string_value_of_current_number;
		SET @phone_number = 'Phone'
		SET @phone_number += @string_value_of_current_number;
		SET @aux=ROUND(RAND() * 2, 0) ;
		SET @city =(SELECT CASE 
					WHEN @aux=0 THEN 'Bucuresti' 
					WHEN @aux=1 THEN 'Brasov' 
					ELSE 'Cluj' END);
		INSERT INTO Patient(Name,Phone,Adress) VALUES (@entity_name,@phone_number,@city);
		SET @current_number=@current_number+1;
	END
END
GO




/**Stay- insert Insereaza @row linii in tabelul Stay**/
GO
CREATE OR ALTER PROCEDURE usp_insert_Stay @rows INT
AS
BEGIN
	DECLARE @fk_Room INT;
	DECLARE @fk_Patient INT;
	DECLARE @current_number INT;
	DECLARE @date VARCHAR(40);
	DECLARE @aux int;
	SET @current_number=0;
	WHILE (@current_number<@rows) 
		BEGIN	
			SELECT TOP 1 @fk_Room=RoomID FROM Room WHERE RoomID%2=@current_number%2;
			SELECT TOP 1 @fk_Patient=PatientID FROM Patient ORDER BY NEWID();
			SET @aux=ROUND(RAND() * 2, 0) ;
			SET @date =(SELECT CASE 
					WHEN @aux=0 THEN 'testDate 26.03.2002' 
					WHEN @aux=1 THEN 'testDate2' 
					ELSE 'testDate3' END);
			INSERT INTO Stay(PatientID,RoomID,start_time,end_time) VALUES (@fk_Patient,@fk_Room,@date,NULL);
			SET @current_number+=1;
		END
END
GO



/*Medical prescription- Insereaza @row linii in tabelul MedicalPrescription*/


GO
CREATE OR ALTER PROCEDURE usp_insert_MedicalPrescription @rows INT
AS
BEGIN
	DECLARE @fk_Physician INT;
	DECLARE @fk_Patient INT;
	DECLARE @fk_Medication INT;
	DECLARE @current_number INT;
	DECLARE @limit INT;
	DECLARE @free_space INT;
	DECLARE @getid CURSOR;
	SET @getid = CURSOR FOR
				SELECT PatientID,PhysicianID 
				FROM Patient cross join Physician;
	SET @current_number=0;
	SET @limit = (SELECT COUNT(PatientID)FROM Patient cross join Physician);
	SET @free_space = @limit - (SELECT COUNT(MedicationID) FROM MedicalPrescription);
	if(@free_space<@rows)
		BEGIN
			SET @rows = @free_space;
		END
	OPEN @getid
	FETCH NEXT
	FROM @getid INTO @fk_Patient,@fk_Physician;
	WHILE (@current_number<@rows AND @@FETCH_STATUS = 0)
		BEGIN
			SELECT TOP 1 @fk_Medication=MedicationID FROM Medication WHERE MedicationID%2=@current_number%2;
			BEGIN TRY
				INSERT INTO MedicalPrescription(PatientID,PhysicianID,MedicationID) VALUES (@fk_Patient,@fk_Physician,@fk_Medication);
				SET @current_number+=1;
				FETCH NEXT
				FROM @getid INTO @fk_Patient,@fk_Physician;
			END TRY
			BEGIN CATCH
				PRINT 'duplicated primary key'
				FETCH NEXT
				FROM @getid INTO @fk_Patient,@fk_Physician;
				
			END CATCH
		END
	CLOSE @getid;
	DEALLOCATE @getid;
END
GO

/*PROCEDURA PENTRU APLICAREA SELECT-ULUI PENTRU UN ANUMIT VIEW*/
GO
CREATE OR ALTER PROCEDURE usp_select_view @view_id INT
AS
BEGIN
	IF(@view_id = 1)
		BEGIN
			SELECT * FROM vw_2002StaysWithPrescribedMedicine;
		END
	ELSE
		BEGIN
			IF(@view_id = 2)
				BEGIN
					SELECT * FROM vw_BucurestiPatients;
				END
			ELSE
				BEGIN 
					SELECT * FROM vw_TotalPatientStays;
				END
		END;
END

GO

/*DELETE FROM TABLE Patient*/
GO
CREATE OR ALTER PROCEDURE usp_delete_Patient @rows int 
AS
BEGIN
	DECLARE @index INT;
	DECLARE @patient_id INT;
	SET @index = 0;
	DECLARE @getid CURSOR;
	SET @getid = CURSOR FOR 
					SELECT PatientID FROM Patient WHERE Name LIKE '%Patient%';
	OPEN @getid;
	FETCH NEXT
	FROM @getid INTO @patient_id;
	WHILE (@@FETCH_STATUS = 0 AND @index<@rows)
	BEGIN
		BEGIN TRY
			DELETE  FROM Patient WHERE PatientID = @patient_id;
			SET @index+=1;
			FETCH NEXT
			FROM @getid INTO @patient_id;
		END TRY
		BEGIN CATCH
			FETCH NEXT
			FROM @getid INTO @patient_id;	
		END CATCH	
	END
	CLOSE @getid;
	DEALLOCATE @getid;
END

/*DELETE FROM table Stay*/
GO 
CREATE OR ALTER  PROCEDURE usp_delete_Stay @rows INT
AS
BEGIN
	DELETE TOP(@rows) FROM Stay WHERE start_time LIKE '%test%';
END

/*Delete from table MedicalPrescription*/
GO
CREATE OR ALTER PROCEDURE usp_delete_MedicalPrescription @rows INT
AS
BEGIN
	DELETE TOP (@rows) FROM MedicalPrescription WHERE PatientID>20;
END




INSERT INTO Tests(Name) VALUES('delete_insert_MedicalPrescription_view_1')
,('delete_insert_Patient_view_2'),('delete_insert_Stay_view_3')
SELECT * FROM Tests
SELECT * FROM TestTables
SELECT * FROM TestViews

INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) VALUES
(14,1,1000,3),(14,2,1000,2),(14,3,1000,1),
(13,3,1000,1),(13,1,1000,2),
(15,2,500,1),(15,1,1000,2);
INSERT INTO TestViews(TestID,ViewID) VALUES(13,1),(14,2),(15,3);


INSERT INTO Views VALUES ('vw_2002StaysWithPrescribedMedicine'),('vw_BucurestiPatients'),('vw_TotalPatientStays')



/****Procedura care ruleaza testele***/
GO
CREATE OR ALTER PROCEDURE usp_testOperations @test_id INT
AS
BEGIN
DECLARE @test_name VARCHAR(200);
DECLARE @test_start_time DATETIME;
DECLARE @test_view_start DATETIME;
DECLARE @test_view_end DATETIME;
DECLARE @view_name VARCHAR(100);
DECLARE @current_TestRunID INT;
SET @test_name = (SELECT Name FROM Tests WHERE TestID = @test_id);
/*SET @test_table_id = (SELECT  Tables.TableID FROM Tests INNER JOIN Tables on Tests.Name
							LIKE '%'+Tables.Name+'%' AND Tests.TestID = @test_id);*/
SET @test_start_time = GETDATE();

INSERT INTO TestRuns(Description,StartAt) VALUES(@test_name,@test_start_time);
SET @current_TestRunID = (SELECT SCOPE_IDENTITY());

/*DELETE OPERATIONS*/
DECLARE @delete_cursor CURSOR;
DECLARE @insert_rows INT;
DECLARE @current_table_id INT;
DECLARE @current_table_name VARCHAR(150);
DECLARE @function_to_call VARCHAR(200);
DECLARE @aux_time DATETIME;
SET @delete_cursor = CURSOR FOR
							SELECT TableID,NoOfRows FROM TestTables 
							WHERE TestID = @test_id 
							ORDER BY Position ASC;
OPEN @delete_cursor
FETCH NEXT
FROM @delete_cursor INTO @current_table_id,@insert_rows;
DECLARE @first_table_id INT;
SET @first_table_id  = @current_table_id;
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @current_table_name = (SELECT Name FROM Tables WHERE TableID = @current_table_id);
		SET @function_to_call = 'usp_delete_' + @current_table_name ;
		SET @aux_time = GETDATE();
		EXECUTE @function_to_call @insert_rows;
		INSERT INTO TestRunTables(TestRunID,TableID,StartAt,EndAt) VALUES (@current_TestRunID,@current_table_id,@aux_time,@aux_time);
		FETCH NEXT
		FROM @delete_cursor INTO @current_table_id,@insert_rows;
	END
UPDATE TestRunTables SET StartAt = @test_start_time WHERE TestRunID = @current_TestRunID AND TableID = @first_table_id;
/*INSERT OPERATIONS*/
DECLARE @insert_cursor CURSOR;
SET @insert_cursor  = CURSOR FOR
							SELECT TableID,NoOfRows FROM TestTables 
							WHERE TestID = @test_id 
							ORDER BY Position DESC; 
OPEN @insert_cursor
FETCH NEXT
FROM @insert_cursor INTO @current_table_id,@insert_rows;
WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @current_table_name = (SELECT Name FROM Tables WHERE TableID = @current_table_id);
		SET @function_to_call = 'usp_insert_' + @current_table_name ;
		EXECUTE @function_to_call @insert_rows;
		SET @aux_time = GETDATE();
		UPDATE TestRunTables SET EndAt = @aux_time WHERE TestRunID = @current_TestRunID AND TableID = @current_table_id; 
		FETCH NEXT
		FROM @insert_cursor INTO @current_table_id,@insert_rows;
	END


DECLARE @view_cursor CURSOR;
DECLARE @current_view_id INT;
SET @view_cursor = CURSOR FOR
					SELECT ViewID FROM TestViews WHERE TestID = @test_id;
DECLARE @view_exec VARCHAR(300);
OPEN @view_cursor;
FETCH NEXT
FROM @view_cursor INTO @current_view_id;
DECLARE @first_view_id INT;
DECLARE  @view_test_start DATETIME;
SET @first_view_id = @current_view_id;
SET @view_test_start = @aux_time;
WHILE (@@FETCH_STATUS = 0) 
	BEGIN
		SET @view_name = (SELECT Name FROM Views WHERE ViewID = @current_view_id);
		SET @view_exec = 'SELECT * FROM ';
		SET @view_exec += @view_name;
		SET @test_view_start = GETDATE();
		EXECUTE (@view_exec);
		SET @test_view_end = GETDATE();
		INSERT INTO TestRunViews(TestRunID,ViewID,StartAt,EndAt) 
					VALUES(@current_TestRunID,@current_view_id,@test_view_start,@test_view_end);
		FETCH NEXT
		FROM @view_cursor INTO @current_view_id;
	END
UPDATE TestRunViews SET StartAt = @view_test_start WHERE TestRunID = @current_TestRunID AND ViewID = @first_view_id;
UPDATE TestRuns SET EndAt = @test_view_end WHERE TestRunID = @current_TestRunID;
END



