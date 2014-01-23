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

