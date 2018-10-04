CREATE PROCEDURE tSQLt.AssertEqualsTable
@Expected NVARCHAR (MAX), @Actual NVARCHAR (MAX), @Message NVARCHAR (MAX)=NULL, @FailMsg NVARCHAR (MAX)='Unexpected/missing resultset rows!'
AS
BEGIN
    EXECUTE tSQLt.AssertObjectExists @Expected;
    EXECUTE tSQLt.AssertObjectExists @Actual;
    DECLARE @ResultTable AS NVARCHAR (MAX);
    DECLARE @ResultColumn AS NVARCHAR (MAX);
    DECLARE @ColumnList AS NVARCHAR (MAX);
    DECLARE @UnequalRowsExist AS INT;
    DECLARE @CombinedMessage AS NVARCHAR (MAX);
    SELECT @ResultTable = tSQLt.Private::CreateUniqueObjectName();
    SELECT @ResultColumn = 'RC_' + @ResultTable;
    EXECUTE tSQLt.Private_CreateResultTableForCompareTables @ResultTable = @ResultTable, @ResultColumn = @ResultColumn, @BaseTable = @Expected;
    SELECT @ColumnList = tSQLt.Private_GetCommaSeparatedColumnList(@ResultTable, @ResultColumn);
    EXECUTE tSQLt.Private_ValidateThatAllDataTypesInTableAreSupported @ResultTable, @ColumnList;
    EXECUTE @UnequalRowsExist = tSQLt.Private_CompareTables @Expected = @Expected, @Actual = @Actual, @ResultTable = @ResultTable, @ColumnList = @ColumnList, @MatchIndicatorColumnName = @ResultColumn;
    SET @CombinedMessage = ISNULL(@Message + CHAR(13) + CHAR(10), '') + @FailMsg;
    EXECUTE tSQLt.Private_CompareTablesFailIfUnequalRowsExists @UnequalRowsExist = @UnequalRowsExist, @ResultTable = @ResultTable, @ResultColumn = @ResultColumn, @ColumnList = @ColumnList, @FailMsg = @CombinedMessage;
END

