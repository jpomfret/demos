CREATE DATABASE [AdventureWorks2017] ON
(FILENAME = '/var/opt/sqlserver/AdventureWorks2017.mdf'),
(FILENAME = '/var/opt/sqlserver/AdventureWorks2017_log.ldf') FOR ATTACH;

GO

CREATE DATABASE DatabaseAdmin
GO

BACKUP DATABASE [AdventureWorks2017] TO DISK = N'/var/opt/backups/AdventureWorks2017.bak' WITH NAME = N'AdventureWorks2017-Full Database Backup'
