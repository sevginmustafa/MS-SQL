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


--Problem 10. Add Check Constraint
ALTER TABLE Users
ADD CONSTRAINT CH_PasswordIsAtLeast5Symbols CHECK (LEN(Password) >= 5)


--Problem 11. Set Default Value of a Field
ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime


--Problem 12. Set Unique Field
ALTER TABLE Users
DROP CONSTRAINT PK_IdUsername

ALTER TABLE Users
ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT UC_Username UNIQUE (Username)

ALTER TABLE Users
ADD CONSTRAINT CH_UsernameIsAtLeast3Symbols CHECK (LEN(Username) >= 3)


--Problem 13. Movies Database
CREATE DATABASE Movies

CREATE TABLE Directors
(
	Id INT PRIMARY KEY,
	DirectorName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Directors(Id, DirectorName, Notes) VALUES
(1, 'Ivan', NULL),
(2, 'Gosho', 'some note'),
(3, 'Pesho', NULL),
(4, 'Stamat', 'note'),
(5, 'Eva', NULL)

CREATE TABLE Genres
(
	Id INT PRIMARY KEY,
	GenreName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Genres(Id, GenreName, Notes) VALUES
(1, 'Horror', NULL),
(2, 'Action', 'some note'),
(3, 'Thriller', 'no note!!!'),
(4, 'Drama', 'note'),
(5, 'Comedy', NULL)

CREATE TABLE Categories
(
	Id INT PRIMARY KEY,
	CategoryName VARCHAR(50) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Categories(Id, CategoryName, Notes) VALUES
(1, 'Anime', 'pls enter some note!!!'),
(2, 'Funny', 'some note'),
(3, 'Sad', 'no note!!!'),
(4, 'Childish', 'note'),
(5, 'No category', NULL)

CREATE TABLE Movies
(
	Id INT PRIMARY KEY,
	Title VARCHAR(50) NOT NULL,
	DirectorId INT NOT NULL,
	CopyrightYear INT NOT NULL,
	[Length] INT NOT NULL,
	GenreId INT NOT NULL,
	CategoryId INT NOT NULL,
	Rating FLOAT(2) NOT NULL, 
	Notes VARCHAR(MAX)
)

INSERT INTO Movies(Id, Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes) VALUES
(1, 'Get Out', 1, 2017, 120, 1, 2, 7.6, 'pls enter some note!!!'),
(2, 'YU-GI-OH', 1, 2016, 130, 2, 2, 8.1, NULL),
(3, 'Avengers', 3, 2012, 150, 2, 1, 9.6, 'pls enter some note!!!'),
(4, 'The Maze Runner', 2, 2013, 160, 2, 4, 9.0, 'pls enter some note!!!'),
(5, 'Scary Movie', 5, 2001, 120, 4, 5, 6.6, 'pls enter some note!!!')


--Problem 14. Car Rental Database
CREATE DATABASE CarRental

CREATE TABLE Categories
(
	Id INT PRIMARY KEY NOT NULL,
	CategoryName VARCHAR(30) NOT NULL,
	DailyRate FLOAT(2) NOT NULL,
	WeeklyRate FLOAT(2) NOT NULL,
	MonthlyRate FLOAT(2) NOT NULL,
	WeekendRate FLOAT(2) NOT NULL,
)

INSERT INTO Categories(Id, CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) VALUES
(1, 'First', 5.5, 6, 5.4, 6),
(2, 'Second', 5.2, 5.6, 5.4, 6),
(3, 'Third', 5.8, 6.1, 5.4, 6)

CREATE TABLE Cars
(
	Id INT PRIMARY KEY NOT NULL,
	PlateNumber VARCHAR(20) NOT NULL,
	Manufacturer VARCHAR(20) NOT NULL,
	Model VARCHAR(20) NOT NULL,
	CarYear INT NOT NULL,
	CategoryId INT NOT NULL,
	Doors INT NOT NULL,
	Picture VARCHAR(MAX),
	Condition VARCHAR(80),
	Available VARCHAR(10)
)

INSERT INTO Cars (Id, PlateNumber, Manufacturer, Model, CarYear, CategoryId, Doors, Picture, Condition, Available) VALUES
(1, 'First', 'BMW', '320D', 2003, 1, 5, 'no picture', 'good', 'yes'),
(2, 'Second', 'Audi', 'A4', 1998, 2, 5, 'no picture', 'bad', 'yes'),
(3, 'Third', 'Trabant', '601', 1966, 1, 5, NULL, 'morgue', 'no')

CREATE TABLE Employees
(
	Id INT PRIMARY KEY NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Title VARCHAR(20) NOT NULL,
	Notes VARCHAR(MAX) 
)

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'Pesho', 'Peshev', 'Lazy', NULL),
(2, 'Gosho', 'Goshev', 'Hardworking', 'no note'),
(3, 'Stamat', 'Stamatov', 'Jobless', NULL)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY NOT NULL,
	DriverLicenceNumber INT NOT NULL,
	FullName VARCHAR(60) NOT NULL,
	[Address] VARCHAR(200),
	City VARCHAR(20) NOT NULL,
	ZIPCode INT NOT NULL,
	Notes VARCHAR(MAX) 
)

INSERT INTO Customers (Id, DriverLicenceNumber, FullName, [Address], City, ZIPCode, Notes) VALUES
(1, 5, 'Pesho Peshev', 'no address', 'Sofia', 1000, NULL),
(2, 6, 'Gosho Peshev', NULL, 'Varna', 9000, NULL),
(3, 4, 'Pesho Goshev', 'Bulgaria', 'Sofia', 1000, NULL)

CREATE TABLE RentalOrders
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT NOT NULL,
	CustomerId INT  NOT NULL,
	CarId INT NOT NULL,
	TankLevel INT NOT NULL,
	KilometrageStart INT NOT NULL,
	KilometrageEnd INT NOT NULL,
	TotalKilometrage INT NOT NULL,
	StartDate DATETIME,
	EndDate DATETIME,
	TotalDays INT NOT NULL,
	RateApplied FLOAT(2),
	TaxRate FLOAT(2),
	OrderStatus VARCHAR(10) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, KilometrageStart, KilometrageEnd,
TotalKilometrage, StartDate, EndDate, TotalDays, RateApplied, TaxRate, OrderStatus, Notes) VALUES
(1, 1, 1, 1, 100, 100, 200, 100, '1/1/2000', '2/2/2000', 365, 4.6, 2.6, 'no idea', NULL ),
(2, 1, 1, 1, 100, 100, 200, 100, '1/1/2000', '2/2/2000', 365, NULL, 2.6, 'no idea', NULL ),
(3, 1, 1, 1, 100, 100, 200, 100, '1/1/2000', '2/2/2000', 365, 4.6, NULL, 'no idea', NULL )


--Problem 15. Hotel Database
CREATE DATABASE Hotel

CREATE TABLE Employees
(
	Id INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Title VARCHAR(30) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes) VALUES
(1, 'Ivan', 'Ivanov', 'Accountant', NULL),
(2, 'Pesho', 'Ivanov', 'Jobless', NULL),
(3, 'Ivan', 'Peshev', 'Cleaner', NULL)

CREATE TABLE Customers
(
	AccountNumber INT PRIMARY KEY,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(10) NOT NULL,
	EmergencyName VARCHAR(20) NOT NULL,
	EmergencyNumber VARCHAR(10) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes) VALUES
(1, 'Ivan', 'Ivanov', '0885136951', 'no idea', '0885136951', NULL),
(2, 'Ivan', 'Ivanov', '0895136951', 'no idea', '0885136951', NULL),
(3, 'Ivan', 'Ivanov', '0885123253', 'no idea', '0885136951', NULL)

CREATE TABLE RoomStatus
(
	RoomStatus VARCHAR(10) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO RoomStatus (RoomStatus, Notes) VALUES
('busy', NULL),
('free', NULL),
('free', NULL)

CREATE TABLE RoomTypes
(
	RoomType VARCHAR(20) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO RoomTypes (RoomType, Notes) VALUES
('apartment', NULL),
('double', NULL),
('double', NULL)

CREATE TABLE BedTypes
(
	BedType VARCHAR(20) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO BedTypes (BedType, Notes) VALUES
('double', NULL),
('single', NULL),
('single', NULL)

CREATE TABLE Rooms
(
	RoomNumber INT PRIMARY KEY NOT NULL,
	RoomType VARCHAR(20) NOT NULL,
	BedType VARCHAR(20) NOT NULL,
	Rate FLOAT(2),
	RoomStatus VARCHAR(10) NOT NULL,
	Notes VARCHAR(MAX)
)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes) VALUES
(1, 'apartment', 'single', 4.6, 'free', NULL),
(2, 'apartment', 'double', NULL, 'free', NULL),
(3, 'apartment', 'single', 4.6, 'free', NULL)

CREATE TABLE Payments
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT NOT NULL,
	PaymentDate DATETIME NOT NULL,
	AccountNumber INT NOT NULL,
	FirstDateOccupied DATETIME NOT NULL,
	LastDateOccupied DATETIME NOT NULL,
	TotalDays INT NOT NULL,
	AmountCharged FLOAT(2),
	TaxRate FLOAT(2),
	TaxAmount FLOAT(2),
	PaymentTotal FLOAT(2),
	Notes VARCHAR(MAX)
)

INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied,
TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal, Notes) VALUES
(1, 1, '1/1/2000', 1, '1/1/2000', '5/1/2000', 120, 105621, 12, 52, 112012, NULL),
(2, 1, '1/1/2000', 1, '1/1/2000', '5/1/2000', 120, 105621, 12, 52, 112012, NULL),
(3, 1, '1/1/2000', 1, '1/1/2000', '5/1/2000', 120, 105621, 12, 52, 112012, NULL)

CREATE TABLE Occupancies
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT NOT NULL,
	DateOccupied DATETIME NOT NULL,
	AccountNumber INT NOT NULL,
	RoomNumber INT NOT NULL,
	RateApplied FLOAT(2),
	PhoneCharge FLOAT(2),
	Notes VARCHAR(MAX)
)

INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied, PhoneCharge, Notes) VALUES
(1, 1, '1/1/2000', 1, 1, NULL, 4.5, NULL),
(2, 1, '1/1/2000', 1, 1, NULL, NULL, NULL),
(3, 1, '1/1/2000', 1, 1, NULL, 4.5, NULL)
