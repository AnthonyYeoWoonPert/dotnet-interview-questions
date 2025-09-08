# Base on .NET 8 SDK (Debian 12)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS dev

# Install only essential dependencies (skip sqlcmd)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl gnupg apt-transport-https ca-certificates unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . .

CMD ["bash"]
