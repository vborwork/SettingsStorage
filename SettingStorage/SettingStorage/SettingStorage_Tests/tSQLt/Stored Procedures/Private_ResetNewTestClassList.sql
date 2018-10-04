CREATE PROCEDURE tSQLt.Private_ResetNewTestClassList
AS
BEGIN
    SET NOCOUNT ON;
    DELETE tSQLt.Private_NewTestClassList;
END

