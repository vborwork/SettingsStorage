CREATE PROCEDURE tSQLt.Private_RunAll
@TestResultFormatter NVARCHAR (MAX)
AS
BEGIN
    EXECUTE tSQLt.Private_RunCursor @TestResultFormatter = @TestResultFormatter, @GetCursorCallback = 'tSQLt.Private_GetCursorForRunAll';
END

