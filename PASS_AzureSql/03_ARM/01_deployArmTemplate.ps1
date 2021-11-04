$templateFile = 'C:\github\demos\PASS_AzureSql\03_ARM\sqlDbTemplate.json'
$adminCredentials = New-Object System.Management.Automation.PSCredential ('jpomfret ', (ConvertTo-SecureString -String 'P@ssword1234!' -AsPlainText -Force))

$armSplat = @{
  Name                        = 'testArm'
  ResourceGroupName           = 'PASSdemo'
  TemplateFile                = $templateFile
  serverName                  = 'JessSqlServer7'
  sqlDBName                   = 'ArmDemo'
  administratorLogin          = $adminCredentials.Username
  administratorLoginPassword  = $adminCredentials.Password
}
New-AzResourceGroupDeployment @armSplat

# Could change the template to vCore and then redeploy changing cores?