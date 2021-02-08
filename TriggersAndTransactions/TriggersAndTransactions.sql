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
