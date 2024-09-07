# Base image
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install PowerShell
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell

# Set PowerShell as the default shell
CMD ["pwsh"]
