Create database PrivateHospital3
go
use PrivateHospital3
go


CREATE TABLE Patient
(PatientID INT PRIMARY KEY IDENTITY,
Name varchar(100) NOT NULL,
Phone varchar(12) NOT NULL,
Adress varchar(100) NOT NULL )

CREATE TABLE Department
(
	DepID INT PRIMARY KEY,
	Name varchar(100)
	
)

CREATE TABLE Physician
(PhysicianID INT PRIMARY KEY IDENTITY,
DepartmentIsInID INT FOREIGN KEY REFERENCES Department(DepID),
Name varchar(100) NOT NULL,
Specialty varchar(100) NOT NULL,
Status varchar(50) default 'Available')


CREATE TABLE Medication
(
MedicationID INT PRIMARY KEY,
Name varchar(100),
Brand varchar(100)

)

CREATE TABLE MedicalPrescription
(PatientID INT FOREIGN KEY REFERENCES Patient(PatientID),
PhysicianID INT FOREIGN KEY REFERENCES Physician(PhysicianID),
MedicationID INT FOREIGN KEY references Medication(MedicationID),
CONSTRAINT pk_MedicalPrescription PRIMARY KEY(PatientID,PhysicianID)
)

CREATE TABLE Room
(RoomID INT PRIMARY KEY,
RoomNumber int CHECK (RoomNumber>=100 and RoomNumber<=1000),
Beds int CHECK(Beds>0 and Beds<11)
)

CREATE TABLE Stay
(StayID INT PRIMARY KEY IDENTITY,
PatientID INT FOREIGN KEY REFERENCES Patient(PatientID),
RoomID INT FOREIGN KEY REFERENCES Room(RoomID),
start_time varchar(50),
end_time varchar(50)
)



CREATE TABLE HeadOfDepartment
(
	HofDID INT FOREIGN KEY REFERENCES Department(DepID),
	Name varchar(300),
	CONSTRAINT pk_HeadOfDepartment PRIMARY KEY(HofDID)

)

CREATE TABLE MedicalProcedure
(
	MedProcedureID INT PRIMARY KEY,
	Cost int,
	PacientID INT FOREIGN KEY REFERENCES Patient(PatientID)

)
CREATE TABLE Appointment
(
	

	PatientID int foreign key references Patient(PatientID),
	PhysicianID int foreign key references Physician(PhysicianID),
	CONSTRAINT pk_Appointment PRIMARY KEY (PatientID,PhysicianID)
)




