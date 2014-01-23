SELECT sl.name
, HASHBYTES('SHA2_512', CONVERT(VARBINARY,N'Password123') + CAST(LEFT(RIGHT(N'Blu3Corn',34),2) AS VARBINARY(32))) AS HashBytesReconstructionOfPasswordHashFromAGivenPassword2012
, sp.type
, sl.sysadmin
, CAST(sl.password AS VARBINARY(384)) AS EntireSaltAndPasswordHash_HashcatFormat
, LOGINPROPERTY(sl.name,'PasswordHash') AS EntireSaltAndPasswordHashAnotherWay
, CAST(RIGHT(LEFT(sl.password,3),2) AS BINARY(4)) AS Salt
, HASHBYTES('SHA1', CONVERT(VARBINARY,N'Password123') + CAST(LEFT(RIGHT(sl.password,12),2) AS VARBINARY(32))) AS HashBytesReconstructionOfPasswordHashFromAGivenPassword2005
, HASHBYTES('SHA2_512', CONVERT(VARBINARY,N'Password123') + CAST(LEFT(RIGHT(sl.password,34),2) AS VARBINARY(32))) AS HashBytesReconstructionOfPasswordHashFromAGivenPassword2012
FROM sys.syslogins sl
LEFT OUTER JOIN sys.server_principals sp
ON sp.sid = sl.sid
WHERE sl.password IS NOT NULL
 
UNION
SELECT 'MyTest Manual'
, HASHBYTES('SHA2_512', CONVERT(VARBINARY,N'Blu3Corn') + CAST(LEFT(RIGHT(N'Blu3Corn',34),2) AS VARBINARY(32))) AS MyPwd
, ' '
, 0
, ' '
, ' '
, ' '
, ' '
, ' '



-- 0x02003CFAB8D5236AEAEB4BE3C66887B05B5BFA73A09F8E6CF84EBACF6BAE1AB4FAE62C09120A6A078DD49D16A520EA2DE0DA6B1F350075D1B63692D0D558EEB6E1927693692A
-- SELECT HASHBYTES('SHA2_512', N'Blu3Corn' + N'ABCDEF12')


SELECT name, CAST(password AS varbinary)
 FROM sys.syslogins
  WHERE name = 'SQLMonitor'
