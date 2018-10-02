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
           ([Id]
           ,[ProductID]
           ,[UserID]
           ,[UserSettingID]
           ,[UserSettingDataTypeID]
           ,[StringValue])
     VALUES
	       (1,
            7001,
            1,
            1,
            1,
            '{\"preFlop\":[\"2.2\",\"3\",\"5\"],\"postFlop\":[\"20\",\"30\",\"50\"]}'),
           (2,
            7001,
            1,
            1,
            2,
            '{\"preFlop\":["\#FFFFF"]}')
END
GO

