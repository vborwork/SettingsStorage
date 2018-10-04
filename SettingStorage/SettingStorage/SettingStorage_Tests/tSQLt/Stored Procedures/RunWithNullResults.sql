CREATE PROCEDURE tSQLt.RunWithNullResults
@TestName NVARCHAR (MAX)=NULL
AS
BEGIN
    EXECUTE tSQLt.Run @TestName = @TestName, @TestResultFormatter = 'tSQLt.NullTestResultFormatter';
END

