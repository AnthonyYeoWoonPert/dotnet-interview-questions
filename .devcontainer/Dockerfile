# Use official .NET 8 SDK image as base
FROM mcr.microsoft.com/devcontainers/dotnet:1-8.0-bookworm as dev

# Install prerequisites
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    apt-transport-https \
    ca-certificates \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft repo for SQL tools
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/$(lsb_release -rs)/prod main" \
    > /etc/apt/sources.list.d/microsoft-prod.list

# Install SQL Server tools (sqlcmd, bcp)
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y \
    mssql-tools18 \
    && rm -rf /var/lib/apt/lists/*

# Add sqlcmd to PATH
ENV PATH="${PATH}:/opt/mssql-tools18/bin"

# Expose ports for your .NET app
EXPOSE 5000 5001

WORKDIR /workspace
