CREATE PROCEDURE tSQLt.StubRecord
@SnTableName NVARCHAR (MAX), @BintObjId BIGINT
AS
BEGIN
    RAISERROR ('Warning, tSQLt.StubRecord is not currently supported. Use at your own risk!', 0, 1)
        WITH NOWAIT;
    DECLARE @VcInsertStmt AS NVARCHAR (MAX), @VcInsertValues AS NVARCHAR (MAX);
    DECLARE @SnColumnName AS NVARCHAR (MAX);
    DECLARE @SintDataType AS SMALLINT;
    DECLARE @NvcFKCmd AS NVARCHAR (MAX);
    DECLARE @VcFKVal AS NVARCHAR (MAX);
    SET @VcInsertStmt = 'INSERT INTO ' + @SnTableName + ' (';
    DECLARE curColumns CURSOR LOCAL FAST_FORWARD
        FOR SELECT   syscolumns.name,
                     syscolumns.xtype,
                     cmd.cmd
            FROM     syscolumns
                     LEFT OUTER JOIN
                     dbo.sysconstraints
                     ON syscolumns.id = sysconstraints.id
                        AND syscolumns.colid = sysconstraints.colid
                        AND sysconstraints.status = 1
                     LEFT OUTER JOIN
                     (SELECT fkeyid AS id,
                             fkey AS colid,
                             N'select @V=cast(min(' + syscolumns.name + ') as NVARCHAR) from ' + sysobjects.name AS cmd
                      FROM   sysforeignkeys
                             INNER JOIN
                             sysobjects
                             ON sysobjects.id = sysforeignkeys.rkeyid
                             INNER JOIN
                             syscolumns
                             ON sysobjects.id = syscolumns.id
                                AND syscolumns.colid = rkey) AS cmd
                     ON cmd.id = syscolumns.id
                        AND cmd.colid = syscolumns.colid
            WHERE    syscolumns.id = OBJECT_ID(@SnTableName)
                     AND (syscolumns.isnullable = 0)
            ORDER BY ISNULL(sysconstraints.status, 9999), syscolumns.colorder;
    OPEN curColumns;
    FETCH NEXT FROM curColumns INTO @SnColumnName, @SintDataType, @NvcFKCmd;
    IF @@FETCH_STATUS = 0
        BEGIN
            SET @VcInsertStmt = @VcInsertStmt + @SnColumnName;
            SELECT @VcInsertValues = ')VALUES(' + ISNULL(CAST (@BintObjId AS NVARCHAR), 'NULL');
            FETCH NEXT FROM curColumns INTO @SnColumnName, @SintDataType, @NvcFKCmd;
        END
    ELSE
        BEGIN
            SELECT @VcInsertStmt = @VcInsertStmt + syscolumns.name
            FROM   syscolumns
            WHERE  syscolumns.id = OBJECT_ID(@SnTableName)
                   AND syscolumns.colorder = 1;
            SELECT @VcInsertValues = ')VALUES(' + ISNULL(CAST (@BintObjId AS NVARCHAR), 'NULL');
        END
    WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @VcInsertStmt = @VcInsertStmt + ',' + @SnColumnName;
            SET @VcFKVal = ',0';
            IF @NvcFKCmd IS NOT NULL
                BEGIN
                    SET @VcFKVal = NULL;
                    EXECUTE sp_executesql @NvcFKCmd, N'@V NVARCHAR(MAX) output', @VcFKVal OUTPUT;
                    SET @VcFKVal = isnull(',''' + @VcFKVal + '''', ',NULL');
                END
            SET @VcInsertValues = @VcInsertValues + @VcFKVal;
            FETCH NEXT FROM curColumns INTO @SnColumnName, @SintDataType, @NvcFKCmd;
        END
    CLOSE curColumns;
    DEALLOCATE curColumns;
    SET @VcInsertStmt = @VcInsertStmt + @VcInsertValues + ')';
    IF EXISTS (SELECT 1
               FROM   syscolumns
               WHERE  status = 128
                      AND id = OBJECT_ID(@SnTableName))
        BEGIN
            SET @VcInsertStmt = 'SET IDENTITY_INSERT ' + @SnTableName + ' ON ' + CHAR(10) + @VcInsertStmt + CHAR(10) + 'SET IDENTITY_INSERT ' + @SnTableName + ' OFF ';
        END
    EXECUTE (@VcInsertStmt);
END

