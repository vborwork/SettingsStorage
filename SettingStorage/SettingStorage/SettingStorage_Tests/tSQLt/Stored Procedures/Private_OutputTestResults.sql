CREATE PROCEDURE tSQLt.Private_OutputTestResults
@TestResultFormatter NVARCHAR (MAX)=NULL
AS
BEGIN
    DECLARE @Formatter AS NVARCHAR (MAX);
    SELECT @Formatter = COALESCE (@TestResultFormatter, tSQLt.GetTestResultFormatter());
    EXECUTE (@Formatter);
END

