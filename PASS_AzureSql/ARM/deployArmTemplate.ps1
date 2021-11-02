$templateFile = 'C:\github\demos\PASS_AzureSql\ARM\sqlDbTemplate.json'
$parameterFile = 'C:\github\demos\PASS_AzureSql\ARM\sqlDbParameters.json'

$armSplat = @{
  Name = 'testArm'
  ResourceGroupName     = 'PASSdemo'
  TemplateFile          = $templateFile
  TemplateParameterFile  = $parameterFile
}
New-AzResourceGroupDeployment @armSplat