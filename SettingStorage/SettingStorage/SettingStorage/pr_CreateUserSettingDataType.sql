CREATE PROCEDURE [dbo].[pr_CreateUserSettingDataType]
                ( @Id int,
                  @Name nvarchar(max))
AS

DECLARE @ReturnCode int = 2;
DECLARE @TranCount int = @@TRANCOUNT;
DECLARE @RowId TABLE (ID int);

	BEGIN TRY
		INSERT [SettingsStorage].[dbo].[tb_UserSettingDataType]
			  ([Id],
               [Name])
	    OUTPUT INSERTED.Id
		  INTO @RowId(ID)
		VALUES
		    (@Id,
             @Name)

		SET @ReturnCode = 0;

	 SELECT ID as [RowID]
	   FROM @RowId;

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