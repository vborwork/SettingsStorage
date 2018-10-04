CREATE PROCEDURE [dbo].[pr_UpdateUserSettingDataType]
                (@Id int,
                 @Name nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;

	BEGIN TRY
		UPDATE [SettingsStorage].[dbo].[tb_UserSettingDataType]
		   SET [Name] = @Name
		 WHERE [Id] = @Id
			
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