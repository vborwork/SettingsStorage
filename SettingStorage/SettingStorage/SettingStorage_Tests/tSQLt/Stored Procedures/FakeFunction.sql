CREATE PROCEDURE tSQLt.FakeFunction
@FunctionName NVARCHAR (MAX), @FakeFunctionName NVARCHAR (MAX)
AS
BEGIN
    DECLARE @FunctionObjectId AS INT;
    DECLARE @FakeFunctionObjectId AS INT;
    DECLARE @IsScalarFunction AS BIT;
    EXECUTE tSQLt.Private_ValidateObjectsCompatibleWithFakeFunction @FunctionName = @FunctionName, @FakeFunctionName = @FakeFunctionName, @FunctionObjectId = @FunctionObjectId OUTPUT, @FakeFunctionObjectId = @FakeFunctionObjectId OUTPUT, @IsScalarFunction = @IsScalarFunction OUTPUT;
    EXECUTE tSQLt.RemoveObject @ObjectName = @FunctionName;
    EXECUTE tSQLt.Private_CreateFakeFunction @FunctionName = @FunctionName, @FakeFunctionName = @FakeFunctionName, @FunctionObjectId = @FunctionObjectId, @FakeFunctionObjectId = @FakeFunctionObjectId, @IsScalarFunction = @IsScalarFunction;
END

