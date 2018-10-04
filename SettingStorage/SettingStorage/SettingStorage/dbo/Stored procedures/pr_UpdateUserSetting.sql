CREATE PROCEDURE [dbo].[pr_UpdateUserSetting]
                (@UserID int,
				 @UserSettingDataTypeID int,
                 @StringValue nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;

	BEGIN TRY
		UPDATE [SettingsStorage].[dbo].[tb_UserSetting]
		   SET [StringValue] = @StringValue
		 WHERE [UserId] = @UserID
		   AND [UserSettingDataTypeID] = @UserSettingDataTypeID
			
		SET @ReturnCode = 0;

		IF @TranCount = 0 COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0 AND @TranCount = 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
	END CATCH

RETURN @ReturnCode;
