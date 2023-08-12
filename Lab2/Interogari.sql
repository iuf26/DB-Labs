use PrivateHospital3
go
SELECT  * FROM Medication
select * from Patient
select * from Department
select * from HeadOfDepartment
select * from Patient
Select * from Physician 
select * from Room
select * from MedicalProcedure
select * from Stay
Select * from Appointment
Select * from MedicalPrescription
Select * from Physician

/*WHERE:6
goup by:5
distinct:2
having:2
*/

/*1.Numara cati medici exista pentru fiecare
specializare in spital*/
select Specialty ,COUNT(DepartmentIsInID) as Physicians 
FROM Physician 
group by Specialty
order by Physicians desc

/*2.Costul total al procedurilor medicale per pacient */
select p.Name,SUM(mp.Cost) as TotalTaxes FROM MedicalProcedure as mp inner join Patient as p on mp.PacientID=p.PatientID
group by p.Name
select mp.PacientID,SUM(mp.Cost) as TotalTaxes FROM MedicalProcedure as mp
group by mp.PacientID
select * from Patient

/*3.Numarul total al medicamentelor distincte prescrise pacientilor*/
select count(distinct(m.MedicationID)) as Nr_PrescribedMedication from MedicalPrescription as m

/******interogari ce extrag informatii din mai multe de 2 tabele*****/

/*4. m-n relationship*/
/*Selecteaza pacientii din Bucuresti  impreuna
cu numele medicului la care au fost programati la control*/
select Physician.Name as PhysicianName,Appointment.PhysicianID,Patient.Name as PatientName,Patient.Adress as PatientAdress
 from  Physician left join ( Patient   inner join Appointment
on Patient.PatientID=Appointment.PatientID  ) on
Appointment.PhysicianID=Physician.PhysicianID where
  Patient.Adress like '%Bucuresti%'
  

/*5.m-n relationship
Numele medicilor care au prescris cel putin  un medicament impreuna cu numele brand-ului de  medicament SI numele pacientului
caruia i-a fost prescris*/
 select Physician.Name as PhysicianName,Patient.Name as PatientName,Medication.Brand as Prescribed_Medication from 
(((MedicalPrescription 
inner join Physician on MedicalPrescription.PhysicianID=Physician.PhysicianID)
	inner join Patient on  MedicalPrescription.PatientID=Patient.PatientID  )
	inner join Medication on Medication.MedicationID=MedicalPrescription.MedicationID) order by Physician.Name

/*6.Id Pacientii care au avut mai mult de 2 cazari in spital ,care trebuie sa plateasca mai
mult de 45 000 lei pentru procedurile medicale si care au domiciuliul in Brasov*/
	select PatientID
	from Stay
	group by PatientID
	having count(PatientID)>=1
	intersect
	select mp.PacientID FROM MedicalProcedure as mp
	group by mp.PacientID
	having sum(mp.Cost)>=45000
	intersect
	select p.PatientID from Patient as p
	where p.Adress like '%Brasov%'

	select * from Patient where Patient.PatientID=2;
	
/* 7.Pacientii care s-au cazat in spital in 2016 in spital impreuna cu numarul de camera si numele pacientilor*/
	select Room.RoomNumber,Stay.start_time,Patient.Name as PatientName from (
	( Room inner join Stay on Stay.RoomID=Room.RoomID ) right join Patient on Stay.PatientID=Patient.PatientID ) where Stay.start_time like '%2016%'  
  
/*8.Medicii care  conduc departamentul in care se afla impreuna  cu numele departamentului */
  Select Physician.Name as PhysicianName,Department.Name as DepartmentName
  from
  ((Department inner join HeadOfDepartment on Department.DepID=HeadOfDepartment.HofDID)inner join Physician on HeadOfDepartment.Name=Physician.Name)

/*9.Topul medicamentelor administrate pacientilor cu adresa de Bucuresti*/
select m.MedicationID,Medication.Brand,count(m.MedicationID) as Prescriptions /*distinct m.MedicationID,Medication.Name as MedicationName*/
from 
((MedicalPrescription m inner join Patient p on m.PatientID=p.PatientID )
inner join Medication on Medication.MedicationID=m.MedicationID) where p.Adress like '%Bucuresti%'
group by m.MedicationID,Medication.Brand
order by count(m.MedicationID) desc

/*10.Caut pacientul care are proceduri medicale ,dar nu s a cazat in spital*/
select p.Name,p.PatientID,p.Adress
 from Stay s right outer join  Patient p on p.PatientID=s.PatientID 
 where s.StayID is Null 
 and p.PatientID in ( select distinct m.PacientID from MedicalProcedure as m)
