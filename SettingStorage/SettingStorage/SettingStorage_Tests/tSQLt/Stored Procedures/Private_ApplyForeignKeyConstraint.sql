CREATE PROCEDURE tSQLt.Private_ApplyForeignKeyConstraint
@ConstraintObjectId INT, @NoCascade BIT
AS
BEGIN
    DECLARE @SchemaName AS NVARCHAR (MAX);
    DECLARE @OrgTableName AS NVARCHAR (MAX);
    DECLARE @TableName AS NVARCHAR (MAX);
    DECLARE @ConstraintName AS NVARCHAR (MAX);
    DECLARE @CreateFkCmd AS NVARCHAR (MAX);
    DECLARE @AlterTableCmd AS NVARCHAR (MAX);
    DECLARE @CreateIndexCmd AS NVARCHAR (MAX);
    DECLARE @FinalCmd AS NVARCHAR (MAX);
    SELECT @SchemaName = SchemaName,
           @OrgTableName = OrgTableName,
           @TableName = TableName,
           @ConstraintName = OBJECT_NAME(@ConstraintObjectId)
    FROM   tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId);
    SELECT @CreateFkCmd = cmd,
           @CreateIndexCmd = CreIdxCmd
    FROM   tSQLt.Private_GetForeignKeyDefinition(@SchemaName, @OrgTableName, @ConstraintName, @NoCascade);
    SELECT @AlterTableCmd = 'ALTER TABLE ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName) + ' ADD ' + @CreateFkCmd;
    SELECT @FinalCmd = @CreateIndexCmd + @AlterTableCmd;
    EXECUTE tSQLt.Private_RenameObjectToUniqueName @SchemaName, @ConstraintName;
    EXECUTE (@FinalCmd);
END

