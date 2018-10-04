CREATE FUNCTION tSQLt.Private_GetFullTypeName
(@TypeId INT, @Length INT, @Precision INT, @Scale INT, @CollationName NVARCHAR (MAX))
RETURNS TABLE 
AS
RETURN 
    SELECT X.SchemaName + '.' + X.Name + X.Suffix + X.Collation AS TypeName,
           X.SchemaName,
           X.Name,
           X.Suffix,
           X.is_table_type AS IsTableType
    FROM   (SELECT QUOTENAME(SCHEMA_NAME(T.schema_id)) AS SchemaName,
                   QUOTENAME(T.name) AS Name,
                   CASE WHEN T.max_length = -1 THEN '' WHEN @Length = -1 THEN '(MAX)' WHEN T.name LIKE 'n%char' THEN '(' + CAST (@Length / 2 AS NVARCHAR) + ')' WHEN T.name LIKE '%char'
                                                                                                                                                                     OR T.name LIKE '%binary' THEN '(' + CAST (@Length AS NVARCHAR) + ')' WHEN T.name IN ('decimal', 'numeric') THEN '(' + CAST (@Precision AS NVARCHAR) + ',' + CAST (@Scale AS NVARCHAR) + ')' ELSE '' END AS Suffix,
                   CASE WHEN @CollationName IS NULL
                             OR T.is_user_defined = 1 THEN '' ELSE ' COLLATE ' + @CollationName END AS Collation,
                   T.is_table_type
            FROM   tSQLt.Private_SysTypes AS T
            WHERE  T.user_type_id = @TypeId) AS X


