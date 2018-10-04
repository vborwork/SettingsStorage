CREATE VIEW tSQLt.Tests
AS
SELECT classes.SchemaId,
       classes.Name AS TestClassName,
       procs.object_id AS ObjectId,
       procs.name AS Name
FROM   tSQLt.TestClasses AS classes
       INNER JOIN
       sys.procedures AS procs
       ON classes.SchemaId = procs.schema_id
WHERE  LOWER(procs.name) LIKE 'test%';

