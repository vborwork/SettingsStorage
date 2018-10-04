CREATE PROCEDURE tSQLt.Private_CompareTablesFailIfUnequalRowsExists
@UnequalRowsExist INT, @ResultTable NVARCHAR (MAX), @ResultColumn NVARCHAR (MAX), @ColumnList NVARCHAR (MAX), @FailMsg NVARCHAR (MAX)
AS
BEGIN
    IF @UnequalRowsExist > 0
        BEGIN
            DECLARE @TableToTextResult AS NVARCHAR (MAX);
            DECLARE @OutputColumnList AS NVARCHAR (MAX);
            SELECT @OutputColumnList = '[_m_],' + @ColumnList;
            EXECUTE tSQLt.TableToText @TableName = @ResultTable, @OrderBy = @ResultColumn, @PrintOnlyColumnNameAliasList = @OutputColumnList, @txt = @TableToTextResult OUTPUT;
            DECLARE @Message AS NVARCHAR (MAX);
            SELECT @Message = @FailMsg + CHAR(13) + CHAR(10);
            EXECUTE tSQLt.Fail @Message, @TableToTextResult;
        END
END

