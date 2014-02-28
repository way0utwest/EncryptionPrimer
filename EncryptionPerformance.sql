-- GET DATA FROM Adventurworks
SELECT  *
INTO    Address_Plain
FROM    AdventureWorks2008.Person.Address;
go

SELECT  *
INTO    Address_Encrypted
FROM    AdventureWorks2008.Person.Address;
go
SELECT  *
INTO    Address_EncryptedHash
FROM    AdventureWorks2008.Person.Address;
go


-- 
create INDEX addrplain_addr
 ON dbo.Address_Plain (AddressLine1);


SELECT TOP 10
        *
FROM    dbo.Address_Plain

ALTER TABLE dbo.Address_Encrypted
ADD Address_Encrypted VARBINARY(MAX);
go

ALTER TABLE dbo.Address_EncryptedHash
ADD Address_Encrypted VARBINARY(MAX)
  , Address_Hash VARBINARY(MAX)
;
go
CREATE SYMMETRIC KEY AddressKey
 WITH ALGORITHM = AES_256
 , IDENTITY_VALUE = 'My address is not in here'
 , KEY_SOURCE = 'My source'
 ENCRYPTION BY PASSWORD = 'AR#allyStr0ngP@ssword!'
 ;
 
OPEN SYMMETRIC KEY AddressKey 
 DECRYPTION BY PASSWORD = 'AR#allyStr0ngP@ssword!'

 UPDATE dbo.Address_Encrypted
  SET 

 -- CTRL+M
 SELECT *
  FROM dbo.Address_Plain









-- cleanup
Drop SYMMETRIC KEY AddressKey;
