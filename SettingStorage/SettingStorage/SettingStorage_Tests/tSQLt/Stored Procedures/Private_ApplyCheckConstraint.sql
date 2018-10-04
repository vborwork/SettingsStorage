CREATE PROCEDURE tSQLt.Private_ApplyCheckConstraint
@ConstraintObjectId INT
AS
BEGIN
    DECLARE @Cmd AS NVARCHAR (MAX);
    SELECT @Cmd = 'CONSTRAINT ' + QUOTENAME(name) + ' CHECK' + definition
    FROM   sys.check_constraints
    WHERE  object_id = @ConstraintObjectId;
    DECLARE @QuotedTableName AS NVARCHAR (MAX);
    SELECT @QuotedTableName = QuotedTableName
    FROM   tSQLt.Private_GetQuotedTableNameForConstraint(@ConstraintObjectId);
    EXECUTE tSQLt.Private_RenameObjectToUniqueNameUsingObjectId @ConstraintObjectId;
    SELECT @Cmd = 'ALTER TABLE ' + @QuotedTableName + ' ADD ' + @Cmd
    FROM   sys.objects
    WHERE  object_id = @ConstraintObjectId;
    EXECUTE (@Cmd);
END

