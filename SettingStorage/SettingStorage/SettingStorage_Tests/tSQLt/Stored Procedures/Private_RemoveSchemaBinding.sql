CREATE PROCEDURE tSQLt.Private_RemoveSchemaBinding
@object_id INT
AS
BEGIN
    DECLARE @cmd AS NVARCHAR (MAX);
    SELECT @cmd = tSQLt.[Private]::GetAlterStatementWithoutSchemaBinding(SM.definition)
    FROM   sys.sql_modules AS SM
    WHERE  SM.object_id = @object_id;
    EXECUTE (@cmd);
END

