/*
Encryption Performance Demo Setup

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

USE EncryptTest
go

-- create the table
CREATE TABLE [dbo].[Employees]
    (
     [EmployeeID] INT IDENTITY(1,1)
	,[EmpTaxID] [varchar](9) NULL
    ,[FirstName] [varchar](50) NULL
    ,[lastname] [varchar](50) NULL
    ,[lastfour] [varchar](4) NULL
    ,[EmpIDSymKey] [varbinary](MAX) NULL
    ,[EmpIDASymKey] [varbinary](MAX) NULL
	,[hashpartition] int
    )


GO

-- index the ID field
CREATE NONCLUSTERED INDEX Employee_NCI_EmpID
ON dbo.Employees(EmployeeID);

CREATE NONCLUSTERED INDEX Employee_NCI_EmpTax
ON dbo.Employees(EmpTaxID);

CREATE NONCLUSTERED INDEX Employee_NCI_HashPartition
ON dbo.Employees(HashPartition);

-- move the last four
UPDATE dbo.Employees
 SET lastfour = RIGHT(EmpTaxID, 4)


SELECT
  EmployeeID
  , EmpTaxID
  , lastfour
 FROM dbo.Employees AS e

-- encrypt empid with sym key

  -- create sym key
CREATE SYMMETRIC KEY EncryptEmpIDSymKey
WITH ALGORITHM=AES_256
, IDENTITY_VALUE = 'EmployeeID Protection Key'
, KEY_SOURCE = N'Keep this phrase a secr#t'
ENCRYPTION BY PASSWORD = 'Us#aS%&PerStrongP2ssword';
  go

  -- open key
OPEN SYMMETRIC KEY EncryptEmpIDSymKey
   DECRYPTION BY PASSWORD = 'Us#aS%&PerStrongP2ssword';
;

  -- encrypt data
UPDATE  dbo.Employees
SET     EmpIDSymKey = ENCRYPTBYKEY(KEY_GUID('EncryptEmpIDSymKey'), EmpTaxID)

  -- check random data
SELECT TOP 20
        EmployeeID
,       FirstName
,       lastname
,       EmpTaxID
,       'decryptedvalue' = CAST(DECRYPTBYKEY(EmpIDSymKey) AS VARCHAR(9))
,       EmpIDSymKey
FROM    dbo.Employees AS e



-- create an asymmetric key
CREATE ASYMMETRIC KEY EmpIDProtection
WITH ALGORITHM = RSA_1024 ENCRYPTION BY PASSWORD = 'Don^tEverU$eP@sswordH3r#'
GO


-- encrypt data
UPDATE  employees
SET     EmpIDASymKey = ENCRYPTBYASYMKEY(ASYMKEY_ID(N'EmpIDProtection'),
                                        EmpTaxID);


-- check data
SELECT top 20
        EmployeeID
,       FirstName
,       lastname
,       EmpTaxID
,       'Decrypted' = cast( DECRYPTBYASYMKEY(asymkey_id(N'EmpIDProtection'), EmpIDASymKey ,N'Don^tEverU$eP@sswordH3r#') AS VARCHAR(9))
,       EmpIDASymKey
 FROM dbo.Employees AS e



-- create the encryption function
-- From Chris Bell
-- http://wateroxconsulting.com/archives/indexing-encrypted-data
CREATE FUNCTION [dbo].[ufn_GroupData]
    (
     @String VARCHAR(MAX)
    ,@Divisor INT
    )
RETURNS INT
AS /* based on value being hashed, generates a number within the divisor range to be stored and indexed rather than using an actual hashed value. */
    BEGIN
        DECLARE @Result INT;
            SET @Result = HASHBYTES('SHA2_256', @String);    /*The SHA-2 algorithm is the current required hashing algorithm in most U.S. Gov't applications.   Here it does not matter since the hashed value is not going to be stored, just used for generating the group number */
        IF ( @Divisor > 0 )
            SET @Result = @Result % @Divisor;
            RETURN @Result;            
    END 

-- hash the last 4 with modulus
-- choose modulus of 10000 here.
-- this gives 1,0000,000 / 10,000 or 100 items/group
UPDATE dbo.Employees
 SET hashpartition = dbo.ufn_GroupData(EmpTaxID, 10000)

