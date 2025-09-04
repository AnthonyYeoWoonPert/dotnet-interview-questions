FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Install .NET Framework build tools (msbuild is part of mono-complete for Linux)
RUN apt-get update && apt-get install -y \
    mono-complete \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install SQL Server tools (sqlcmd, bcp) - these are client tools, not the server itself
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/msprod.list

RUN apt-get update && apt-get install -y \
    mssql-tools \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Set PATH for SQL Server tools
ENV PATH="$PATH:/opt/mssql-tools/bin"

# Expose ports for web app (MSSQL will be exposed via docker-compose)
EXPOSE 1433

WORKDIR /workspace