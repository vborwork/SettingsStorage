CREATE PROCEDURE tSQLt.Private_CreateProcedureSpy
@ProcedureObjectId INT, @OriginalProcedureName NVARCHAR (MAX), @LogTableName NVARCHAR (MAX), @CommandToExecute NVARCHAR (MAX)=NULL
AS
BEGIN
    DECLARE @Cmd AS NVARCHAR (MAX);
    DECLARE @ProcParmList AS NVARCHAR (MAX), @TableColList AS NVARCHAR (MAX), @ProcParmTypeList AS NVARCHAR (MAX), @TableColTypeList AS NVARCHAR (MAX);
    DECLARE @Seperator AS CHAR (1), @ProcParmTypeListSeparater AS CHAR (1), @ParamName AS sysname, @TypeName AS sysname, @IsOutput AS BIT, @IsCursorRef AS BIT, @IsTableType AS BIT;
    SELECT @Seperator = '',
           @ProcParmTypeListSeparater = '',
           @ProcParmList = '',
           @TableColList = '',
           @ProcParmTypeList = '',
           @TableColTypeList = '';
    DECLARE Parameters CURSOR
        FOR SELECT p.name,
                   t.TypeName,
                   p.is_output,
                   p.is_cursor_ref,
                   t.IsTableType
            FROM   sys.parameters AS p CROSS APPLY tSQLt.Private_GetFullTypeName(p.user_type_id, p.max_length, p.precision, p.scale, NULL) AS t
            WHERE  object_id = @ProcedureObjectId;
    OPEN Parameters;
    FETCH NEXT FROM Parameters INTO @ParamName, @TypeName, @IsOutput, @IsCursorRef, @IsTableType;
    WHILE (@@FETCH_STATUS = 0)
        BEGIN
            IF @IsCursorRef = 0
                BEGIN
                    SELECT @ProcParmList = @ProcParmList + @Seperator + CASE WHEN @IsTableType = 1 THEN '(SELECT * FROM ' + @ParamName + ' FOR XML PATH(''row''),TYPE,ROOT(''' + STUFF(@ParamName, 1, 1, '') + '''))' ELSE @ParamName END,
                           @TableColList = @TableColList + @Seperator + '[' + STUFF(@ParamName, 1, 1, '') + ']',
                           @ProcParmTypeList = @ProcParmTypeList + @ProcParmTypeListSeparater + @ParamName + ' ' + @TypeName + CASE WHEN @IsTableType = 1 THEN ' READONLY' ELSE ' = NULL ' END + CASE WHEN @IsOutput = 1 THEN ' OUT' ELSE '' END,
                           @TableColTypeList = @TableColTypeList + ',[' + STUFF(@ParamName, 1, 1, '') + '] ' + CASE WHEN @IsTableType = 1 THEN 'XML' WHEN @TypeName LIKE '%nchar%'
                                                                                                                                                          OR @TypeName LIKE '%nvarchar%' THEN 'NVARCHAR(MAX)' WHEN @TypeName LIKE '%char%' THEN 'VARCHAR(MAX)' ELSE @TypeName END + ' NULL';
                    SELECT @Seperator = ',';
                    SELECT @ProcParmTypeListSeparater = ',';
                END
            ELSE
                BEGIN
                    SELECT @ProcParmTypeList = @ProcParmTypeListSeparater + @ParamName + ' CURSOR VARYING OUTPUT';
                    SELECT @ProcParmTypeListSeparater = ',';
                END
            FETCH NEXT FROM Parameters INTO @ParamName, @TypeName, @IsOutput, @IsCursorRef, @IsTableType;
        END
    CLOSE Parameters;
    DEALLOCATE Parameters;
    DECLARE @InsertStmt AS NVARCHAR (MAX);
    SELECT @InsertStmt = 'INSERT INTO ' + @LogTableName + CASE WHEN @TableColList = '' THEN ' DEFAULT VALUES' ELSE ' (' + @TableColList + ') SELECT ' + @ProcParmList END + ';';
    SELECT @Cmd = 'CREATE TABLE ' + @LogTableName + ' (_id_ int IDENTITY(1,1) PRIMARY KEY CLUSTERED ' + @TableColTypeList + ');';
    EXECUTE (@Cmd);
    SELECT @Cmd = 'CREATE PROCEDURE ' + @OriginalProcedureName + ' ' + @ProcParmTypeList + ' AS BEGIN ' + @InsertStmt + ISNULL(@CommandToExecute, '') + ';' + ' END;';
    EXECUTE (@Cmd);
    RETURN 0;
END

