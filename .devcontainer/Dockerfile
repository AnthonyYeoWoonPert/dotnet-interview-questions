FROM mcr.microsoft.com/dotnet/sdk:8.0

# Install .NET Framework SDK (for building legacy_webapp)
RUN apt-get update && apt-get install -y \
    msbuild \
    mono-complete \
    && rm -rf /var/lib/apt/lists/*

# Install SQL Server tools (sqlcmd, bcp)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/msprod.list
RUN apt-get update && apt-get install -y \
    mssql-tools \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Set PATH for SQL Server tools
ENV PATH="$PATH:/opt/mssql-tools/bin"

# Install SQL Server Express for local database (for legacy_webapp)
# This is a simplified setup for Codespaces. In a real scenario, a separate SQL Server instance would be used.
RUN apt-get update && apt-get install -y \
    sqlcmd \
    mssql-server \
    && rm -rf /var/lib/apt/lists/*

# Accept EULA for SQL Server
ENV ACCEPT_EULA=Y

# Expose ports for web app and SQL Server
EXPOSE 1433 1433

WORKDIR /workspace

