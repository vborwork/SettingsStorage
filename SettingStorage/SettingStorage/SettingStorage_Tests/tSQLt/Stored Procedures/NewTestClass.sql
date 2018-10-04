CREATE PROCEDURE tSQLt.NewTestClass
@ClassName NVARCHAR (MAX)
AS
BEGIN
    BEGIN TRY
        EXECUTE tSQLt.Private_DisallowOverwritingNonTestSchema @ClassName;
        EXECUTE tSQLt.DropClass @ClassName = @ClassName;
        DECLARE @QuotedClassName AS NVARCHAR (MAX);
        SELECT @QuotedClassName = tSQLt.Private_QuoteClassNameForNewTestClass(@ClassName);
        EXECUTE ('CREATE SCHEMA ' + @QuotedClassName);
        EXECUTE tSQLt.Private_MarkSchemaAsTestClass @QuotedClassName;
    END TRY
    BEGIN CATCH
        DECLARE @ErrMsg AS NVARCHAR (MAX);
        SET @ErrMsg = ERROR_MESSAGE() + ' (Error originated in ' + ERROR_PROCEDURE() + ')';
        DECLARE @ErrSvr AS INT;
        SET @ErrSvr = ERROR_SEVERITY();
        RAISERROR (@ErrMsg, @ErrSvr, 10);
    END CATCH
END

