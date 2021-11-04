# Set some defaults so we don't have to specify the resource group and server everytimg
az configure --defaults group=PASSdemo sql-server=jesssqlserver7

# We can view the current defaults to see what's set
az configure --list-defaults

# View all the sql servers in our default resource group
az sql server list

# View all the sql server databases on our default server
az sql db list

# Create a sql database on the jesssqlserver7 server - general purpose tier with 2 cores
az sql db create -g PASSdemo -s jesssqlserver7 -n clidb -e GeneralPurpose -f Gen5 -c 2

# view the tde status
az sql db tde show -d clidb

# Can also see this in the portal
Start-Process https://portal.azure.com/#@jpomfret7gmail.onmicrosoft.com/resource/subscriptions/4a2fc46b-5743-43a9-b24d-d91d3a65cae4/resourceGroups/PASSdemo/providers/Microsoft.Sql/servers/jesssqlserver7/databases/clidb/tde

# Change the tde status
az sql db tde set -d clidb --status disabled

# There are also similar commands for MIs

# list all managed instances in the default resource group
az sql mi list

# list all managed databases on a managed instance
az sql midb list --mi myManagedInstance