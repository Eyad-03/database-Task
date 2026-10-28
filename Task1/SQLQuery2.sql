

USE TechWorldHRDB;
GO

-- =============================================
-- Phase 2: DDL
-- =============================================

-- Task 2.1: Create Departments table
CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE
);

-- Task 2.2: Create Employees table
CREATE TABLE Employees (
    EmployeeID   INT PRIMARY KEY,
    FullName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) UNIQUE,
    Salary       DECIMAL(10,2),
    DepartmentID INT
);

-- Task 2.3: Add PhoneNumber column
ALTER TABLE Employees
ADD PhoneNumber VARCHAR(20);

-- Task 2.4: Drop TemporaryStaff table
DROP TABLE TemporaryStaff;
GO

-- =============================================
-- Phase 3: DML
-- =============================================

-- Task 3.1: Insert departments
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'IT'),
       (2, 'HR'),
       (3, 'Finance');

-- Task 3.2: Insert employees
INSERT INTO Employees (EmployeeID, FullName, Email, Salary, DepartmentID, PhoneNumber)
VALUES (1, 'Ahmad Ali',   'ahmad@techworld.com', 1200.00, 1, '0791111111'),
       (2, 'Tariq Ahmad', 'Tariq@techworld.com',   950.00, 2, '0792222222'),
       (3, 'Zaid Omar',   'zaid@techworld.com',  1500.00, 1, '0793333333'),
       (4, 'Mona Khaled', 'mona@techworld.com',   800.00, 3, '0794444444');

-- Task 3.3: Update Ahmad Ali's salary

UPDATE Employees
SET Salary = 1350.00
WHERE EmployeeID = 1;

-- Task 3.4: Delete Mona Khaled
DELETE FROM Employees
WHERE EmployeeID = 4;
GO

-- =============================================
-- Phase 4: Queries & Aggregations
-- =============================================

-- Task 4.1: All employee records
SELECT * FROM Employees;

-- Task 4.2: Specific columns
SELECT FullName, Salary FROM Employees;

-- Task 4.3: Total payroll (expected: 3800.00)
SELECT SUM(Salary) AS TotalSalaries FROM Employees;

-- Task 4.4: Average salary (expected: 1266.67)
SELECT AVG(Salary) AS AverageSalary FROM Employees;

-- Task 4.5: Highest & lowest salary (expected: 1500.00 / 950.00)
SELECT MAX(Salary) AS HighestSalary,
       MIN(Salary) AS LowestSalary
FROM Employees;

-- Task 4.6: Headcount (expected: 3)
SELECT COUNT(*) AS TotalEmployees FROM Employees;