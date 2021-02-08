--1. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName, LastName FROM Employees
	WHERE Salary > 35000


--2. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@Number DECIMAL(18,4))
AS
	SELECT FirstName, LastName FROM Employees
	WHERE Salary >= @Number


--3. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith(@StartsWith NVARCHAR(10))
AS
	SELECT Name FROM Towns
	WHERE LEFT(Name, LEN(@StartsWith)) = @StartsWith


--4. Employees from Town
CREATE PROC usp_GetEmployeesFromTown(@TownName NVARCHAR(30))
AS	
	SELECT FirstName, LastName FROM Employees E
	JOIN Addresses A ON A.AddressID = E.AddressID
	JOIN Towns T ON T.TownID = A.TownID
	WHERE T.Name = @TownName


--5. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel NVARCHAR(10)

	IF(@salary BETWEEN 0 AND 29999)
		SET @SalaryLevel = 'Low'
	ELSE IF(@salary <= 50000)
		SET @SalaryLevel = 'Average'
	ELSE IF(@salary > 50000)
		SET @SalaryLevel = 'High'
	ELSE
		SET @SalaryLevel = NULL
	
	RETURN @SalaryLevel
END	


--6. Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel NVARCHAR(10))
AS
	SELECT FirstName, LastName FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel


--7. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX)) 
RETURNS BIT
AS
BEGIN
	DECLARE @currentIndex INT = 1;

	WHILE(@currentIndex <= LEN(@word))
	BEGIN

		DECLARE @currentLetter VARCHAR(1) = SUBSTRING(@word, @currentIndex, 1);

		IF(CHARINDEX(@currentLetter, @setOfLetters)) = 0
		BEGIN
			RETURN 0;
		END

		SET @currentIndex += 1;
	END

RETURN 1;
END


--8. * Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment(@DepartmentId INT)
AS
	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT NULL
	
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN(SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentId)
	
	UPDATE Employees
	SET ManagerID = NULL
	WHERE EmployeeID IN(SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentId)
	
	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN(SELECT EmployeeID FROM Employees WHERE DepartmentID = @DepartmentId)
	
	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @DepartmentId
	
	DELETE FROM Employees
	WHERE DepartmentID = @DepartmentId
	
	DELETE FROM Departments
	WHERE DepartmentID = @DepartmentId
	
	SELECT COUNT(*) FROM Employees WHERE DepartmentID = @DepartmentId


--9. Find Full Name
CREATE PROC usp_GetHoldersFullName
AS
	SELECT FirstName + ' ' + LastName AS [Full Name] FROM AccountHolders


--10. People with Balance Higher Than
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@inputAmount DECIMAL(10,2))
AS
	SELECT AH.FirstName, AH.LastName FROM AccountHolders AH
	JOIN Accounts A ON A.AccountHolderId = AH.Id
	GROUP BY AH.FirstName, AH.LastName
	HAVING SUM(A.Balance) > @inputAmount
	ORDER BY AH.FirstName, AH.LastName


--11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(20,2), @yearlyInterestRate DECIMAL(20,10), @numberOfYears INT)
RETURNS DECIMAL(20,4)
AS
BEGIN
	RETURN ((POWER(1 + @yearlyInterestRate, @numberOfYears)) - 1) * @sum + @sum
END


--12. Calculating Interest
CREATE PROC usp_CalculateFutureValueForAccount(@accountID INT, @yearlyInterestRate DECIMAL(20,10))
AS
	SELECT 
		AH.Id AS [Account Id],
		AH.FirstName AS [First Name], 
		AH.LastName AS [Last Name], 
		A.Balance AS [Current Balance],
		dbo.ufn_CalculateFutureValue(A.Balance, @yearlyInterestRate, 5) AS [Balance in 5 years] 
	FROM AccountHolders AH
	JOIN Accounts A ON A.AccountHolderId = AH.Id
	WHERE A.Id = @accountID


--13. *Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@GameName NVARCHAR(100))
RETURNS TABLE
AS
RETURN SELECT SUM(T.Cash) AS SumCash 
	FROM (SELECT 
			G.Id, 
			UG.Cash, 
			G.Name,
			ROW_NUMBER () OVER (ORDER BY UG.Cash DESC) AS RowNumber
		FROM UsersGames UG
		JOIN GAMES G ON G.Id = UG.GameId
		WHERE G.Name = @GameName) AS T
	WHERE RowNumber % 2 = 1