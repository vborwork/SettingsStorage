CREATE PROCEDURE tSQLt.RunWithXmlResults
@TestName NVARCHAR (MAX)=NULL
AS
BEGIN
    EXECUTE tSQLt.Run @TestName = @TestName, @TestResultFormatter = 'tSQLt.XmlResultFormatter';
END

