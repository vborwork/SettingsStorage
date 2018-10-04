CREATE PROCEDURE tSQLt.DefaultResultFormatter
AS
BEGIN
    DECLARE @Msg1 AS NVARCHAR (MAX);
    DECLARE @Msg2 AS NVARCHAR (MAX);
    DECLARE @Msg3 AS NVARCHAR (MAX);
    DECLARE @Msg4 AS NVARCHAR (MAX);
    DECLARE @IsSuccess AS INT;
    DECLARE @SuccessCnt AS INT;
    DECLARE @Severity AS INT;
    SELECT ROW_NUMBER() OVER (ORDER BY Result DESC, Name ASC) AS No,
           Name AS [Test Case Name],
           RIGHT(SPACE(7) + CAST (DATEDIFF(MILLISECOND, TestStartTime, TestEndTime) AS VARCHAR (7)), 7) AS [Dur(ms)],
           Result
    INTO   #TestResultOutput
    FROM   tSQLt.TestResult;
    EXECUTE tSQLt.TableToText @Msg1 OUTPUT, '#TestResultOutput', 'No';
    SELECT @Msg3 = Msg,
           @IsSuccess = 1 - SIGN(FailCnt + ErrorCnt),
           @SuccessCnt = SuccessCnt
    FROM   tSQLt.TestCaseSummary();
    SELECT @Severity = 16 * (1 - @IsSuccess);
    SELECT @Msg2 = REPLICATE('-', LEN(@Msg3)),
           @Msg4 = CHAR(13) + CHAR(10);
    EXECUTE tSQLt.Private_Print @Msg4, 0;
    EXECUTE tSQLt.Private_Print '+----------------------+', 0;
    EXECUTE tSQLt.Private_Print '|Test Execution Summary|', 0;
    EXECUTE tSQLt.Private_Print '+----------------------+', 0;
    EXECUTE tSQLt.Private_Print @Msg4, 0;
    EXECUTE tSQLt.Private_Print @Msg1, 0;
    EXECUTE tSQLt.Private_Print @Msg2, 0;
    EXECUTE tSQLt.Private_Print @Msg3, @Severity;
    EXECUTE tSQLt.Private_Print @Msg2, 0;
END

