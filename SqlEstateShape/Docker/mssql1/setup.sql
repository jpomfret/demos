    CREATE DATABASE [AdventureWorks2017] ON
    (FILENAME = '/var/opt/sqlserver/AdventureWorks2017.mdf'),
    (FILENAME = '/var/opt/sqlserver/AdventureWorks2017_log.ldf') FOR ATTACH;

    GO

    Use Master

    CREATE DATABASE ImportantAppDb
    COLLATE French_CI_AI;

    CREATE DATABASE ImportantAppDb2;
    ALTER DATABASE ImportantAppDb2 SET AUTO_SHRINK ON, AUTO_CLOSE ON;

    GO

    -- Disable and then reenable but don't enforce check
    Use AdventureWorks2017
    ALTER TABLE Sales.SalesTerritoryHistory NOCHECK CONSTRAINT FK_SalesTerritoryHistory_SalesTerritory_TerritoryID
    ALTER TABLE Person.StateProvince NOCHECK CONSTRAINT FK_StateProvince_SalesTerritory_TerritoryID
    ALTER TABLE Sales.SalesTerritoryHistory CHECK CONSTRAINT FK_SalesTerritoryHistory_SalesTerritory_TerritoryID
    ALTER TABLE Person.StateProvince CHECK CONSTRAINT FK_StateProvince_SalesTerritory_TerritoryID

    GO

    CREATE DATABASE DatabaseAdmin
    GO

    ALTER DATABASE [AdventureWorks2017] SET RECOVERY FULL ;

    BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.bak'
    WAITFOR DELAY '00:00:05';
    BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.diff' WITH DIFFERENTIAL
    WAITFOR DELAY '00:00:05';
    BACKUP LOG [AdventureWorks2017] TO DISK = N'C:\var\opt\backups\AdventureWorks2017.log'

    GO

    -- Turn off PAGE_VERIFY
    ALTER DATABASE [ImportantAppDb2] SET PAGE_VERIFY NONE WITH NO_WAIT;
    GO

    -- guest connect access
    USE DatabaseAdmin
    GO
    GRANT CONNECT TO Guest
