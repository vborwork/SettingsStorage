CREATE PROCEDURE tSQLt.SpyProcedure
@ProcedureName NVARCHAR (MAX), @CommandToExecute NVARCHAR (MAX)=NULL
AS
BEGIN
    DECLARE @ProcedureObjectId AS INT;
    SELECT @ProcedureObjectId = OBJECT_ID(@ProcedureName);
    EXECUTE tSQLt.Private_ValidateProcedureCanBeUsedWithSpyProcedure @ProcedureName;
    DECLARE @LogTableName AS NVARCHAR (MAX);
    SELECT @LogTableName = QUOTENAME(OBJECT_SCHEMA_NAME(@ProcedureObjectId)) + '.' + QUOTENAME(OBJECT_NAME(@ProcedureObjectId) + '_SpyProcedureLog');
    EXECUTE tSQLt.Private_RenameObjectToUniqueNameUsingObjectId @ProcedureObjectId;
    EXECUTE tSQLt.Private_CreateProcedureSpy @ProcedureObjectId, @ProcedureName, @LogTableName, @CommandToExecute;
    RETURN 0;
END

