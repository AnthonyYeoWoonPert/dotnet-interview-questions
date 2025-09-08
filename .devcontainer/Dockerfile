# Use official .NET 8 SDK image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dev

# Install prerequisites for SQL client tools
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https ca-certificates unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Install prerequisites for SQL client tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl gnupg apt-transport-https ca-certificates unixodbc-dev \
    libc6 libstdc++6 libssl3 libkrb5-3 libgssapi-krb5-2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Add Microsoft repo for SQL tools (Ubuntu 22.04 = jammy)
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/22.04/prod jammy main" \
    > /etc/apt/sources.list.d/microsoft-prod.list

# Install sqlcmd + dependencies
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add sqlcmd to PATH
#ENV PATH="${PATH}:/opt/mssql-tools18/bin"

WORKDIR /workspace

# Copy everything into container (optional, depends on workflow)
COPY . .

# Default shell to bash
CMD [ "bash" ]
