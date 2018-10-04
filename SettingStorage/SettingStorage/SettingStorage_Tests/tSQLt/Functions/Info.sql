CREATE FUNCTION tSQLt.Info
( )
RETURNS TABLE 
AS
RETURN 
    SELECT '1.0.5873.27393' AS Version,
           (SELECT tSQLt.Private::Info()) AS ClrVersion,
           (SELECT tSQLt.Private::SigningKey()) AS ClrSigningKey,
           V.SqlVersion,
           V.SqlBuild,
           V.SqlEdition
    FROM   (SELECT CAST (VI.major + '.' + VI.minor AS NUMERIC (10, 2)) AS SqlVersion,
                   CAST (VI.build + '.' + VI.revision AS NUMERIC (10, 2)) AS SqlBuild,
                   SqlEdition
            FROM   (SELECT PARSENAME(PSV.ProductVersion, 4) AS major,
                           PARSENAME(PSV.ProductVersion, 3) AS minor,
                           PARSENAME(PSV.ProductVersion, 2) AS build,
                           PARSENAME(PSV.ProductVersion, 1) AS revision,
                           Edition AS SqlEdition
                    FROM   tSQLt.Private_SqlVersion() AS PSV) AS VI) AS V


