/* ########################################################
Reminder: 
Please connect to MSSQL Database and execute create_database_table.sql

Create testDB Script 
#######################################################*/

-- Create Database TestDB
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'TestDB')
BEGIN
    CREATE DATABASE [TestDB];
END
GO 

-- Drop and Create Table Employees
USE TestDB; 
GO 
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    Id INT IDENTITY(1,1) PRIMARY KEY, 
    [Name] NVARCHAR(500) NULL, 
    DepartmentId INT NULL, 
    Salary DECIMAL(12,2) NULL
    )
GO

-- Insert data into Employees
INSERT INTO Employees ([Name], DepartmentId, Salary) VALUES 
    ('Cyril Darson', 51, 4000),
    ('Timothy Taylor',52, 5000),
    ('Ronny Taylor', 52, 4500),
    ('Naomi Campbell',53,  6500),
    ('Ernest Yang', 54, 5500),
    ('Phenny Yung', 54, 3600);
GO

-- Drop and Create Table Departments
DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments(
    Id INT NOT NULL, 
    [Name] NVARCHAR(500) NULL
    )
GO
-- Insert data into Departments
INSERT INTO Departments(Id, [Name]) VALUES
    (51, 'IT'),
    (52, 'HR'),
    (53, 'Operation'),
    (54, 'R&D'),
    (55, 'Facility'),
    (56, 'Finance')
GO
-- Drop and Create Table Customers
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
    CustomerId INT NOT NULL, 
    CustomerName NVARCHAR(500) NULL, 
    isVIP BIT
)
GO
-- Insert data into Customers
INSERT INTO Customers(CustomerId, CustomerName, isVIP) VALUES
    (1, 'Alice Tan', 1),   -- VIP
    (2, 'Bob Lee', 0),     -- Non-VIP
    (3, 'Charlie Wong', 1),-- VIP
    (4, 'David Lim', 0),   -- Non-VIP
    (5, 'Ana Tan', 0), -- Non-VIP
    (6, 'Timothy Luke', 1) -- VIP

-- Drop and Create Table Employees
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
    OrderId INT NOT NULL, 
    CustomerId INT NOT NULL, 
    OrderDate DATE NOT NULL, 
    TotalAmount DECIMAL(12,2) NULL, 
    isProcessed BIT NULL
)
GO 
-- Insert data into Orders
INSERT INTO Orders (OrderId, CustomerId, OrderDate, TotalAmount, isProcessed) VALUES
    -- January 2025
    (101, 1, '2025-01-05', 250.00, 1),  -- Alice (VIP, eligible for discount)
    (102, 2, '2025-01-10', 90.00,0),   -- Bob (Non-VIP, no discount)
    (103, 3, '2025-01-15', 150.00,1),  -- Charlie (VIP, eligible for discount)
    (103, 6, '2025-01-18', 320.00,1),  -- Timothy (VIP, eligible for discount)

    -- February 2025
    (104, 4, '2025-02-02', 70.00,1),   -- David (Non-VIP, no discount)
    (105, 1, '2025-02-10', 300.00,1),  -- Alice (VIP, eligible for discount)

    -- March 2025
    (106, 2, '2025-03-01', 120.00,0),  -- Bob (Non-VIP, no discount)
    (107, 3, '2025-03-12', 200.00,0),  -- Charlie (VIP, eligible for discount)
    (108, 4, '2025-03-20', 50.00,1);   -- David (Non-VIP, no discount)

