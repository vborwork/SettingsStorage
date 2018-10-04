CREATE PROCEDURE tSQLt.RunTestClass
@TestClassName NVARCHAR (MAX)
AS
BEGIN
    EXECUTE tSQLt.Run @TestClassName;
END

