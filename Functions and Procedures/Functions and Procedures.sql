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
