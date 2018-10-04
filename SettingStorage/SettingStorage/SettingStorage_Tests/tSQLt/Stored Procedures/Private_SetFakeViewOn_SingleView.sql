CREATE PROCEDURE [tSQLt].[Private_SetFakeViewOn_SingleView]
@ViewName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @Cmd AS NVARCHAR (MAX), @SchemaName AS NVARCHAR (MAX), @TriggerName AS NVARCHAR (MAX);
    SELECT @SchemaName = OBJECT_SCHEMA_NAME(ObjId),
           @ViewName = OBJECT_NAME(ObjId),
           @TriggerName = OBJECT_NAME(ObjId) + '_SetFakeViewOn'
    FROM   (SELECT OBJECT_ID(@ViewName) AS ObjId) AS X;
    SET @Cmd = 'CREATE TRIGGER $$SCHEMA_NAME$$.$$TRIGGER_NAME$$
      ON $$SCHEMA_NAME$$.$$VIEW_NAME$$ INSTEAD OF INSERT AS
      BEGIN
         RAISERROR(''Test system is in an invalid state. SetFakeViewOff must be called if SetFakeViewOn was called. Call SetFakeViewOff after creating all test case procedures.'', 16, 10) WITH NOWAIT;
         RETURN;
      END;
     ';
    SET @Cmd = REPLACE(@Cmd, '$$SCHEMA_NAME$$', QUOTENAME(@SchemaName));
    SET @Cmd = REPLACE(@Cmd, '$$VIEW_NAME$$', QUOTENAME(@ViewName));
    SET @Cmd = REPLACE(@Cmd, '$$TRIGGER_NAME$$', QUOTENAME(@TriggerName));
    EXECUTE (@Cmd);
    EXECUTE sp_addextendedproperty @name = N'SetFakeViewOnTrigger', @value = 1, @level0type = 'SCHEMA', @level0name = @SchemaName, @level1type = 'VIEW', @level1name = @ViewName, @level2type = 'TRIGGER', @level2name = @TriggerName;
    RETURN 0;
END

