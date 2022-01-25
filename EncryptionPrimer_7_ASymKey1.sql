/*
Asymmetric Key Demo

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.

*/

-- Change db
USE EncryptionPrimer;
GO

-- create an asymmetric key
CREATE ASYMMETRIC KEY HRProtection
WITH ALGORITHM = RSA_1024
ENCRYPTION BY PASSWORD = 'Use4SomeStr0ngP@ssword%';
GO

-- error?
-- Why?

-- From MS Docs: RSA_1024 and RSA_512 are deprecated. To use RSA_1024 or RSA_512 (not recommended) you 
--               must set the database to database compatibility level 120 or lower.

CREATE ASYMMETRIC KEY HRProtection
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'Use4SomeStr0ngP@ssword%';
GO

-- encrypt data
DECLARE
    @p VARCHAR(200)
  , @e VARBINARY(MAX);
SELECT @p = 'My salary is $1,000,000/yr';
SELECT @e = ENCRYPTBYASYMKEY (ASYMKEY_ID (N'HRProtection'), @p);
SELECT
    plaintext = @p
  , encrypted = @e
  , decrypted = CAST(DECRYPTBYASYMKEY (ASYMKEY_ID (N'HRProtection'), @e, N'Use4SomeStr0ngP@ssword%') AS VARCHAR(MAX));
GO

-- decrypt the data
DECLARE @e VARBINARY(MAX);

-- paste from previous results
SELECT @e = 0x9CA43C8E43B456593F559A986107BEE36A050FB4D1EE36B5D8AE7430D062F4526AB4721A6A285DB350EF0C8403AA3FB27C01D148744949A9A464E47E64BAD127569B0B5270F613EC6C61ECD96FF080E59DB83FF2F19B3DFA2B57DCCAFA46BE35300BF103517C1BF23012FE31C9918D762657C0FCF63D94F9B6CA9BE23EF64F9CDD5BEEC6152AC203B57E9B2AE9AF77691D9522D0119F255705158D83D68405B4DB6596778DF580891872D55028C4D8CBE3C929332B30E6FFBD78FDDD1C45F2D8F564C3A5793B29C84CCC6A6B30FC90ADB2FEC0D46EEEE3332CBBCE6CCC8A5F94D3FF71C700F149C209B6C2EAE9CD777B3D2A18F89E6AEA22C5A46F7F197C10A1;
SELECT decryptedvalue = CAST(DECRYPTBYASYMKEY (ASYMKEY_ID (N'HRProtection'), @e, N'Use4SomeStr0ngP@ssword%') AS VARCHAR(MAX));
GO

-- more common, protect symmetric key with another key
-- can use asymmetric keys or certificates
-- Create certificate
-- run in command prompt
/*
makecert -sv "c:\EncryptionPrimer\MyHRCert.pvk" -pe -a sha1 -b "01/01/2012" -e "12/31/2012" -len 2048 -r -n CN="HR Protection Certificate" c:\EncryptionPrimer\MyHRCert.cer


*/

-- create self signed certificate

CREATE CERTIFICATE MySalaryCert
ENCRYPTION BY PASSWORD = N'UCan!tBreakThis1'
WITH
    SUBJECT = 'Sammamish Shipping Records'
  , EXPIRY_DATE = '20221231';
GO

-- backup, since we could lose this with a db issue.
BACKUP CERTIFICATE MySalaryCert TO FILE = N'C:\EncryptionPrimer\MySalaryCert.cer'
WITH PRIVATE KEY
    (DECRYPTION BY PASSWORD = N'UCan!tBreakThis1'
   , FILE = 'C:\EncryptionPrimer\MySalaryCert.pvk'
   , ENCRYPTION BY PASSWORD = N'UCan*tBr3akThisEither');
GO

-- Drop certificate
DROP CERTIFICATE MySalaryCert;
GO

-- Reload to test restore
CREATE CERTIFICATE MySalaryCert
FROM FILE = N'c:\EncryptionPrimer\MySalaryCert.cer'
WITH PRIVATE KEY
    (FILE = N'c:\EncryptionPrimer\MySalaryCert.pvk'
   , DECRYPTION BY PASSWORD = N'UCan*tBr3akThisEither');

-- create symmetric key
CREATE SYMMETRIC KEY SalarySymKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE MySalaryCert;
GO

-- Now go and encrypt data
CREATE TABLE salary
(   empid           INT NOT NULL
  , empname         VARCHAR(200)
  , plainsalary     NUMERIC(10, 4)
  , encryptedsalary VARBINARY(MAX));
ALTER TABLE dbo.salary
ADD CONSTRAINT Salark_PK PRIMARY KEY NONCLUSTERED (empid);
GO

INSERT salary
VALUES
    (1, 'Steve', 5000, NULL)
  , (2, 'Delaney', 2000, NULL)
  , (3, 'Kendall', 1000, NULL);
GO

SELECT empname, plainsalary, encryptedsalary FROM salary;
GO

-- encrypt data
OPEN SYMMETRIC KEY SalarySymKey
DECRYPTION BY CERTIFICATE MySalaryCert;
UPDATE salary
SET    encryptedsalary = ENCRYPTBYKEY (KEY_GUID ('SalarySymKey'), CAST(plainsalary AS NVARCHAR(200)));
GO

SELECT empname, plainsalary, encryptedsalary FROM salary;
GO

-- decrypt
SELECT empname, plainsalary, DECRYPTBYKEY (encryptedsalary) FROM salary;
GO

-- cast
SELECT
     empname
   , plainsalary
   , CAST(DECRYPTBYKEY (encryptedsalary) AS NVARCHAR(200))
FROM salary;
GO

-- clean up
DROP SYMMETRIC KEY SalarySymKey;
DROP CERTIFICATE MySalaryCert;
--drop certificate MyHRCert;
DROP ASYMMETRIC KEY hrprotection;
DROP TABLE Salary;
GO