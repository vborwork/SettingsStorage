CREATE PROCEDURE [dbo].[pr_GetUserSetting]
	@UserID int = NULL
AS
	SELECT [Id],
           [ProductID],
           [UserID],
           [UserSettingID],
           [UserSettingDataTypeID],
           [StringValue]
	  FROM [SettingsStorage].[dbo].[tb_UserSetting]
	 WHERE @UserID IS NULL OR [UserID] = @UserId
RETURN 0
