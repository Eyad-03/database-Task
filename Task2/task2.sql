
 
/* ---------- 1. Base tables ---------- */
CREATE TABLE Departments (
    DepartmentID    INT          PRIMARY KEY,
    DepartmentName  VARCHAR(100) NOT NULL
);
 
CREATE TABLE Employees (
    EmployeeID    INT            PRIMARY KEY,
    FullName      VARCHAR(100)   NOT NULL,
    Email         VARCHAR(100)   UNIQUE,
    Salary        DECIMAL(10,2),
    DepartmentID  INT,
    CONSTRAINT FK_Employees_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO
 
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
    (1, 'IT'),
    (2, 'HR'),
    (3, 'Finance'),
    (4, 'Marketing');          -- no employees (shows in LEFT JOIN)
 
INSERT INTO Employees (EmployeeID, FullName, Email, Salary, DepartmentID) VALUES
    (1, 'Ahmad Ali',   'ahmad.ali@techworld.com',   1500.00, 1),
    (2, 'Sara Hassan', 'sara.hassan@techworld.com', 1200.00, 2),
    (3, 'Zaid Omar',   'zaid.omar@techworld.com',    900.00, 1),
    (4, 'Lina Khaled', 'lina.khaled@techworld.com',  800.00, 3);   -- no card/project: use for trigger test
GO
 
/* ---------- 2. Phase 5: relations ---------- */
-- 5.1  AccessCards (1:1)
CREATE TABLE AccessCards (
    CardID      INT          PRIMARY KEY,
    CardNumber  VARCHAR(50)  NOT NULL UNIQUE,
    EmployeeID  INT          UNIQUE,
    CONSTRAINT FK_AccessCards_Employees
        FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
 
-- 5.2  Projects + EmployeeProjects (M:N)
CREATE TABLE Projects (
    ProjectID    INT           PRIMARY KEY,
    ProjectName  VARCHAR(100)  NOT NULL
);
 
CREATE TABLE EmployeeProjects (
    EmployeeID    INT,
    ProjectID     INT,
    AssignedDate  DATE,
    CONSTRAINT PK_EmployeeProjects PRIMARY KEY (EmployeeID, ProjectID),
    CONSTRAINT FK_EmpProj_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT FK_EmpProj_Projects  FOREIGN KEY (ProjectID)  REFERENCES Projects(ProjectID)
);
GO
 
-- 5.3  Data
INSERT INTO AccessCards (CardID, CardNumber, EmployeeID) VALUES
    (101, 'CARD-101', 1),
    (102, 'CARD-102', 2),
    (103, 'CARD-103', 3);
 
INSERT INTO Projects (ProjectID, ProjectName) VALUES
    (1, 'AI & Security Training'),
    (2, 'Cloud Migration');
 
INSERT INTO EmployeeProjects (EmployeeID, ProjectID, AssignedDate) VALUES
    (1, 1, '2026-01-10'),   -- Ahmad Ali   -> Project 1
    (1, 2, '2026-01-15'),   -- Ahmad Ali   -> Project 2
    (2, 1, '2026-01-12'),   -- Sara Hassan -> Project 1
    (3, 2, '2026-01-20');   -- Zaid Omar   -> Project 2
GO


select
e.FullName,
e.Salary,
d.DepartmentName
from Employees as e
inner join Departments as d
on e.DepartmentID = d.DepartmentID


SELECT 
d.DepartmentID, 
d.DepartmentName, 
e.EmployeeID, 
e.FullName
FROM Departments d
LEFT JOIN Employees e
ON d.DepartmentID = e.DepartmentID;


select * from Employees
select * from AccessCards
select * from EmployeeProjects

select 
*
from Employees as e
inner join AccessCards as a
on e.EmployeeID = a.EmployeeID

SELECT e.FullName, p.ProjectName, ep.AssignedDate
FROM Employees e
INNER JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
INNER JOIN Projects p ON ep.ProjectID = p.ProjectID;


SELECT 
DepartmentID,
SUM(Salary) AS TotalSalary,
COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;


SELECT 
DepartmentID,
AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY DepartmentID
HAVING AVG(Salary) > 1000.00;

SELECT *
FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);


CREATE VIEW vw_EmployeeDetails AS
SELECT e.EmployeeID, e.FullName, e.Email, d.DepartmentName
FROM Employees e
INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;


CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DeptID INT
AS
BEGIN
    SELECT * FROM Employees WHERE DepartmentID = @DeptID;
END;



CREATE TABLE EmployeeAudit (
    AuditID     INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID  INT,
    Action      VARCHAR(50),
    ActionDate  DATETIME
);



create trigger trg_Employees_AfterDelete
on Employees 
after delete
as
Begin
    INSERT INTO EmployeeAudit (EmployeeID, Action, ActionDate)
    SELECT EmployeeID, 'DELETE', GETDATE()
    FROM deleted;
End

