/*
	Created by POMFPC\jpomf using dbatools Export-DbaLogin for objects on mssql2 at 2019-09-29 20:07:20.861
	See https://dbatools.io/Export-DbaLogin for more information
*/
USE master

GO
IF NOT EXISTS (SELECT loginname FROM master.dbo.syslogins WHERE name = 'BUILTIN\Administrators') CREATE LOGIN [BUILTIN\Administrators] FROM WINDOWS WITH DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = [us_english]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [BUILTIN\Administrators]
GO

USE master

GO
Grant CONNECT SQL TO [BUILTIN\Administrators]  AS [sa]
GO

USE master

GO
IF NOT EXISTS (SELECT loginname FROM master.dbo.syslogins WHERE name = 'JessP') CREATE LOGIN [JessP] WITH PASSWORD = 0x0200670F1C235A48A3B50F5D151A7E32AF44581A61157C0EE922BF98BDD63433E404F746BAED2F25EF2E8067C15D93BA7300C544BE6BCDA68BC6684C0FB819796D9FFEEE7833 HASHED, SID = 0x4FC64F9F7CCB574C9FB990321E2959A2, DEFAULT_DATABASE = [master], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF, DEFAULT_LANGUAGE = [us_english]
GO

USE master

GO
Grant CONNECT SQL TO [JessP]  AS [sa]
GO

USE [DatabaseAdmin]

GO
CREATE USER [JessP] FOR LOGIN [JessP] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [JessP]
GO
Grant CONNECT TO [JessP]  AS [dbo]
GO
