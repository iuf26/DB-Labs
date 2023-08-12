use RoundTheGlobe
go

---Access everything---
select * from Artist;
select * from Song;
select * from Funder;
select * from Tour;
select * from Venue;
select * from Address;
select * from Concert;
select * from Play;
select * from Attendee;
select * from Ticket;

---1---
---Find the 3 highest grossing tours---
select top 3 aux.TourID,aux.Name,ISNULL(sum(t.Price),0) Grossing from
	---find each tour's concerts---
	(select t.TourID,t.Name,c.ConcertID from
	Tour t left join Concert c on c.TourID=t.TourID) aux
left join Ticket t on t.ConcertID=aux.ConcertID
group by aux.TourID,aux.Name
order by ISNULL(sum(t.Price),0) desc,aux.TourID

---2---
---Find each concert's approximate duration---
select c.ConcertID,c.Date,ISNULL(sum(s.Minutes),0) Duration from
Concert c left join Song s on exists(select * from Play p where p.ConcertID=c.ConcertID AND p.SongID=s.SongID)
group by c.ConcertID,c.Date
order by c.ConcertID

---3---
---Find for each attendee the artists whose concerts they attended - if the attendee doesn't appear on the list, he didn't see any artist ---
select aux.AttendeeID,aux.Name,a.ArtistID,a.Name from
	---Find the songs attended by each attendee, so we can then find the artists - we care only about the song's artist---
	(select distinct aux.AttendeeID,aux.Name,s.ArtistID from
		---Find each attendee's attended concerts---
		(select a.AttendeeID,a.Name,c.ConcertID from
		Attendee a inner join Concert c on exists(select * from Ticket t where t.AttendeeID=a.AttendeeID AND t.ConcertID=c.ConcertID)) aux
	inner join Song s on exists(select * from Play p where p.SongID=s.SongID AND p.ConcertID=aux.ConcertID))aux
inner join Artist a on a.ArtistID=aux.ArtistID
order by aux.AttendeeID,a.ArtistID

---4---
---Find the countries visited by each artist - if the artist doesn't appear on the list, he hasn't had any concerts yet---
select aux.ArtistID,aux.Name,a.Country from
	---Find the concerts at which each artist played - take the VenueID
	(select distinct aux.ArtistID,aux.Name,c.VenueID from
		---Find the songs sung by each artist---
		(select a.ArtistID,a.Name,s.SongID from
		Artist a inner join Song s on s.ArtistID=a.ArtistID) aux
	inner join Concert c on exists(select * from Play p where p.ConcertID=c.ConcertID AND p.SongID=aux.SongID))aux
inner join Address a on a.AddressID=aux.VenueID
order by aux.ArtistID,a.Country

---5---
---Find each country's venues ordered by popularity---
---Find how many concerts were held at each venue
select aux.Country,aux.VenueID,aux.Name,aux.Capacity,count(c.ConcertID)NumberOfHostings from
	---Find each country's venues---
	(select a.Country,v.VenueID,v.Name,v.Capacity from
	Venue v inner join Address a on v.VenueID=a.AddressID) aux
left join Concert c on c.VenueID=aux.VenueID
group by aux.Country,aux.VenueID,aux.Name,aux.Capacity
order by aux.Country,NumberOfHostings desc, aux.Capacity desc,aux.VenueID

---6---
---Find each artist's preffered music genres - that is genres with more than 3 songs - if the artist doesn't appear, he doesn't have any preffered genres---
select a.ArtistID,a.Name,s.Genre,count(*)NumberOfSongs from
Artist a inner join Song s on s.ArtistID=a.ArtistID
group by a.ArtistID,a.Name,s.Genre
having count(*)>3
order by a.ArtistID,count(*),s.Genre

---7---
---Find each funder's average investition on a tour---
select f.FunderID,f.Name,ISNULL(avg(t.Budget),0)AverageInvestition from
Funder f left join Tour t on f.FunderID=t.FunderID
group by f.FunderID,f.Name
order by f.FunderID

---8---
---Find all the WorldWide Tour - by definition, 3 distinct continents shall suffice---
select aux.TourID,aux.Name from
	---find the continents that were visited during those tours---
	(select distinct aux.TourID,aux.Name,a.Continent from
		---Find all the concerts of the tour---
		(select t.TourID,t.Name,c.VenueID from
		Tour t inner join Concert c on c.TourID=t.TourID)aux
	inner join Address a on a.AddressID=aux.VenueID)aux
group by aux.TourID,aux.Name
having count(aux.Continent)>=3
order by aux.TourID,aux.Name

---9---
---Find all the concerts whose venues have imprecise localization - by definition, with any NULLS (unknown details) ---
select c.ConcertID,c.Date,v.VenueID,v.Name from
Concert c inner join Venue v on c.VenueID=v.VenueID
where exists(select * from Address a where a.AddressID=c.VenueID AND (a.Region IS NULL or a.Town IS NULL or a.Street IS NULL or a.Number IS NULL))
order by c.ConcertID

---10---
---Find the attendees who haven't attended any concerts yet---
select a.AttendeeID,a.Name from
Attendee a
where not exists(select * from Ticket t where t.AttendeeID=a.AttendeeID)
order by a.AttendeeID
---or...---
select a.AttendeeID,a.Name from
Attendee a left join Ticket t on a.AttendeeID=t.AttendeeID
where t.AttendeeID IS NULL
order by a.AttendeeID