CREATE PROCEDURE tSQLt.RunC
AS
BEGIN
    DECLARE @TestName AS NVARCHAR (MAX);
    SET @TestName = NULL;
    DECLARE @InputBuffer AS NVARCHAR (MAX);
    EXECUTE tSQLt.Private_InputBuffer @InputBuffer = @InputBuffer OUTPUT;
    IF (@InputBuffer LIKE 'EXEC tSQLt.RunC;--%')
        BEGIN
            SET @TestName = LTRIM(RTRIM(STUFF(@InputBuffer, 1, 18, '')));
        END
    EXECUTE tSQLt.Run @TestName = @TestName;
END

