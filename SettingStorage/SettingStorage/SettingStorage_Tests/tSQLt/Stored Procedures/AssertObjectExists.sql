CREATE PROCEDURE tSQLt.AssertObjectExists
@ObjectName NVARCHAR (MAX), @Message NVARCHAR (MAX)=''
AS
BEGIN
    DECLARE @Msg AS NVARCHAR (MAX);
    IF (@ObjectName LIKE '#%')
        BEGIN
            IF OBJECT_ID('tempdb..' + @ObjectName) IS NULL
                BEGIN
                    SELECT @Msg = '''' + COALESCE (@ObjectName, 'NULL') + ''' does not exist';
                    EXECUTE tSQLt.Fail @Message, @Msg;
                    RETURN 1;
                END
        END
    ELSE
        BEGIN
            IF OBJECT_ID(@ObjectName) IS NULL
                BEGIN
                    SELECT @Msg = '''' + COALESCE (@ObjectName, 'NULL') + ''' does not exist';
                    EXECUTE tSQLt.Fail @Message, @Msg;
                    RETURN 1;
                END
        END
    RETURN 0;
END

