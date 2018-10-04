CREATE PROCEDURE [tSQLt].[Private_SetFakeViewOff_SingleView]
@ViewName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @Cmd AS NVARCHAR (MAX), @SchemaName AS NVARCHAR (MAX), @TriggerName AS NVARCHAR (MAX);
    SELECT @SchemaName = QUOTENAME(OBJECT_SCHEMA_NAME(ObjId)),
           @TriggerName = QUOTENAME(OBJECT_NAME(ObjId) + '_SetFakeViewOn')
    FROM   (SELECT OBJECT_ID(@ViewName) AS ObjId) AS X;
    SET @Cmd = 'DROP TRIGGER %SCHEMA_NAME%.%TRIGGER_NAME%;';
    SET @Cmd = REPLACE(@Cmd, '%SCHEMA_NAME%', @SchemaName);
    SET @Cmd = REPLACE(@Cmd, '%TRIGGER_NAME%', @TriggerName);
    EXECUTE (@Cmd);
END

