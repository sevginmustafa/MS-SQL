--1. Create Table Logs
CREATE TABLE Logs
(
	LogId INT IDENTITY PRIMARY KEY,
	AccountId INT,
	OldSum MONEY,
	NewSum MONEY
)

CREATE TRIGGER tr_OnAccountChangeAddLogRecord
ON Accounts FOR UPDATE
AS 
	INSERT Logs (AccountId, OldSum, NewSum)
	SELECT I.AccountHolderId, D.Balance, I.Balance FROM inserted I
	JOIN deleted D ON D.Id = I.Id


--2. Create Table Emails
CREATE TABLE NotificationEmails
(	
	Id INT IDENTITY PRIMARY KEY,
	Recipient INT, 
	Subject NVARCHAR(MAX), 
	Body NVARCHAR(MAX)
)

CREATE TRIGGER tr_OnAccountInsertAddLogEmail
ON Logs FOR INSERT
AS
	INSERT NotificationEmails (Recipient, Subject, Body)
	SELECT AccountId,
		   'Balance change for account: ' + CAST(AccountId AS VARCHAR(10)), 
		   'On ' + CONVERT(NVARCHAR, GETDATE(), 103) + ' your balance was changed from ' + CAST(OldSum AS VARCHAR(20)) + ' to ' + CAST(NewSum AS VARCHAR(20)) + '.' 
	FROM Logs


--3. Deposit Money
CREATE PROC usp_DepositMoney (@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN TRANSACTION	
DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountId) 
IF(@account IS NULL)
BEGIN
	ROLLBACK;
	THROW 50001, 'Invalid @AccountId', 1
	RETURN
END
IF(@MoneyAmount < 0)
BEGIN
	ROLLBACK;
	THROW 50002, '@MoneyAmount cannot be negative', 1
	RETURN
END
UPDATE Accounts SET Balance += @MoneyAmount
WHERE Id = @AccountId
COMMIT


--4. Withdraw Money
CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY)
AS
BEGIN TRANSACTION
DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @AccountId)
IF(@account IS NULL)
BEGIN
	ROLLBACK;
	THROW 50001, 'Invalid @AccountId', 1
	RETURN
END
IF(@MoneyAmount < 0)
BEGIN
	ROLLBACK;
	THROW 50002, '@MoneyAmount cannot be negative', 1
	RETURN
END
UPDATE Accounts SET Balance -= @MoneyAmount
WHERE Id = @AccountId
COMMIT


--5. Money Transfer
CREATE PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount MONEY)
AS
BEGIN TRANSACTION
DECLARE @sender INT = (SELECT Id FROM Accounts WHERE Id = @SenderId)
DECLARE @receiver INT = (SELECT Id FROM Accounts WHERE Id = @SenderId)
IF(@sender IS NULL OR @receiver IS NULL)
BEGIN
	ROLLBACK;
	THROW 50001, 'Invalid @AccountId', 1
	RETURN
END
IF(@Amount < 0)
BEGIN
	ROLLBACK;
	THROW 50002, '@MoneyAmount cannot be negative', 1
	RETURN
END
UPDATE Accounts SET Balance -= @Amount
WHERE Id = @sender
UPDATE Accounts SET Balance += @Amount
WHERE Id = @ReceiverId
COMMIT


--6. Trigger


--7. *Massive Shopping
DECLARE @priceItemsFromLevel11To12 MONEY = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12)
DECLARE @StamatCash MONEY = (SELECT Cash FROM UsersGames WHERE Id = 110)
IF(@StamatCash >= @priceItemsFromLevel11To12)
BEGIN
	BEGIN TRANSACTION
		UPDATE UsersGames SET Cash -= @priceItemsFromLevel11To12
		WHERE Id = 110
		INSERT INTO UserGameItems(ItemId, UserGameId)
		SELECT Id, 110 FROM Items WHERE MinLevel BETWEEN 11 AND 12
	COMMIT
END

DECLARE @priceItemsFromLevel19To21 MONEY = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)
DECLARE @StamatCashAfter MONEY = (SELECT Cash FROM UsersGames WHERE Id = 110)
IF(@StamatCashAfter >= @priceItemsFromLevel19To21)
BEGIN 
	BEGIN TRANSACTION
		UPDATE UsersGames SET Cash -= @priceItemsFromLevel19To21
		WHERE Id = 110
		INSERT INTO UserGameItems(ItemId, UserGameId)
		SELECT Id, 110 FROM Items WHERE MinLevel BETWEEN 19 AND 21
	COMMIT
END

SELECT I.Name FROM UserGameItems UGI
JOIN Items I ON I.Id = UGI.ItemId
WHERE UGI.UserGameId = 110
ORDER BY I.Name


--8. Employees with Three Projects
CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
DECLARE @projectsCount INT = (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId)
DECLARE @employee INT = (SELECT EmployeeID FROM Employees WHERE EmployeeID = @emloyeeId)
DECLARE @project INT = (SELECT ProjectID FROM Projects WHERE ProjectID = @projectID)
IF(@employee IS NULL OR @project IS NULL)
BEGIN
	ROLLBACK;
	THROW 50001, 'Invalid @emloyeeId OR @projectID', 1
	RETURN
END
IF(@projectsCount >= 3)
BEGIN
	ROLLBACK;
	THROW 50003, 'The employee has too many projects!', 1
	RETURN
END
IF(@projectID IN(SELECT ProjectID FROM EmployeesProjects WHERE EmployeeID = @emloyeeId))
BEGIN
	ROLLBACK;
	THROW 50004, 'The employee is already assigned for this project', 1
	RETURN
END
INSERT INTO EmployeesProjects (EmployeeID, ProjectID) VALUES
(@emloyeeId, @projectID)
COMMIT


--9. Delete Employees
CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY, 
	FirstName NVARCHAR(50), 
	LastName NVARCHAR(50), 
	MiddleName NVARCHAR(50), 
	JobTitle NVARCHAR(150),
	DepartmentId INT,
	Salary MONEY
)

CREATE TRIGGER tr_FiredEmployees
ON Employees FOR DELETE
AS
	INSERT Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
					   SELECT FirstName, LastName, MiddleName, JobTitle, DepartmentID, Salary 
					   FROM deleted