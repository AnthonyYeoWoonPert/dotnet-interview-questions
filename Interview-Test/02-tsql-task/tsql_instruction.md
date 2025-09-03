# Running T-SQL tasks in GitHub Codespaces

## Setting up SQL environment 

1. Install SQL Server, using Docker and ensure that your .devcontainer.json file includes the necessary configurations to install SQL Server. 

2. Connect to SQL Server, use SQL client or command-line tools to connect to your SQL Server instance running in Codespace. 

3. Open the integrated terminal in your codespace. 
4. Run the TSQL commands or you can also use tools such as sqlcmd to run the TSQL script directly from the terminal 

``` bash
sqlcmd -S localhost -U SA -P 'PasswordYouAdded'

sqlcmd -S localhost -U SA -P 'PasswordYouAdded' -i your_answer_tsql.sql
```


