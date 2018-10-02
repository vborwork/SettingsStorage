CREATE PROCEDURE [dbo].[pr_CreateUserSetting]
                ( @Id int,
				  @ProductID int,
                  @UserID int,
                  @UserSettingID int,
                  @UserSettingDataTypeID int,
                  @StringValue nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;

	BEGIN TRY
		INSERT [SettingsStorage].[dbo].[tb_UserSetting]
			([Id],
			 [ProductID],
             [UserID],
             [UserSettingID],
             [UserSettingDataTypeID],
             [StringValue])
		VALUES
		    (@Id,
			 @ProductID,
             @UserID,
             @UserSettingID,
             @UserSettingDataTypeID,
             @StringValue)

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

