create database RoundTheGlobe
go
use RoundTheGlobe
go

create table Funder(
FunderID int primary key identity,
Name varchar(50),
Type varchar(50) NOT NULL,
PhoneNumber varchar(15) NOT NULL,
EMail varchar(50) NOT NULL,
CONSTRAINT chk_Type check(Type in ('Individual','Organisation')),
CONSTRAINT chk_PhoneNumber check(PhoneNumber like replicate('[0123456789]',10))
)

create table Tour(
TourID int primary key identity,
Name varchar(50),
Budget int check(Budget>=1000),
FunderID int foreign key references Funder(FunderID)
)

create table Venue(
VenueID int primary key identity(1,1),
Name varchar(50),
Capacity int check(Capacity>9),
)

create table Address(
AddressID int foreign key references Venue(VenueID),
Continent varchar(50) NOT NULL,
Country varchar(50) NOT NULL,
Region varchar(50),
Town varchar(50),
Street varchar(50),
Number int
CONSTRAINT pk_Address primary key(AddressID)
)

create table Concert(
ConcertID int primary key identity,
TourID int foreign key references Tour(TourID),
VenueID int foreign key references Venue(VenueID),
Date date
)

create table Artist(
ArtistID int primary key identity,
Name varchar(50) NOT NULL,
)

create table Song(
SongID int primary key identity,
Name varchar(50) NOT NULL,
ArtistID int foreign key references Artist(ArtistID),
Minutes int NOT NULL,
Genre varchar(50) NOT NULL,
CONSTRAINT chk_Minutes check (Minutes>0)
)

create table Play(
SongID int foreign key references Song(SongID),
ConcertID int foreign key references Concert(ConcertID),
CONSTRAINT pk_Play primary key(SongID,ConcertID)
)

create table Attendee(
AttendeeID int primary key identity,
Name varchar(50) NOT NULL
)

create table Ticket(
ConcertID int foreign key references Concert(ConcertID),
AttendeeID int foreign key references Attendee(AttendeeID),
Type varchar(50) NOT NULL,
Price int NOT NULL,
CONSTRAINT chk_Price check (Price>0),
CONSTRAINT pk_Ticket primary key (ConcertID,AttendeeID)
)