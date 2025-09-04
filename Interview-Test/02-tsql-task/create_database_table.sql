/* ########################################################
Create testDB Script 
#######################################################*/


CREATE DATABASE TestDB; 
GO 

USE TestDB; 
GO 
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    Id INT NOT NULL, 
    [Name] NVARCHAR(500) NULL, 
    DepartmentId INT NULL, 
    Salary DECIMAL(12,2) NULL
    )
GO

-- Insert data into Employees
INSERT INTO Employees (Id, [Name], DepartmentId, Salary) VALUES (
    1, 'Cyril Darson', 'IT', 4000
    2, 'Timothy Taylor', 'HR', 5000
    3, 'Ronny Taylor', 'HR', 4500
    4, 'Naomi Campbell', 'Operation', 6500
    5, 'Ernest Yang', 'R&D', 5500
    6, 'Phenny Yung', 'R&D', 3600
)

GO
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments(
    Id INT NOT NULL, 
    [Name] NVARCHAR(500) NULL
    )
GO

INSERT INTO Departments(Id, [Name]) VALUES (
    51, 'IT' 
    52, 'HR'
    53, 'Operation'
    54, 'R&D'
    55, 'Facility'
    56, 'Finance'
)
GO