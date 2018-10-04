CREATE PROCEDURE tSQLt.Private_CreateResultTableForCompareTables
@ResultTable NVARCHAR (MAX), @ResultColumn NVARCHAR (MAX), @BaseTable NVARCHAR (MAX)
AS
BEGIN
    DECLARE @Cmd AS NVARCHAR (MAX);
    SET @Cmd = '
     SELECT ''='' AS ' + @ResultColumn + ', Expected.* INTO ' + @ResultTable + ' 
       FROM tSQLt.Private_NullCellTable N 
       LEFT JOIN ' + @BaseTable + ' AS Expected ON N.I <> N.I 
     TRUNCATE TABLE ' + @ResultTable + ';';
    EXECUTE (@Cmd);
END

