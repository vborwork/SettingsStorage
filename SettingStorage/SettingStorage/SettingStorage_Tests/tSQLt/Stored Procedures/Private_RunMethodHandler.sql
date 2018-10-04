CREATE PROCEDURE tSQLt.Private_RunMethodHandler
@RunMethod NVARCHAR (MAX), @TestResultFormatter NVARCHAR (MAX)=NULL, @TestName NVARCHAR (MAX)=NULL
AS
BEGIN
    SELECT @TestResultFormatter = ISNULL(@TestResultFormatter, tSQLt.GetTestResultFormatter());
    EXECUTE tSQLt.Private_Init ;
    IF (@@ERROR = 0)
        BEGIN
            IF (EXISTS (SELECT *
                        FROM   sys.parameters AS P
                        WHERE  P.object_id = OBJECT_ID(@RunMethod)
                               AND name = '@TestName'))
                BEGIN
                    EXECUTE @RunMethod @TestName = @TestName, @TestResultFormatter = @TestResultFormatter;
                END
            ELSE
                BEGIN
                    EXECUTE @RunMethod @TestResultFormatter = @TestResultFormatter;
                END
        END
END

