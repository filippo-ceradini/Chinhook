-- 1. How many songs are there in the playlist “Grunge”?
use Chinook;

SELECT COUNT(*) AS Grunge_Songs
FROM PlaylistTrack
where PlaylistId = (SELECT PlaylistId from Playlist where Name ='Grunge');

-- 2. Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
Select *
FROM Artist
where Name like '%Jack%' or Name like '%John%' and Name not like '%Martin%';

-- 3. For each country where some invoice has been issued, show the total invoice monetary amount,
-- but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.

SELECT BillingCountry, SUM(Total) as Total
FROM Invoice
GROUP BY BillingCountry
HAVING SUM(Total) > 100 ORDER BY SUM(Total) DESC;

-- 4. Get the phone number of the boss of those employees who have given support to clients
-- who have bought some song composed by “Miles Davis” in “MPEG Audio File” format.

SELECT Phone FROM employee WHERE EmployeeId IN
                                 (SELECT ReportsTo FROM employee WHERE EmployeeId IN
                                                                       (SELECT SupportRepId FROM customer WHERE CustomerId IN
                                                                                                                (SELECT CustomerId FROM invoice WHERE InvoiceId IN
                                                                                                                                                      (SELECT InvoiceId FROM invoiceline WHERE TrackId IN
                                                                                                                                                                                               (SELECT TrackId FROM track WHERE Composer = 'Miles Davis' AND MediaTypeId =
                                                                                                                                                                                                                                                             (SELECT MediaTypeId FROM mediatype WHERE Name = 'MPEG Audio File'))))));

-- 5. Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova”
-- genre whose title starts by the word “Samba”.
SELECT *
FROM Album where AlbumID in (
    SELECT AlbumId FROM track WHERE GenreId in (
        select GenreId from Genre where Name ='Bossa Nova') and Name Like
                                                                'Samba%');

-- 6. For each genre, show the average length of its songs in minutes (without indicating seconds).
-- Use the headers “Genre” and “Minutes”, and include only genres that have any song longer than half an hour.

SELECT  Genre.Name as Genre, ROUND(AVG(Track.Milliseconds/60000)) as Minutes
FROM Genre
         INNER JOIN Track on Genre.GenreId = Track.GenreId
where Milliseconds > 1800000
group by Genre.GenreId;

SELECT genre.Name as Genre, ROUND(AVG(track.Milliseconds/60000)) as Minutes
From Genre,Track
WHERE genre.GenreId = track.GenreId AND Milliseconds > 1800000
group by Genre.GenreId;

SELECT ROUND(AVG(Track.Milliseconds/60000)) as Minutes, Genre.Name as Genre
from Track
         INNER JOIN Genre on Track.GenreId = Genre.GenreId
where Milliseconds > 1800000
group by Genre.GenreId;

SELECT ROUND(AVG(Track.Milliseconds/60000)) as Minutes, Genre.Name as Genre
from Track, Genre
where Milliseconds > 1800000 and Genre.GenreId = Track.GenreId
group by Genre.GenreId;


-- 7. How many client companies have no state?
SELECT COUNT(Company) FROM customer WHERE State IS NULL;

-- 8. For each employee with clients in the “USA”, “Canada” and “Mexico” show the number of clients
-- from these countries s/he has given support, only when this number is higher than 6.
-- Sort the query by number of clients. Regarding the employee, show his/her first name and surname separated by a space.
-- Use “Employee” and “Clients” as headers.

SELECT employee.FirstName, employee.LastName, customer.Country, COUNT(*) FROM employee,customer
WHERE EmployeeId = customer.SupportRepId AND customer.Country = 'USA' OR 'Canada' OR 'Mexico' group by employee.FirstName having COUNT(Customer.Country) > 3;

SELECT Employee.FirstName, Employee.Lastname, COUNT(Customer.Country)
From Employee
         INNER JOIN Customer on Employee.EmployeeId = Customer.SupportRepId
where Customer.Country = 'USA' or 'Canada' or 'Mexico'
group by Employee.FirstName
having COUNT(Customer.Country) > 3;


-- 9. For each client from the “USA”, show his/her surname and name (concatenated and separated by a comma) and their fax number.
-- If they do not have a fax number, show the text “S/he has no fax”. Sort by surname and first name.


SELECT Customer.Firstname, Customer.Lastname, if(Customer.Fax is not null, Fax, 'She/he has no Fax') as Fax-- , Country
From Customer where Country = 'USA'
order by LastName,FirstName;




-- 10. For each employee, show his/her first name, last name, and their age at the time they were hired.

SELECT FirstName, LastName, DATE_FORMAT(from_days(datediff(HireDate,BirthDate)),'%y' ) as StartAge
from Employee;