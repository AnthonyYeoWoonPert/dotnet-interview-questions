/* ########################################################
Coding Exercise 3

You are given two tables: 
Customers(Id, Name, isVIP) 
Orders(Id, CustomerId, OrderDate, TotalAmount) 

Write a T-SQL query to calculate the monthly sales summary, showing the total sales before and after discounts, with discounts applied only for VIP customers. 
- VIP customers receive a flat 10% discount if their purchase is RM 100 or above
- Non-VIP customers receive no discount 

#######################################################*/


USE TestDB;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- place your script after this comment 
