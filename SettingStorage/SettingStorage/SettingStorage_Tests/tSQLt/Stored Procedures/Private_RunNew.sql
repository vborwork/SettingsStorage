CREATE PROCEDURE tSQLt.Private_RunNew
@TestResultFormatter NVARCHAR (MAX)
AS
BEGIN
    EXECUTE tSQLt.Private_RunCursor @TestResultFormatter = @TestResultFormatter, @GetCursorCallback = 'tSQLt.Private_GetCursorForRunNew';
END

