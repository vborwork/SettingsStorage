CREATE PROCEDURE tSQLt.AssertEmptyTable
@TableName NVARCHAR (MAX), @Message NVARCHAR (MAX)=''
AS
BEGIN
    EXECUTE tSQLt.AssertObjectExists @TableName;
    DECLARE @FullName AS NVARCHAR (MAX);
    IF (OBJECT_ID(@TableName) IS NULL
        AND OBJECT_ID('tempdb..' + @TableName) IS NOT NULL)
        BEGIN
            SET @FullName = CASE WHEN LEFT(@TableName, 1) = '[' THEN @TableName ELSE QUOTENAME(@TableName) END;
        END
    ELSE
        BEGIN
            SET @FullName = tSQLt.Private_GetQuotedFullName(OBJECT_ID(@TableName));
        END
    DECLARE @cmd AS NVARCHAR (MAX);
    DECLARE @exists AS INT;
    SET @cmd = 'SELECT @exists = CASE WHEN EXISTS(SELECT 1 FROM ' + @FullName + ') THEN 1 ELSE 0 END;';
    EXECUTE sp_executesql @cmd, N'@exists INT OUTPUT', @exists OUTPUT;
    IF (@exists = 1)
        BEGIN
            DECLARE @TableToText AS NVARCHAR (MAX);
            EXECUTE tSQLt.TableToText @TableName = @FullName, @txt = @TableToText OUTPUT;
            DECLARE @Msg AS NVARCHAR (MAX);
            SET @Msg = @FullName + ' was not empty:' + CHAR(13) + CHAR(10) + @TableToText;
            EXECUTE tSQLt.Fail @Message, @Msg;
        END
END

