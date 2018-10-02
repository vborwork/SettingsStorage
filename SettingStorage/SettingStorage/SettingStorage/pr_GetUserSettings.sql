CREATE PROCEDURE [dbo].[pr_GetUserSetting]
	@UserID int
AS
	SELECT [Id],
           [ProductID],
           [UserID],
           [UserSettingID],
           [UserSettingDataTypeID],
           [StringValue]
	  FROM [SettingsStorage].[dbo].[tb_UserSetting]
	 WHERE [UserID] = @UserId
RETURN 0
