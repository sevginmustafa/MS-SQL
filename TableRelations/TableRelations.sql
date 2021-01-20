--Problem 1. One-To-One Relationship
CREATE TABLE Passports
(
	PassportID INT IDENTITY(101,1) PRIMARY KEY ,
	PassportNumber VARCHAR(8) NOT NULL
)

INSERT INTO Passports(PassportNumber) VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

CREATE TABLE Persons
(
	PersonID INT IDENTITY PRIMARY KEY,
	FirstName NVARCHAR(50) NOT NULL,
	Salary DECIMAL(10,2) NOT NULL,
	PassportID INT UNIQUE REFERENCES Passports(PassportID) NOT NULL
)

INSERT INTO Persons(FirstName, Salary, PassportID) VALUES
('Roberto', 43300, 102),
('Tom', 56100, 103),
('Yana', 60200, 101)


--Problem 2. One-To-Many Relationship
CREATE TABLE Manufacturers
(
	ManufacturerID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	EstablishedOn DATETIME
)

INSERT INTO Manufacturers(Name, EstablishedOn) VALUES
('BMW', '03/07/1916'),
('Tesla', '01/01/2003'),
('Lada', '05/01/1966')

CREATE TABLE Models
(
	ModelID INT IDENTITY(101,1) PRIMARY KEY,
	Name VARCHAR(20) NOT NULL,
	ManufacturerID INT REFERENCES Manufacturers(ManufacturerID) NOT NULL
)

INSERT INTO Models(Name, ManufacturerID) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)


--Problem 3. Many-To-Many Relationship
CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL
)

INSERT INTO Students(Name) VALUES
('Mila'),
('Toni'),
('Ron ')

CREATE TABLE Exams
(
	ExamID INT IDENTITY(101,1) PRIMARY KEY,
	Name VARCHAR(100) NOT NULL
)

INSERT INTO Exams(Name) VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

CREATE TABLE StudentsExams
(
	StudentID INT REFERENCES Students(StudentID),
	ExamID INT REFERENCES Exams(ExamID),
	PRIMARY KEY (StudentID, ExamID)
)

INSERT INTO StudentsExams(StudentID, ExamID) VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)


--Problem 4. Self-Referencing
CREATE TABLE Teachers
(
	TeacherID INT IDENTITY(101,1) PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL,
	ManagerID INT REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers(Name, ManagerID) VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)


--Problem 5. Online Store Database
CREATE DATABASE OnlineStore

CREATE TABLE Cities
(
	CityID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Customers
(
	CustomerID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	Birthdate DATE NOT NULL,
	CityID INT REFERENCES Cities(CityID)
)

CREATE TABLE ItemTypes
(
	ItemTypeID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Items
(
	ItemID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	ItemTypeID INT REFERENCES ItemTypes(ItemTypeID)
)

CREATE TABLE Orders
(
	OrderID INT IDENTITY PRIMARY KEY,
	CustomerID INT REFERENCES Customers(CustomerID)
)

CREATE TABLE OrderItems
(
	OrderID INT REFERENCES Orders(OrderID),
	ItemID INT REFERENCES Items(ItemID),
	PRIMARY KEY(OrderID, ItemID)
)


--Problem 6. University Database
CREATE DATABASE University

CREATE TABLE Majors
(
	MajorID INT IDENTITY PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Students
(
	StudentID INT IDENTITY PRIMARY KEY,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(50) NOT NULL,
	MajorID INT REFERENCES Majors(MajorID) NOT NULL
)

CREATE TABLE Payments
(
	PaymentID INT IDENTITY PRIMARY KEY,
	PaymentDate DATE NOT NULL,
	PaymentAmount DECIMAL(10,2) NOT NULL,
	StudentID INT REFERENCES Students(StudentID) NOT NULL
)

CREATE TABLE Subjects
(
	SubjectID INT IDENTITY PRIMARY KEY,
	SubjectName VARCHAR(100) NOT NULL
)

CREATE TABLE Agenda
(
	StudentID INT REFERENCES Students(StudentID),
	SubjectID INT REFERENCES Subjects(SubjectID),
	PRIMARY KEY(StudentID, SubjectID)
)
	

--Problem 9. *Peaks in Rila
SELECT MountainRange, PeakName, Elevation 
FROM Peaks
JOIN Mountains ON Peaks.MountainId = Mountains.Id
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC