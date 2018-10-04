CREATE PROCEDURE [tSQLt].[SetFakeViewOff]
@SchemaName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @ViewName AS NVARCHAR (MAX);
    DECLARE viewNames CURSOR LOCAL FAST_FORWARD
        FOR SELECT QUOTENAME(OBJECT_SCHEMA_NAME(t.parent_id)) + '.' + QUOTENAME(OBJECT_NAME(t.parent_id)) AS viewName
            FROM   sys.extended_properties AS ep
                   INNER JOIN
                   sys.triggers AS t
                   ON ep.major_id = t.object_id
            WHERE  ep.name = N'SetFakeViewOnTrigger';
    OPEN viewNames;
    FETCH NEXT FROM viewNames INTO @ViewName;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            EXECUTE tSQLt.Private_SetFakeViewOff_SingleView @ViewName;
            FETCH NEXT FROM viewNames INTO @ViewName;
        END
    CLOSE viewNames;
    DEALLOCATE viewNames;
END

