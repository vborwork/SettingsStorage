CREATE PROCEDURE [dbo].[pr_DeleteUserSettingDataType]
                (@Id int,
				 @Name nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;

	BEGIN TRY
		DELETE FROM [SettingsStorage].[dbo].[tb_UserSettingDataType]
		      WHERE [Id] = @Id
		        AND [Name] = @Name
			
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
