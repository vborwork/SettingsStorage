CREATE PROCEDURE [dbo].[pr_CreateUserSetting]
                ( @ProductID int,
                  @UserID int,
                  @UserSettingID int,
                  @UserSettingDataTypeID int,
                  @StringValue nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;
DECLARE @ID TABLE (ID int);

	BEGIN TRY
		INSERT [SettingsStorage].[dbo].[tb_UserSetting]
			  ([ProductID],
               [UserID],
               [UserSettingID],
               [UserSettingDataTypeID],
               [StringValue])
	    OUTPUT INSERTED.Id
		  INTO @ID(ID)
		VALUES
		    (@ProductID,
             @UserID,
             @UserSettingID,
             @UserSettingDataTypeID,
             @StringValue)

		SET @ReturnCode = 0;

	 SELECT ID as [RowID]
	   FROM @ID;

		IF @TranCount = 0 
		BEGIN
			COMMIT TRANSACTION;
		  END
	END TRY
	BEGIN CATCH
		IF XACT_STATE() <> 0 AND @TranCount = 0
		BEGIN
			ROLLBACK TRANSACTION;
		END
	END CATCH

RETURN @ReturnCode;

