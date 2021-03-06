﻿/*
Deployment script for SettingsStorage

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SettingsStorage"
:setvar DefaultFilePrefix "SettingsStorage"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER2016\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER2016\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*
USE [SettingsStorage]
GO

IF (SELECT COUNT(1)
	  FROM [dbo].[tb_UserSettingDataType]) = 0

BEGIN
INSERT INTO [dbo].[tb_UserSettingDataType]
           ([Id]
           ,[Name])
     VALUES
	       (1,
            'betslider'),

           (2,
            'background')
END
GO

IF (SELECT COUNT(1)
	  FROM [dbo].[tb_UserSetting]) = 0

BEGIN
INSERT INTO [dbo].[tb_UserSetting]
           ([ProductID]
           ,[UserID]
           ,[UserSettingID]
           ,[UserSettingDataTypeID]
           ,[StringValue])
     VALUES
	       (7001,
            1,
            1,
            1,
            '{\"preFlop\":[\"2.2\",\"3\",\"5\"],\"postFlop\":[\"20\",\"30\",\"50\"]}'),
           (7001,
            1,
            1,
            2,
            '{\"preFlop\":["\#FFFFF"]}')
END
GO
*/
GO

GO
PRINT N'Update complete.';


GO
