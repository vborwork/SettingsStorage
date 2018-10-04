CREATE PROCEDURE tSQLt.Private_RenameObjectToUniqueNameUsingObjectId
@ObjectId INT, @NewName NVARCHAR (MAX)=NULL OUTPUT
AS
BEGIN
    DECLARE @SchemaName AS NVARCHAR (MAX);
    DECLARE @ObjectName AS NVARCHAR (MAX);
    SELECT @SchemaName = QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId)),
           @ObjectName = QUOTENAME(OBJECT_NAME(@ObjectId));
    EXECUTE tSQLt.Private_RenameObjectToUniqueName @SchemaName, @ObjectName, @NewName OUTPUT;
END

