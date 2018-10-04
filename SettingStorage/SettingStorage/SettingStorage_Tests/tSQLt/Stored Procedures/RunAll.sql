CREATE PROCEDURE tSQLt.RunAll
AS
BEGIN
    EXECUTE tSQLt.Private_RunMethodHandler @RunMethod = 'tSQLt.Private_RunAll';
END

