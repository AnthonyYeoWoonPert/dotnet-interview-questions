# dotnet-interview-questions

## Senior Software Developer .NET Technical Test 

This technical test is designed to assess the skills and experience of a senior software developer (.NET). 
The test covers several key areas, including .NET Framework, .NET migration, T-SQL, MSSQL, troubleshooting, and general .NET knowledge. 
The test includes the combination of theoretical questions, practical coding exercises and scenario-based problems.

## Instructions

1. Fork this repository into your GitHub account. 
2. Navigate to the forked repository on GitHub.
3. Click on the green **Code** button. 
4. Select the **Codespace** tab. 

> Note:
> GitHub Free for personal accounts has 15GB/month storage and 120hrs compute time per month. No charges.
> If you don’t want to use Codespaces, you can run the Docker Compose setup from .devcontainer/docker-compose.yml on your local machine.


5. Click **Create codespace on main**.

> Note:
> GitHub Codespace will provision a new environment based on the <mark>_.devcontainer_</mark> configuration in this repository. This may take a few minutes for the initial step, as it is including installing .NET SDK, MSSQL, and SQL Server tools.

6. Check if the following directories exists 
    
    - [X] Interview-Test/01-dotnet-task
        - [x] 01_instruction.md
    - [X] Interview-Test/02-tsql-task
        - [x] 00_tsql_instruction.md
        - [x] 01_tsql_question.sql
        - [x] 02_tsql_question.sql
        - [x] 03_tsql_question.sql
        - [x] create_database_table.sql
    - [X] Interview-Test/03-troubleshooting-task
        - [x] troubleshooting_instruction.md

> Hint: 
> Take some times to read all the instructions before your start

7. Please answer all the questions to the best of your ability. 
8. For coding exercises, please provide the complete code solution if possible. 
    a) Download all the execution results (if applicable) for reference.
9. For theoretical exercises and scenario-based exercises, please provide a clear and concise explanations.

Happy Coding!

## Codespace Environment 

The codespace environment is pre-configured with 

- .NET SDK 
- Tools for .NET Framework 
- SQL Server command line tools 
- Visual Studio Code extension for C# and MSSQL
- MSSQL docker-compose file in .devcontainer


## Test Structure 
```
├─ .devcontainer/
│ ├── devcontainer.json # Dev container configuration for consistent environment
│ ├── docker-compose.yml # Docker Compose setup for services (e.g., SQL Server)
│ ├── Dockerfile # Docker build instructions
│ ├── setup-sqlcmd.sh # Script to install and configure sqlcmd inside container
│
├─ archive/ # Archived/old files (not used in active tasks)
│
├─ Interview-Test/
│ ├── 01-dotnet-task/
│ │ ├── 01_instruction.md # Instructions for .NET coding task
│ │ ├── 01_dotnet_code_answer/ # Folder for Question 1
│ │ │ └── ProgramAPI.csproj # Example files
│ │ ├── 02_dotnet_code_answer/ # Folder for Question 2
│ │ └── 03_dotnet_code_answer/ # Folder for Question 3
│
│ ├── 02-tsql-task/
│ │ ├── 00_tsql_instruction.md # Instructions for SQL coding task
│ │ ├── 01_tsql_question.md # Question 1 description (Markdown)
│ │ ├── 01_tsql_question.sql # SQL script for Question 1
│ │ ├── 02_tsql_question.sql # SQL script for Question 2
│ │ ├── 03_tsql_question.sql # SQL script for Question 3
│ │ └── create_database_table.sql # SQL script to create required database tables
│
│ ├── 03-troubleshooting-task/
│ │ └── troubleshooting_question.md # Questions for troubleshooting task
│
├─ .gitignore # Git ignore file
├─ LICENSE # License for repository
└─ README.md # Project documentation
```
## Submission

Once you have completed both parts of the test, pleaase commit your changes to your forked repository and notify us.


*Author: Breakfast Byte Sdn. Bhd.*
