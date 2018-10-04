CREATE FUNCTION tSQLt.Private_GetQuotedTableNameForConstraint
(@ConstraintObjectId INT)
RETURNS TABLE 
AS
RETURN 
    SELECT QUOTENAME(SCHEMA_NAME(newtbl.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(newtbl.object_id)) AS QuotedTableName,
           SCHEMA_NAME(newtbl.schema_id) AS SchemaName,
           OBJECT_NAME(newtbl.object_id) AS TableName,
           OBJECT_NAME(constraints.parent_object_id) AS OrgTableName
    FROM   sys.objects AS constraints
           INNER JOIN
           sys.extended_properties AS p
           INNER JOIN
           sys.objects AS newtbl
           ON newtbl.object_id = p.major_id
              AND p.minor_id = 0
              AND p.class_desc = 'OBJECT_OR_COLUMN'
              AND p.name = 'tSQLt.FakeTable_OrgTableName'
           ON OBJECT_NAME(constraints.parent_object_id) = CAST (p.value AS NVARCHAR (4000))
              AND constraints.schema_id = newtbl.schema_id
              AND constraints.object_id = @ConstraintObjectId


