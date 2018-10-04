CREATE PROCEDURE tSQLt.Private_Run
@TestName NVARCHAR (MAX), @TestResultFormatter NVARCHAR (MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FullName AS NVARCHAR (MAX);
    DECLARE @TestClassId AS INT;
    DECLARE @IsTestClass AS BIT;
    DECLARE @IsTestCase AS BIT;
    DECLARE @IsSchema AS BIT;
    DECLARE @SetUp AS NVARCHAR (MAX);
    SET @SetUp = NULL;
    SELECT @TestName = tSQLt.Private_GetLastTestNameIfNotProvided(@TestName);
    EXECUTE tSQLt.Private_SaveTestNameForSession @TestName;
    SELECT @TestClassId = schemaId,
           @FullName = quotedFullName,
           @IsTestClass = isTestClass,
           @IsSchema = isSchema,
           @IsTestCase = isTestCase
    FROM   tSQLt.Private_ResolveName(@TestName);
    IF @IsSchema = 1
        BEGIN
            EXECUTE tSQLt.Private_RunTestClass @FullName;
        END
    IF @IsTestCase = 1
        BEGIN
            DECLARE @SetupProcName AS NVARCHAR (MAX);
            EXECUTE tSQLt.Private_GetSetupProcedureName @TestClassId, @SetupProcName OUTPUT;
            EXECUTE tSQLt.Private_RunTest @FullName, @SetupProcName;
        END
    EXECUTE tSQLt.Private_OutputTestResults @TestResultFormatter;
END

