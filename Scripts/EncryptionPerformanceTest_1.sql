/*
Encryption Performance Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/

USE EncryptTest
go

-- create the keys we need




 




 -- Performance comparison
 -- turn on actual execution plan
 SET STATISTICS IO ON
 SET STATISTICS TIME ON

 -- Get singleton ID
DECLARE @ssn VARCHAR(9)
SELECT @ssn = '157538457'
SELECT
	EmployeeID
	, FirstName
	, lastname
  FROM dbo.Employees AS e
  WHERE EmpTaxID = @ssn
  
 -- check plan
 -- check statistics
 -- should be essentially 0ms.
 
 
 
 
 -- now let's query the symmetric column data
OPEN SYMMETRIC KEY EncryptEmpIDSymKey
   DECRYPTION BY PASSWORD = 'Us#aS%&PerStrongP2ssword';
;
DECLARE @ssn VARCHAR(9)
SELECT @ssn = '157538457'
SELECT
	EmployeeID
	, FirstName
	, lastname
  FROM dbo.Employees AS e
  WHERE DECRYPTBYKEY(EmpIDSymKey) = @ssn
  

-- add hash
DECLARE @ssn VARCHAR(9)
SELECT @ssn = '157538457'
SELECT
	EmployeeID
	, FirstName
	, lastname
  FROM dbo.Employees AS e
  WHERE DECRYPTBYKEY(EmpIDSymKey) = @ssn
  AND hashpartition = dbo.ufn_GroupData(@ssn, 10000)  


--  asym data
DECLARE @ssn VARCHAR(9)
SELECT @ssn = '157538457'

SELECT
	EmployeeID
	, FirstName
	, lastname
	, EmpTaxID
  FROM dbo.Employees AS e
  WHERE CAST( DECRYPTBYASYMKEY(asymkey_id(N'EmpIDProtection')
                              , EmpIDASymKey 
				              , N'Don^tEverU$eP@sswordH3r#')
		      AS VARCHAR(9)) = @SSN


-- WITH HASH PARTITION
DECLARE @ssn VARCHAR(9)
SELECT @ssn = '157538457'

SELECT
	EmployeeID
	, FirstName
	, lastname
	, EmpTaxID
  FROM dbo.Employees AS e
  WHERE CAST( DECRYPTBYASYMKEY(asymkey_id(N'EmpIDProtection')
                              , EmpIDASymKey 
				              , N'Don^tEverU$eP@sswordH3r#')
		      AS VARCHAR(9)) = @SSN
  AND hashpartition = dbo.ufn_GroupData(@ssn, 10000)  

 SET STATISTICS IO Off
 SET STATISTICS TIME Off
