CREATE TABLE [dbo].[tb_UserSetting]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] INT NOT NULL,
	[UserID] INT NOT NULL,
	[UserSettingID] INT NOT NULL,
	[UserSettingDataTypeID] INT NOT NULL,
	[StringValue] NVARCHAR(MAX)
)
GO

ALTER TABLE [dbo].[tb_UserSetting]  WITH CHECK ADD  CONSTRAINT [FK_UserSetting_tb_UserSettingDataType] FOREIGN KEY([UserSettingDataTypeID])
REFERENCES [dbo].[tb_UserSettingDataType] ([Id])
GO
