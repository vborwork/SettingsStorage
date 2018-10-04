CREATE PROCEDURE tSQLt.Private_RunTest
@TestName NVARCHAR (MAX), @SetUp NVARCHAR (MAX)=NULL
AS
BEGIN
    DECLARE @Msg AS NVARCHAR (MAX);
    SET @Msg = '';
    DECLARE @Msg2 AS NVARCHAR (MAX);
    SET @Msg2 = '';
    DECLARE @Cmd AS NVARCHAR (MAX);
    SET @Cmd = '';
    DECLARE @TestClassName AS NVARCHAR (MAX);
    SET @TestClassName = '';
    DECLARE @TestProcName AS NVARCHAR (MAX);
    SET @TestProcName = '';
    DECLARE @Result AS NVARCHAR (MAX);
    SET @Result = 'Success';
    DECLARE @TranName AS CHAR (32);
    EXECUTE tSQLt.GetNewTranName @TranName OUTPUT;
    DECLARE @TestResultId AS INT;
    DECLARE @PreExecTrancount AS INT;
    DECLARE @VerboseMsg AS NVARCHAR (MAX);
    DECLARE @Verbose AS BIT;
    SET @Verbose = ISNULL((SELECT CAST (Value AS BIT)
                           FROM   tSQLt.Private_GetConfiguration('Verbose')), 0);
    TRUNCATE TABLE tSQLt.CaptureOutputLog;
    CREATE TABLE #ExpectException (
        ExpectException        INT           ,
        ExpectedMessage        NVARCHAR (MAX),
        ExpectedSeverity       INT           ,
        ExpectedState          INT           ,
        ExpectedMessagePattern NVARCHAR (MAX),
        ExpectedErrorNumber    INT           ,
        FailMessage            NVARCHAR (MAX)
    );
    IF EXISTS (SELECT 1
               FROM   sys.extended_properties
               WHERE  name = N'SetFakeViewOnTrigger')
        BEGIN
            RAISERROR ('Test system is in an invalid state. SetFakeViewOff must be called if SetFakeViewOn was called. Call SetFakeViewOff after creating all test case procedures.', 16, 10)
                WITH NOWAIT;
            RETURN -1;
        END
    SELECT @Cmd = 'EXEC ' + @TestName;
    SELECT @TestClassName = OBJECT_SCHEMA_NAME(OBJECT_ID(@TestName)),
           @TestProcName = tSQLt.Private_GetCleanObjectName(@TestName);
    INSERT INTO tSQLt.TestResult (Class, TestCase, TranName, Result)
    SELECT @TestClassName,
           @TestProcName,
           @TranName,
           'A severe error happened during test execution. Test did not finish.'
    OPTION (MAXDOP 1);
    SELECT @TestResultId = SCOPE_IDENTITY();
    IF (@Verbose = 1)
        BEGIN
            SET @VerboseMsg = 'tSQLt.Run ''' + @TestName + '''; --Starting';
            EXECUTE tSQLt.Private_Print @Message = @VerboseMsg, @Severity = 0;
        END
    BEGIN TRANSACTION;
    SAVE TRANSACTION @TranName;
    SET @PreExecTrancount = @@TRANCOUNT;
    TRUNCATE TABLE tSQLt.TestMessage;
    DECLARE @TmpMsg AS NVARCHAR (MAX);
    DECLARE @TestEndTime AS DATETIME;
    SET @TestEndTime = NULL;
    BEGIN TRY
        IF (@SetUp IS NOT NULL)
            EXECUTE @SetUp ;
        EXECUTE (@Cmd);
        SET @TestEndTime = GETDATE();
        IF (EXISTS (SELECT 1
                    FROM   #ExpectException
                    WHERE  ExpectException = 1))
            BEGIN
                SET @TmpMsg = COALESCE ((SELECT FailMessage
                                         FROM   #ExpectException) + ' ', '') + 'Expected an error to be raised.';
                EXECUTE tSQLt.Fail @TmpMsg;
            END
    END TRY
    BEGIN CATCH
        SET @TestEndTime = ISNULL(@TestEndTime, GETDATE());
        IF ERROR_MESSAGE() LIKE '%tSQLt.Failure%'
            BEGIN
                SELECT @Msg = Msg
                FROM   tSQLt.TestMessage;
                SET @Result = 'Failure';
            END
        ELSE
            BEGIN
                DECLARE @ErrorInfo AS NVARCHAR (MAX);
                SELECT @ErrorInfo = COALESCE (ERROR_MESSAGE(), '<ERROR_MESSAGE() is NULL>') + '[' + COALESCE (LTRIM(STR(ERROR_SEVERITY())), '<ERROR_SEVERITY() is NULL>') + ',' + COALESCE (LTRIM(STR(ERROR_STATE())), '<ERROR_STATE() is NULL>') + ']' + '{' + COALESCE (ERROR_PROCEDURE(), '<ERROR_PROCEDURE() is NULL>') + ',' + COALESCE (CAST (ERROR_LINE() AS NVARCHAR), '<ERROR_LINE() is NULL>') + '}';
                IF (EXISTS (SELECT 1
                            FROM   #ExpectException))
                    BEGIN
                        DECLARE @ExpectException AS INT;
                        DECLARE @ExpectedMessage AS NVARCHAR (MAX);
                        DECLARE @ExpectedMessagePattern AS NVARCHAR (MAX);
                        DECLARE @ExpectedSeverity AS INT;
                        DECLARE @ExpectedState AS INT;
                        DECLARE @ExpectedErrorNumber AS INT;
                        DECLARE @FailMessage AS NVARCHAR (MAX);
                        SELECT @ExpectException = ExpectException,
                               @ExpectedMessage = ExpectedMessage,
                               @ExpectedSeverity = ExpectedSeverity,
                               @ExpectedState = ExpectedState,
                               @ExpectedMessagePattern = ExpectedMessagePattern,
                               @ExpectedErrorNumber = ExpectedErrorNumber,
                               @FailMessage = FailMessage
                        FROM   #ExpectException;
                        IF (@ExpectException = 1)
                            BEGIN
                                SET @Result = 'Success';
                                SET @TmpMsg = COALESCE (@FailMessage + ' ', '') + 'Exception did not match expectation!';
                                IF (ERROR_MESSAGE() <> @ExpectedMessage)
                                    BEGIN
                                        SET @TmpMsg = @TmpMsg + CHAR(13) + CHAR(10) + 'Expected Message: <' + @ExpectedMessage + '>' + CHAR(13) + CHAR(10) + 'Actual Message  : <' + ERROR_MESSAGE() + '>';
                                        SET @Result = 'Failure';
                                    END
                                IF (ERROR_MESSAGE() NOT LIKE @ExpectedMessagePattern)
                                    BEGIN
                                        SET @TmpMsg = @TmpMsg + CHAR(13) + CHAR(10) + 'Expected Message to be like <' + @ExpectedMessagePattern + '>' + CHAR(13) + CHAR(10) + 'Actual Message            : <' + ERROR_MESSAGE() + '>';
                                        SET @Result = 'Failure';
                                    END
                                IF (ERROR_NUMBER() <> @ExpectedErrorNumber)
                                    BEGIN
                                        SET @TmpMsg = @TmpMsg + CHAR(13) + CHAR(10) + 'Expected Error Number: ' + CAST (@ExpectedErrorNumber AS NVARCHAR (MAX)) + CHAR(13) + CHAR(10) + 'Actual Error Number  : ' + CAST (ERROR_NUMBER() AS NVARCHAR (MAX));
                                        SET @Result = 'Failure';
                                    END
                                IF (ERROR_SEVERITY() <> @ExpectedSeverity)
                                    BEGIN
                                        SET @TmpMsg = @TmpMsg + CHAR(13) + CHAR(10) + 'Expected Severity: ' + CAST (@ExpectedSeverity AS NVARCHAR (MAX)) + CHAR(13) + CHAR(10) + 'Actual Severity  : ' + CAST (ERROR_SEVERITY() AS NVARCHAR (MAX));
                                        SET @Result = 'Failure';
                                    END
                                IF (ERROR_STATE() <> @ExpectedState)
                                    BEGIN
                                        SET @TmpMsg = @TmpMsg + CHAR(13) + CHAR(10) + 'Expected State: ' + CAST (@ExpectedState AS NVARCHAR (MAX)) + CHAR(13) + CHAR(10) + 'Actual State  : ' + CAST (ERROR_STATE() AS NVARCHAR (MAX));
                                        SET @Result = 'Failure';
                                    END
                                IF (@Result = 'Failure')
                                    BEGIN
                                        SET @Msg = @TmpMsg;
                                    END
                            END
                        ELSE
                            BEGIN
                                SET @Result = 'Failure';
                                SET @Msg = COALESCE (@FailMessage + ' ', '') + 'Expected no error to be raised. Instead this error was encountered:' + CHAR(13) + CHAR(10) + @ErrorInfo;
                            END
                    END
                ELSE
                    BEGIN
                        SET @Result = 'Error';
                        SET @Msg = @ErrorInfo;
                    END
            END
    END CATCH
    BEGIN TRY
        ROLLBACK TRANSACTION @TranName;
    END TRY
    BEGIN CATCH
        DECLARE @PostExecTrancount AS INT;
        SET @PostExecTrancount = @PreExecTrancount - @@TRANCOUNT;
        IF (@@TRANCOUNT > 0)
            ROLLBACK;
        BEGIN TRANSACTION;
        IF (@Result <> 'Success'
            OR @PostExecTrancount <> 0)
            BEGIN
                SELECT @Msg = COALESCE (@Msg, '<NULL>') + ' (There was also a ROLLBACK ERROR --> ' + COALESCE (ERROR_MESSAGE(), '<ERROR_MESSAGE() is NULL>') + '{' + COALESCE (ERROR_PROCEDURE(), '<ERROR_PROCEDURE() is NULL>') + ',' + COALESCE (CAST (ERROR_LINE() AS NVARCHAR), '<ERROR_LINE() is NULL>') + '})';
                SET @Result = 'Error';
            END
    END CATCH
    IF (@Result <> 'Success')
        BEGIN
            SET @Msg2 = @TestName + ' failed: (' + @Result + ') ' + @Msg;
            EXECUTE tSQLt.Private_Print @Message = @Msg2, @Severity = 0;
        END
    IF EXISTS (SELECT 1
               FROM   tSQLt.TestResult
               WHERE  Id = @TestResultId)
        BEGIN
            UPDATE tSQLt.TestResult
            SET    Result      = @Result,
                   Msg         = @Msg,
                   TestEndTime = @TestEndTime
            WHERE  Id = @TestResultId;
        END
    ELSE
        BEGIN
            INSERT tSQLt.TestResult (Class, TestCase, TranName, Result, Msg)
            SELECT @TestClassName,
                   @TestProcName,
                   '?',
                   'Error',
                   'TestResult entry is missing; Original outcome: ' + @Result + ', ' + @Msg;
        END
    COMMIT TRANSACTION;
    IF (@Verbose = 1)
        BEGIN
            SET @VerboseMsg = 'tSQLt.Run ''' + @TestName + '''; --Finished';
            EXECUTE tSQLt.Private_Print @Message = @VerboseMsg, @Severity = 0;
        END
END

