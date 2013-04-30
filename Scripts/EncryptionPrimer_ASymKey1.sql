/*
Asymmetric Key Demo

Steve Jones, copyright 2012 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
-- asymmetric keys
USE EncryptionPrimer

-- create an asymmetric key
create asymmetric key HRProtection
 with algorithm = RSA_1024
GO


go


-- encrypt data
declare 
  @p varchar(200)
, @e varbinary(max);

select @p = 'My salary is $1,000,000/yr';
select @e = ENCRYPTBYASYMKEY(AsymKey_ID(N'HRProtection'), @p);

select 
   plaintext = @p
 , encrypted = @e;

go

-- decrypt the data
declare @e varbinary(max);

-- paste from previous results
select @e = 0xE4CF6C413CA3D9393FF9C2ADB7A33C612D1C02EB9C8952B31931D13ECC6803120A8D171B713E78B9C8C1D30B0B35FD84375AFEE68ED89176B6FC88C721110081A0686C6C7955301A522A383AADE2D56BDA268550F4FA495146DDD27ED5D52293189A07662076961A8B570AF9994B9AA813F3D6AD67F0241577792FCB60A8D6BA

select decryptedvalue = cast( DECRYPTBYASYMKEY(asymkey_id(N'HRProtection'), @e) as varchar(max));

go


-- more common, protect symmetric key with another key

-- Create certificate
-- run in command prompt
/*
makecert -sv "c:\EncryptionPrimer\MyHRCert.pvk" -pe -a sha1 -b "01/01/2012" -e "12/31/2012" -len 2048 -r -n CN="HR Protection Certificate" c:\EncryptionPrimer\MyHRCert.cer


*/

-- load certificate
-- check permissions
create certificate MyHRCert
 from file = N'c:\EncryptionPrimer\MyHRCert.cer'
 with private key
  ( file = N'c:\EncryptionPrimer\MyHRCert.pvk'
  
   );
go


-- create self signed certificate
create certificate MySalaryCert
   ENCRYPTION BY PASSWORD = N'UCan!tBreakThis1'
   WITH SUBJECT = 'Sammamish Shipping Records', 
   EXPIRY_DATE = '20131231';
go


-- backup, since we could lose this with a db issue.
backup certificate MySalaryCert
 to file = N'C:\EncryptionPrimer\MySalaryCert.cer'
  WITH PRIVATE KEY ( DECRYPTION BY PASSWORD = N'UCan!tBreakThis1'
                   , FILE = 'C:\EncryptionPrimer\MySalaryCert.pvk' , 
    ENCRYPTION BY PASSWORD = N'UCan*tBr3akThisEither' );
go


-- Drop certificate
Drop Certificate MySalaryCert;
go



-- Reload to test restore
create certificate MySalaryCert
 from file = N'c:\EncryptionPrimer\MySalaryCert.cer'
 with private key
  ( file = N'c:\EncryptionPrimer\MySalaryCert.pvk'
  , decryption by password = N'UCan*tBr3akThisEither'
   );



-- create symmetric key
create symmetric key SalarySymKey
 with algorithm = AES_256
 encryption by certificate MySalaryCert;
go


-- Now go and encrypt data
create table salary
( empid int NOT NULL
, empname varchar(200)
, plainsalary numeric (10, 4)
, encryptedsalary varbinary(max)
)
;
ALTER TABLE dbo.salary 
  ADD CONSTRAINT Salark_PK PRIMARY KEY NONCLUSTERED
   (empid)
;
go
insert salary
 values ( 1, 'Steve', 5000, null)
      , ( 2, 'Delaney', 2000, null)
      , ( 3, 'Kendall', 1000, null);
go

select empname
     , plainsalary
	 , encryptedsalary
 from salary;
go  


-- encrypt data
open symmetric key SalarySymKey
 decryption by certificate MySalaryCert;

update salary
  set encryptedsalary = ENCRYPTBYKEY( key_guid('SalarySymKey'), cast( plainsalary as nvarchar(200)))
go
select empname
     , plainsalary
	 , encryptedsalary
 from salary;
go  

-- decrypt
select empname
     , plainsalary
	 , DECRYPTBYKEY(encryptedsalary)
 from salary;
go



-- cast
select empname
     , plainsalary
	 , cast( DECRYPTBYKEY(encryptedsalary) as nvarchar(200))
 from salary;
go









-- clean up
drop symmetric key SalarySymKey;
drop certificate MySalaryCert;
drop certificate MyHRCert;
drop table Salary;
go
