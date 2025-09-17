/* ####################################################################
Reminder: 
Please connect to MSSQL Database and execute create_database_table.sql

Coding Exercise 3

You are given two tables: 
Customers(Id, Name, isVIP) 
Orders(Id, CustomerId, OrderDate, TotalAmount) 

Write a T-SQL query to calculate the monthly sales summary, showing the total sales before and after discounts, with discounts applied only for VIP customers. 
- VIP customers receive a flat 10% discount if their purchase is RM 100 or above
- Non-VIP customers receive no discount 

#######################################################################*/


USE TestDB;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- place your script after this comment 


select
    CONVERT(char(7), o.OrderDate, 23) AS SalesMonth,   
    sum(o.TotalAmount) AS TotalBeforeDiscount,
    sum(
        CASE WHEN c.isVIP = 1 AND o.TotalAmount >= 100 
             THEN o.TotalAmount * 0.9
             ELSE o.TotalAmount
        END
    ) AS TotalAfterDiscount
from Orders o
join Customers c ON c.CustomerId = o.CustomerId
group by CONVERT(char(7), o.OrderDate, 23)
order by SalesMonth;
