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