CREATE PROCEDURE tSQLt.Private_RunTestClass
@TestClassName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @TestCaseName AS NVARCHAR (MAX);
    DECLARE @TestClassId AS INT;
    SET @TestClassId = tSQLt.Private_GetSchemaId(@TestClassName);
    DECLARE @SetupProcName AS NVARCHAR (MAX);
    EXECUTE tSQLt.Private_GetSetupProcedureName @TestClassId, @SetupProcName OUTPUT;
    DECLARE testCases CURSOR LOCAL FAST_FORWARD
        FOR SELECT tSQLt.Private_GetQuotedFullName(object_id)
            FROM   sys.procedures
            WHERE  schema_id = @TestClassId
                   AND LOWER(name) LIKE 'test%';
    OPEN testCases;
    FETCH NEXT FROM testCases INTO @TestCaseName;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            EXECUTE tSQLt.Private_RunTest @TestCaseName, @SetupProcName;
            FETCH NEXT FROM testCases INTO @TestCaseName;
        END
    CLOSE testCases;
    DEALLOCATE testCases;
END

