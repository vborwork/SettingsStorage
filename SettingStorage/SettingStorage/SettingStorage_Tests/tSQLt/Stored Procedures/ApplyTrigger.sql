CREATE PROCEDURE tSQLt.ApplyTrigger
@TableName NVARCHAR (MAX), @TriggerName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @OrgTableObjectId AS INT;
    SELECT @OrgTableObjectId = OrgTableObjectId
    FROM   tSQLt.Private_GetOriginalTableInfo(OBJECT_ID(@TableName)) AS orgTbl;
    IF (@OrgTableObjectId IS NULL)
        BEGIN
            RAISERROR ('%s does not exist or was not faked by tSQLt.FakeTable.', 16, 10, @TableName);
        END
    DECLARE @FullTriggerName AS NVARCHAR (MAX);
    DECLARE @TriggerObjectId AS INT;
    SELECT @FullTriggerName = QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name),
           @TriggerObjectId = object_id
    FROM   sys.objects
    WHERE  PARSENAME(@TriggerName, 1) = name
           AND parent_object_id = @OrgTableObjectId;
    DECLARE @TriggerCode AS NVARCHAR (MAX);
    SELECT @TriggerCode = m.definition
    FROM   sys.sql_modules AS m
    WHERE  m.object_id = @TriggerObjectId;
    IF (@TriggerCode IS NULL)
        BEGIN
            RAISERROR ('%s is not a trigger on %s', 16, 10, @TriggerName, @TableName);
        END
    EXECUTE tSQLt.RemoveObject @FullTriggerName;
    EXECUTE (@TriggerCode);
END

