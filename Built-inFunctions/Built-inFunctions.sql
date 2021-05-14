--Problem 1. Find Names of All Employees by First Name
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'SA%'

--Problem 2. Find Names of All employees by Last Name
SELECT FirstName, LastName FROM Employees
WHERE LastName LIKE '%ei%'


--Problem 3. Find First Names of All Employees
SELECT FirstName FROM Employees
WHERE DepartmentID IN(3,10) AND YEAR(HireDate) BETWEEN 1995 AND 2005


--Problem 4. Find All Employees Except Engineers
SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'


--Problem 5. Find Towns with Name Length
SELECT Name FROM Towns
WHERE LEN(Name) IN(5,6) 
ORDER BY Name


--Problem 6. Find Towns Starting With
SELECT * FROM Towns
WHERE Name LIKE '[MKBE]%'
ORDER BY Name


--Problem 7. Find Towns Not Starting With
SELECT * FROM Towns
WHERE Name LIKE '[^RBD]%'
ORDER BY Name


--08. Create View Employees Hired After
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE YEAR(HireDate) > 2000


--Problem 9. Length of Last Name
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5


--Problem 10. Rank Employees by Salary
SELECT 
EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC


--Problem 11. Find All Employees with Rank 2 *
SELECT * FROM 
(SELECT 
EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000) AS T
WHERE Rank=2
ORDER BY Salary DESC


--Problem 12. Countries Holding ‘A’ 3 or More Times
SELECT CountryName, IsoCode FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'A','')) >= 3
ORDER BY IsoCode


--Problem 13. Mix of Peak and River Names
SELECT Peaks.PeakName,
       Rivers.RiverName,
	   LOWER(CONCAT(PeakName, RIGHT(RiverName, LEN(RiverName)-1))) AS Mix
FROM Peaks, Rivers
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix


--Problem 14. Games from 2011 and 2012 year
SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS Start FROM Games
WHERE YEAR(Start) IN(2011, 2012) 
ORDER BY Start, Name


--Problem 15. User Email Providers
SELECT Username, RIGHT(Email,LEN(Email) - (CHARINDEX('@', Email))) AS [Email Provider] FROM Users
ORDER BY [Email Provider], Username


--Problem 16. Get Users with IPAdress Like Pattern
SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username


--Problem 17. Show All Games with Duration and Part of the Day
SELECT Name, 
CASE 
WHEN DATEPART(HOUR, Start) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR, Start) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS [Part of the Day],
CASE
WHEN Duration BETWEEN 0 AND 3 THEN 'Extra Short'
WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
WHEN Duration > 6 THEN 'Long'
ELSE 'Extra Long'
END AS [Duration]
FROM Games
ORDER BY Name, Duration, [Part of the Day]


--Problem 18. Orders Table
SELECT 
	ProductName, 
	OrderDate, 
	DATEADD(DAY, 3, OrderDate) AS [Pay Due], 
	DATEADD(MONTH, 1, OrderDate) AS [Deliver Due] 
FROM Orders


--Problem 19. People Table
CREATE TABLE People
(
	Id INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	Birthdate DATETIME NOT NULL
)

INSERT INTO People(Name, Birthdate) VALUES
('Victor', '2000/12/07'),
('Steven', '1992/09/10'),
('Stephen', '1910/09/19'),
('John', '2010/01/06')

SELECT 
	Name, 
	DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
	DATEDIFF(MONTH, Birthdate,GETDATE()) AS [Age in Months],
	DATEDIFF(MINUTE, Birthdate,GETDATE()) AS [Age in Minutes] 
FROM People