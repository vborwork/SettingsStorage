CREATE PROCEDURE tSQLt.Private_Print
@Message NVARCHAR (MAX), @Severity INT=0
AS
BEGIN
    DECLARE @SPos AS INT;
    SET @SPos = 1;
    DECLARE @EPos AS INT;
    DECLARE @Len AS INT;
    SET @Len = LEN(@Message);
    DECLARE @SubMsg AS NVARCHAR (MAX);
    DECLARE @Cmd AS NVARCHAR (MAX);
    DECLARE @CleanedMessage AS NVARCHAR (MAX);
    SET @CleanedMessage = REPLACE(@Message, '%', '%%');
    WHILE (@SPos <= @Len)
        BEGIN
            SET @EPos = CHARINDEX(CHAR(13) + CHAR(10), @CleanedMessage + CHAR(13) + CHAR(10), @SPos);
            SET @SubMsg = SUBSTRING(@CleanedMessage, @SPos, @EPos - @SPos);
            SET @Cmd = N'RAISERROR(@Msg,@Severity,10) WITH NOWAIT;';
            EXECUTE sp_executesql @Cmd, N'@Msg NVARCHAR(MAX),@Severity INT', @SubMsg, @Severity;
            SELECT @SPos = @EPos + 2,
                   @Severity = 0;
        END
    RETURN 0;
END

