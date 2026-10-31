
CREATE TABLE Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Students (
    StudentID    INT PRIMARY KEY,
    FullName     VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) UNIQUE,
    GPA          DECIMAL(3,2),
    DepartmentID INT,
    CONSTRAINT FK_Students_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE StudentProfiles (
    ProfileID      INT PRIMARY KEY,
    StudentID      INT UNIQUE,
    Address        VARCHAR(200),
    EmergencyPhone VARCHAR(20),
    CONSTRAINT FK_StudentProfiles_Students
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);


CREATE TABLE Courses (
    CourseID     INT PRIMARY KEY,
    CourseName   VARCHAR(100) NOT NULL,
    Credits      INT,
    DepartmentID INT,
    CONSTRAINT FK_Courses_Departments
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);


CREATE TABLE StudentCourses (
    StudentID      INT,
    CourseID       INT,
    EnrollmentDate DATE DEFAULT GETDATE(),
    CONSTRAINT PK_StudentCourses PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_StudentCourses_Students
        FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_StudentCourses_Courses
        FOREIGN KEY (CourseID)  REFERENCES Courses(CourseID)
);


ALTER TABLE Students ADD Age INT;

DROP TABLE TempInstructors;



INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Software Engineering'),
(3, 'Business Administration');


INSERT INTO Students (StudentID, FullName, Email, GPA, DepartmentID, Age) VALUES
(101, 'Ali Smadi',    'ali@coursehub.com',   3.80, 1, 22),
(102, 'Omar Ahmad',   'omar@coursehub.com',  2.90, 1, 21),
(103, 'Laila Hassan', 'laila@coursehub.com', 3.50, 2, 23),
(104, 'Tariq Zaid',   'tariq@coursehub.com', 2.10, 3, 20);


INSERT INTO StudentProfiles (ProfileID, StudentID, Address, EmergencyPhone) VALUES
(1, 101, 'Amman, Jordan', '0791111111'),
(2, 102, 'Irbid, Jordan', '0792222222'),
(3, 103, 'Zarqa, Jordan', '0793333333');


INSERT INTO Courses (CourseID, CourseName, Credits, DepartmentID) VALUES
(201, 'Database Systems',      3, 1),
(202, 'Web Development',       3, 1),
(203, 'Software Architecture', 3, 2);


INSERT INTO StudentCourses (StudentID, CourseID) VALUES
(101, 201),
(101, 202),
(102, 201),
(103, 203);


UPDATE Students
SET    GPA = 2.50
WHERE  StudentID = 104;

DELETE FROM Students
WHERE  StudentID = 104;


SELECT s.FullName, s.GPA, d.DepartmentName
FROM   Students s
INNER JOIN Departments d ON s.DepartmentID = d.DepartmentID;


SELECT d.DepartmentName, s.StudentID, s.FullName, s.GPA
FROM   Departments d
LEFT JOIN Students s ON d.DepartmentID = s.DepartmentID;


SELECT s.FullName, p.Address, p.EmergencyPhone
FROM   Students s
INNER JOIN StudentProfiles p ON s.StudentID = p.StudentID;


SELECT s.FullName, c.CourseName, sc.EnrollmentDate
FROM   Students s
INNER JOIN StudentCourses sc ON s.StudentID = sc.StudentID
INNER JOIN Courses c         ON sc.CourseID = c.CourseID;

SELECT COUNT(*) AS TotalStudents,
       AVG(GPA) AS AverageGPA,
       MAX(GPA) AS HighestGPA,
       MIN(GPA) AS LowestGPA
FROM   Students;



SELECT DepartmentID,
       AVG(GPA) AS AverageGPA,
       COUNT(*) AS TotalStudents
FROM   Students
GROUP BY DepartmentID;


SELECT DepartmentID, AVG(GPA) AS AverageGPA
FROM   Students
GROUP BY DepartmentID
HAVING AVG(GPA) > 3.00;


SELECT DepartmentID, COUNT(*) AS StudentCount
FROM   Students
WHERE  GPA >= 2.50
GROUP BY DepartmentID
HAVING COUNT(*) > 1;



SELECT i.name AS IndexName, i.type_desc, c.name AS ColumnName
FROM   sys.indexes i
JOIN   sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN   sys.columns c        ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE  i.object_id = OBJECT_ID('Students')
  AND  i.type_desc = 'CLUSTERED';


create NONCLUSTERED index IX_Students_Email ON Students (Email);

SELECT StudentID, FullName, GPA
FROM   Students
WHERE  GPA > (SELECT AVG(GPA) FROM Students);


CREATE VIEW vw_StudentAcademicDetails
AS
SELECT s.StudentID, s.FullName, s.GPA, d.DepartmentName
FROM   Students s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID;


SELECT * FROM vw_StudentAcademicDetails; 



CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptID INT
AS
BEGIN
 
    SELECT StudentID, FullName, Email, GPA, DepartmentID, Age
    FROM   Students
    WHERE  DepartmentID = @DeptID;
END;

EXEC sp_GetStudentsByDepartment @DeptID = 1; 

