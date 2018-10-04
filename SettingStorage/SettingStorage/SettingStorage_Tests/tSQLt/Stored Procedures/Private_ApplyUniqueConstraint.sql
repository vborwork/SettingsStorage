CREATE PROCEDURE tSQLt.Private_ApplyUniqueConstraint
@ConstraintObjectId INT
AS
BEGIN
    DECLARE @SchemaName AS NVARCHAR (MAX);
    DECLARE @OrgTableName AS NVARCHAR (MAX);
    DECLARE @TableName AS NVARCHAR (MAX);
    DECLARE @ConstraintName AS NVARCHAR (MAX);
    DECLARE @CreateConstraintCmd AS NVARCHAR (MAX);
    DECLARE @AlterColumnsCmd AS NVARCHAR (MAX);
    SELECT @SchemaName = SchemaName,
           @OrgTableName = OrgTableName,
           @TableName = TableName,
           @ConstraintName = OBJECT_NAME(@ConstraintObjectId)
    FROM   tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId);
    SELECT @AlterColumnsCmd = NotNullColumnCmd,
           @CreateConstraintCmd = CreateConstraintCmd
    FROM   tSQLt.Private_GetUniqueConstraintDefinition(@ConstraintObjectId, QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName));
    EXECUTE tSQLt.Private_RenameObjectToUniqueName @SchemaName, @ConstraintName;
    EXECUTE (@AlterColumnsCmd);
    EXECUTE (@CreateConstraintCmd);
END

