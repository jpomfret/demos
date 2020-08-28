# Import modules
Import-Module pester -RequiredVersion 4.10.1
Import-Module dbachecks

# Run your checks
$sqlinstances = 'mssql1','mssql2','mssql3','mssql4'
$testResults = Invoke-DbcCheck -SqlInstance $sqlinstances -Check LastBackup, DatabaseStatus -PassThru

# Create your report
# highlight any failed results
$ConditionalFormat =$(
    New-ConditionalText -Text Failed -Range 'D:D'
)

$excelSplat = @{
    Path               = 'C:\Temp\Backups.xlsx'
    WorkSheetName      = 'TestResults'
    TableName          = 'Results'
    Autosize           = $true
    ConditionalFormat  = $ConditionalFormat
    IncludePivotTable  = $true
	PivotRows          = 'Describe'
    PivotData          = @{Describe='Count'}
    PivotColumns       = 'Result'
	IncludePivotChart  = $true
	ChartType          = 'ColumnStacked'
}

$testResults.TestResult |
Select-Object Describe, Context, Name, Result, Failuremessage |
Export-Excel @excelSplat