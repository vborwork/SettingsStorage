CREATE PROCEDURE tSQLt.Private_RenameObjectToUniqueName
@SchemaName NVARCHAR (MAX), @ObjectName NVARCHAR (MAX), @NewName NVARCHAR (MAX)=NULL OUTPUT
AS
BEGIN
    SET @NewName = tSQLt.Private::CreateUniqueObjectName();
    DECLARE @RenameCmd AS NVARCHAR (MAX);
    SET @RenameCmd = 'EXEC sp_rename ''' + @SchemaName + '.' + @ObjectName + ''', ''' + @NewName + ''';';
    EXECUTE tSQLt.Private_MarkObjectBeforeRename @SchemaName, @ObjectName;
    EXECUTE tSQLt.SuppressOutput @RenameCmd;
END

