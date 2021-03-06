USE [master]
GO

DECLARE @defaultData nvarchar(4000)
DECLARE @defaultLog nvarchar(4000)


EXEC master.dbo.xp_instance_regread
	N'HKEY_LOCAL_MACHINE',
	N'Software\Microsoft\MSSQLServer\MSSQLServer',
	N'DefaultData',
	@defaultData OUTPUT
 
EXEC master.dbo.xp_instance_regread
	N'HKEY_LOCAL_MACHINE',
	N'Software\Microsoft\MSSQLServer\MSSQLServer',
	N'DefaultLog',
	@defaultLog OUTPUT

SELECT @defaultData AS DefaultData, @defaultLog AS DefaultLog

IF @defaultData IS NULL
BEGIN
	SELECT @defaultData = REPLACE(physical_name,'master.mdf','') 
	FROM sys.master_files
	WHERE name = 'master'

	EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE'
		,N'Software\Microsoft\MSSQLServer\MSSQLServer'
		,N'DefaultData'
		,REG_SZ
		,@defaultData
END

IF @defaultLog IS NULL
BEGIN 
	SELECT @defaultLog = REPLACE(physical_name,'mastlog.ldf','') 
	FROM sys.master_files
	WHERE name = 'mastlog'

	EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE'
		,N'Software\Microsoft\MSSQLServer\MSSQLServer'
		,N'DefaultLog'
		,REG_SZ
		,@defaultLog

END

GO


