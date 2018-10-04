CREATE PROCEDURE tSQLt.RemoveObjectIfExists
@ObjectName NVARCHAR (MAX), @NewName NVARCHAR (MAX)=NULL OUTPUT
AS
BEGIN
    EXECUTE tSQLt.RemoveObject @ObjectName = @ObjectName, @NewName = @NewName OUTPUT, @IfExists = 1;
END

