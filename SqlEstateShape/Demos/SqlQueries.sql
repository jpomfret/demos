use DatabaseAdmin

-- 01_dbachecks.ps1
select *
from BackupChecks

select * 
from dbachecksChecks

-- 02_dbachecks.ps1

-- Baseline Fitness time
Select *
from CheckResults

-- set the baseline back a day so the graphs show over time (only currently support daily)
update c set date = dateadd(day,-1,date)
from CheckResults c



-- Ola
select * from master.dbo.commandlog