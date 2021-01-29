--1. Employee Address
SELECT TOP(5) E.EmployeeID, E.JobTitle, E.AddressID, A.AddressText FROM Employees E
JOIN Addresses A ON E.AddressID = A.AddressID
ORDER BY E.AddressID


--2. Addresses with Towns
SELECT TOP(50) E.FirstName, E.LastName, T.Name AS Town, A.AddressText FROM Employees E
JOIN Addresses A ON A.AddressID = E.AddressID
JOIN Towns T ON T.TownID = A.TownID
ORDER BY E.FirstName, E.LastName


--3. Sales Employee
SELECT E.EmployeeID, E.FirstName, E.LastName, D.Name AS DepartmentName FROM Employees E
JOIN Departments D ON E.DepartmentID = D.DepartmentID
WHERE D.Name = 'Sales'
ORDER BY E.EmployeeID


--4. Employee Departments
SELECT TOP(5) E.EmployeeID, E.FirstName, E.Salary, D.Name AS DepartmentName FROM Employees E
JOIN Departments D ON D.DepartmentID = E.DepartmentID
WHERE E.Salary > 15000
ORDER BY D.DepartmentID


--5. Employees Without Project
SELECT TOP(3) E.EmployeeID, E.FirstName FROM Employees E
LEFT JOIN EmployeesProjects EP ON EP.EmployeeID = E.EmployeeID
LEFT JOIN Projects P ON P.ProjectID = EP.ProjectID
WHERE P.ProjectID IS NULL
ORDER BY E.EmployeeID


--6. Employees Hired After
SELECT E.FirstName, E.LastName, E.HireDate, D.Name AS DeptName FROM Employees E
JOIN Departments D ON D.DepartmentID = E.DepartmentID
WHERE E.HireDate > '1999' AND D.Name IN('Sales', 'Finance')
ORDER BY E.HireDate


--7. Employees with Project
SELECT TOP(5) E.EmployeeID, E.FirstName, P.Name AS ProjectName FROM Employees E
JOIN EmployeesProjects EP ON EP.EmployeeID = E.EmployeeID
JOIN Projects P ON P.ProjectID = EP.ProjectID
WHERE P.StartDate > '2002-08-13' AND P.EndDate IS NULL
ORDER BY E.EmployeeID


--8. Employee 24
SELECT E.EmployeeID, E.FirstName, 
CASE 
	WHEN P.StartDate = '2005' OR P.StartDate > '2005' THEN NULL
	ELSE P.Name
END AS ProjectName
FROM Employees E
JOIN EmployeesProjects EP ON EP.EmployeeID = E.EmployeeID
JOIN Projects P ON P.ProjectID = EP.ProjectID
WHERE E.EmployeeID = 24


--9. Employee Manager
SELECT E.EmployeeID, E.FirstName, E.ManagerID, M.FirstName AS ManagerName FROM Employees E
JOIN Employees M ON M.EmployeeID = E.ManagerID
WHERE E.ManagerID IN(3, 7) 
ORDER BY E.EmployeeID


--10. Employee Summary
SELECT TOP(50) 
	E.EmployeeID, 
	E.FirstName + ' ' + E.LastName AS EmployeeName, 
	M.FirstName + ' ' + M.LastName AS ManagerName, 
	D.Name AS DepartmentName 
FROM Employees E
JOIN Employees M ON E.ManagerID = M.EmployeeID
JOIN Departments D ON D.DepartmentID = E.DepartmentID
ORDER BY E.EmployeeID


--11. Min Average Salary
SELECT TOP(1)
	(SELECT AVG(Salary) FROM Employees WHERE DepartmentID = D.DepartmentID) AS MinAverageSalary
FROM Departments D
ORDER BY MinAverageSalary


--12. Highest Peaks in Bulgaria
SELECT MC.CountryCode, M.MountainRange, P.PeakName, P.Elevation FROM Mountains M
JOIN MountainsCountries MC ON MC.MountainId = M.Id
JOIN Peaks P ON P.MountainId = M.Id
WHERE MC.CountryCode = 'BG' AND P.Elevation > 2835
ORDER BY P.Elevation DESC


--13. Count Mountain Ranges
SELECT C.CountryCode, (SELECT COUNT (*) FROM MountainsCountries WHERE CountryCode = C.CountryCode) AS MountainRanges
FROM Countries C
WHERE C.CountryCode IN('US', 'RU', 'BG')


--14. Countries with Rivers
SELECT TOP(5) C.CountryName, R.RiverName FROM Countries C
LEFT JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
LEFT JOIN Rivers R ON R.Id = CR.RiverId
WHERE C.ContinentCode = 'AF'
ORDER BY C.CountryName


--15. *Continents and Currencies
SELECT ContinentCode, CurrencyCode, CurrencyUsage FROM(
SELECT 
	ContinentCode, 
	CurrencyCode, 
	COUNT(CurrencyCode) AS CurrencyUsage,
	DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
FROM Countries
GROUP BY ContinentCode, CurrencyCode) AS T
WHERE Ranked = 1 AND CurrencyUsage >1
ORDER BY ContinentCode 


--16. Countries Without Any Mountains
SELECT COUNT(*) AS Count
FROM Countries C 
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
WHERE MC.MountainId IS NULL


--17. Highest Peak and Longest River by Country
SELECT TOP(5) CountryName, HighestPeakElevation, LongestRiverLength FROM
(SELECT 
	C.CountryName, 
	P.Elevation AS HighestPeakElevation, 
	R.Length AS LongestRiverLengtH,
	DENSE_RANK () OVER(PARTITION BY C.CountryName ORDER BY P.Elevation DESC, R.Length DESC, C.CountryName) AS Ranked
FROM Countries C
JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
JOIN Peaks P ON P.MountainId = MC.MountainId
JOIN CountriesRivers CR ON CR.CountryCode = C.CountryCode
JOIN Rivers R ON R.Id = CR.RiverId
GROUP BY C.CountryName, P.Elevation, R.Length) AS T
WHERE Ranked = 1
ORDER BY T.HighestPeakElevation DESC, T.LongestRiverLengtH DESC, T.CountryName


--18. Highest Peak Name and Elevation by Country
SELECT TOP(5) Country, [Highest Peak Name], [Highest Peak Elevation], Mountain FROM
(SELECT 
	C.CountryName AS Country, 
	CASE 
	WHEN P.PeakName IS NULL THEN '(no highest peak)'
	ELSE P.PeakName
	END AS [Highest Peak Name], 
	CASE 
	WHEN P.PeakName IS NULL THEN 0
	ELSE P.Elevation
	END AS [Highest Peak Elevation], 
	CASE 
	WHEN P.PeakName IS NULL THEN '(no mountain)'
	ELSE M.MountainRange
	END AS Mountain,
	DENSE_RANK() OVER(PARTITION BY C.CountryName ORDER BY P.Elevation DESC) AS Ranked
FROM Countries C
LEFT JOIN MountainsCountries MC ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains M ON M.Id = MC.MountainId
LEFT JOIN Peaks P ON P.MountainId = M.Id) AS T
WHERE Ranked = 1
ORDER BY T.Country, T.[Highest Peak Name]