CREATE PROCEDURE tSQLt.Private_PrintXML
@Message XML
AS
BEGIN
    SELECT @Message
    FOR    XML PATH ('');
    RETURN 0;
END

