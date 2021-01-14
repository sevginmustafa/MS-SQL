--Problem 1. Create Database
CREATE DATABASE Minions


--Problem 2. Create Tables
CREATE TABLE Minions
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(30),
	Age TINYINT
)

CREATE TABLE Towns
(
	Id INT PRIMARY KEY,
	[Name] VARCHAR(50)
)


--Problem 3. Alter Minions Table
ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id)


--Problem 4. Insert Records in Both Tables
INSERT INTO Towns(Id, Name) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna')

INSERT INTO Minions(Id, Name, Age, TownId) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2)


--Problem 5. Truncate Table Minions
DELETE FROM Minions


--Problem 6. Drop All Tables
DROP TABLE Minions


--Problem 7. Create Table People
CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARCHAR(MAX),
	Height FLOAT(2),
	[Weight] FLOAT(2),
	Gender CHAR(1),
	Birthdate DATETIME NOT NULL,
	Biography NVARCHAR(MAX)
)

INSERT INTO People([Name], Picture, Height, [Weight], Gender, Birthdate, Biography)
VALUES
('Ivan', 'https://www.google.com/', 1.75, 67, 'm', '1/1/1996', 'From Sofia'),
('Dragan', 'https://www.google.com/', 1.84, 75, 'm', '1/1/1998', 'From Plovdiv'),
('Petkan', 'https://www.google.com/', 1.77, 70, 'm', '1/1/1999', 'From Varna'),
('Eva', 'https://www.google.com/', 1.62, 58, 'f', '1/1/1995', 'From Burgas'),
('Mila', 'https://www.google.com/', 1.66, 61, 'f', '1/1/1997', 'From Ruse')


--Problem 8. Create Table Users
CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARCHAR(MAX),
	LastLoginTime DATETIME,
	IsDeleted BIT
)

INSERT INTO Users(Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES
('Ivan', '123', 'https://www.google.com/', '1/1/1996', 1),
('Dragan', '1234', 'https://www.google.com/', '1/1/1998', 0),
('Petkan', '12345', 'https://www.google.com/', '1/1/1999', 0),
('Eva', '123456', 'https://www.google.com/', '1/1/1995', 1),
('Mila', '1234567', 'https://www.google.com/', '1/1/1997', 0)


--Problem 9. Change Primary Key
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC076E3EA81E

ALTER TABLE Users
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username)
