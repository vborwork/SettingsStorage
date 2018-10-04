CREATE PROCEDURE tSQLt.SetVerbose
@Verbose BIT=1
AS
BEGIN
    EXECUTE tSQLt.Private_SetConfiguration @Name = 'Verbose', @Value = @Verbose;
END

