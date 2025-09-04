# Running T-SQL tasks in GitHub Codespaces

## Setting up SQL Server for T-SQL and MSSQL coding exercise

An MSSQL instance should be automatically started via docker-compose in the .devcontainer when the Codespace is created.

You can connect to the mssql in the command palette 

1. Press _F1_ and type MS SQL:Add Connection

``` 
Host: localhost
Port: 1433
User: SA
Password: "P@ssw0rdStrong!"
Trusted: Check
```

1. to set up the TestDB and Tables, connect to the SQL Server Instance and execute the following scripts
    - [x] create_database_table.sql 

2. For the theoretical exercise, write your answers directly in **_01_tsql_question.md_** and commit.

3. For the coding exercise, write your code in the following file: 
    - [x] 02_tsql_question.sql 
    - [x] 03_tsql_question.sql 
