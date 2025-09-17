/* ####################################################################
Reminder: 
Please connect to MSSQL Database and execute create_database_table.sql

Coding Exercise 2

Write a TSQL stored procedure named spUpdateEmployeeSalary that 
- takes Name (string), DepartmentID and NewSalary (decimal) as input. 

The procedure should update the Salary for the specified employee. 
Include error handling (e.g., if the employee does not exist) and 

Additional Requirement: 
- use a transaction to ensure data integrity. 

######################################################################*/

Use TestDB;
SELECT * FROM Employees;
SELECT * FROM Departments;
GO

--- place your script after this comments
IF OBJECT_ID('dbo.usp_UpdateEmployeeSalary', 'P') IS NOT NULL
	DROP PROCEDURE dbo.usp_UpdateEmployeeSalary; 
GO

CREATE PROCEDURE dbo.usp_UpdateEmployeeSalary
	@Name NVARCHAR(500), 
	@DepartmentId INT, 
	@NewSalary DECIMAL(12,2), 
	@ResultCode INT OUTPUT, 
	@ResultDesc NVARCHAR(200) OUTPUT 
AS
BEGIN
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	set @ResultCode = -9; 
	set @ResultDesc = N'Unexpected error';

	IF @Name IS NULL
	BEGIN 
		set @ResultCode = -1; 
		set @ResultDesc = N'Missing Name'; 
		return; 
	END

	IF @DepartmentId IS NULL 
	BEGIN 
		set @ResultCode = -2; 
		set @ResultDesc = N'Missing DepartmentId'; 
		return; 
	END

	IF @NewSalary IS NULL OR @NewSalary < 0 
	BEGIN 
		set @ResultCode = -3; 
		set @ResultDesc = N'Invalid NewSalary'; 
		return; 
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.Departments WHERE DepartmentId = @DepartmentId) 
	BEGIN 
		set @ResultCode = -4; 
		set @ResultDesc = N'Department not found'; 
		return;
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE name = @Name) 
	BEGIN 
		set @ResultCode = -5; 
		set @ResultDesc = N'Employee not found'; 
		return; 
	END

	IF NOT EXISTS (SELECT 1 FROM dbo.Employees WHERE name = @Name and Id = @DepartmentId) 
	BEGIN 
		set @ResultCode = -6; 
		set @ResultDesc = N'Employee deos not exist in Department'; 
		return; 
	END

	begin try
        begin transaction;

        update dbo.Employees
           set Salary = @NewSalary
         where [Name] = @Name
           AND DepartmentId = @DepartmentId;

        IF @@ROWCOUNT = 0
        begin
            rollback;
            set @ResultCode = -7; 
            set @ResultDesc = N'No rows updated (concurrent change)';
            return;
        end

        commit;
        set @ResultCode = 0;
        set @ResultDesc = N'Success';
    end try
    begin catch
        if XACT_STATE() <> 0 rollback;
        set @ResultCode = -9;
        set @ResultDesc = N'Unexpected error in procedure';
    end catch
END
GO



