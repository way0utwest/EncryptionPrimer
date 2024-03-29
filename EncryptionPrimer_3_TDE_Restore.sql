/*
TDE Demo - Second Instance

Steve Jones, copyright 2022 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
-- connect to second instance




--- attempt backup
-- fails





-- restore certificate
USE master
;
go
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AlwaysU$eaStr0ngP@ssword4ThisOtherOne'
;
go
CREATE CERTIFICATE TDEPRimer_CertSecurity
 FROM FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL15.NEW\MSSQL\Backup\tdeprimer_cert'
  WITH PRIVATE KEY (
               FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL15.NEW\MSSQL\Backup\tdeprimer_cert.pvk',
               DECRYPTION BY PASSWORD = 'AStr0ngB@ckUpP@ssw0rd4TDEcERT%')
;
go






-- restore





-- check data
USE tde_primer
;
go
SELECT *
 FROM Mytable
 ;



-- cleanup
USE master
;
GO
DROP DATABASE TDE_Primer
;
go
DROP CERTIFICATE TDEPRimer_CertSecurity
;
GO
DROP MASTER KEY
;
GO

-- return to script 1 for cleanup.