CREATE PROCEDURE [dbo].[pr_GetUserSettingDataType]
	@Id int = NULL
AS
	SELECT [Id],
           [Name]
      FROM [SettingsStorage].[dbo].[tb_UserSettingDataType]
	 WHERE @Id IS NULL  OR [Id] = @Id
RETURN 0
