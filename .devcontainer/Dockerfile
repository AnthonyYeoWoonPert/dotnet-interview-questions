# Base on official SQL Server container so MSSQL_* env vars work
FROM mcr.microsoft.com/mssql/server:2022-latest

# Install prerequisites and Microsoft repo
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https ca-certificates unixodbc-dev \
 && rm -rf /var/lib/apt/lists/* \
 && curl -sSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
 && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" \
    > /etc/apt/sources.list.d/microsoft-prod.list

# Install sqlcmd tools + .NET 8 SDK
RUN apt-get update \
 && ACCEPT_EULA=Y apt-get install -y mssql-tools18 dotnet-sdk-8.0 unixodbc-dev \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y dotnet-sdk-8.0 dotnet-runtime-8.0
# Put sqlcmd on PATH
ENV PATH="${PATH}:/opt/mssql-tools18/bin"

# Optional: working directory for your code
WORKDIR /workspace
