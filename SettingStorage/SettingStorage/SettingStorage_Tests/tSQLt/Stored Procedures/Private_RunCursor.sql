CREATE PROCEDURE tSQLt.Private_RunCursor
@TestResultFormatter NVARCHAR (MAX), @GetCursorCallback NVARCHAR (MAX)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @TestClassName AS NVARCHAR (MAX);
    DECLARE @TestProcName AS NVARCHAR (MAX);
    DECLARE @TestClassCursor AS CURSOR;
    EXECUTE @GetCursorCallback @TestClassCursor = @TestClassCursor OUTPUT;
    WHILE (1 = 1)
        BEGIN
            FETCH NEXT FROM @TestClassCursor INTO @TestClassName;
            IF (@@FETCH_STATUS <> 0)
                BREAK;
            EXECUTE tSQLt.Private_RunTestClass @TestClassName;
        END
    CLOSE @TestClassCursor;
    DEALLOCATE @TestClassCursor;
    EXECUTE tSQLt.Private_OutputTestResults @TestResultFormatter;
END

