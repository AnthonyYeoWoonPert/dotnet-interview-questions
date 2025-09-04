/* ########################################################
Coding Exercise 2

Write a TSQL stored procedure named UpdateEmployeeSalary that 
- takes Name (string), DepartmentID and NewSalary (decimal) as input. 

The procedure should update the Salary for the specified employee. 
Include error handling (e.g., if the employee does not exist) and 

Additional Requirement: 
- use a transaction to ensure data integrity. 

#######################################################*/
Use TestDB;
SELECT * FROM Employees;
-- SELECT * FROM Departments;
GO

--- place your script after this comments
