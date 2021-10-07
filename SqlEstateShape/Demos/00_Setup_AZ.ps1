# Install Choco
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install docker-desktop -y
choco install git -y
choco install vscode -y
choco install vscode-powershell -y

choco install azure-data-studio -y
choco install powerbi -y --ignore-checksums
choco install zoomit -y

# new window
New-Item C:\Github -ItemType Directory
Set-Location C:\Github
git clone https://github.com/jpomfret/demos.git
Set-Location .\Demos

