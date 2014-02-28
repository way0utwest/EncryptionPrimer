

-- change to a new database
Use EncryptTest;
go

-- move encrypted data over
select *
 into EmployeeData
 from EncryptionPrimer.dbo.Employees


select *
 from EmployeeData


 select 
  id
, firstname
, lastname
, title
, Salary = cast(cast(DecryptByKey(EnryptedSalary) as nvarchar) as numeric(10,2))
, EnryptedSalary
 from EmployeeData
;
go
-- doesn't work



-- create the key
-- create a symmetric key
create symmetric key MySalaryProtector
 WITH ALGORITHM=AES_256
    , IDENTITY_VALUE = 'Salary Protection Key'
    , Key_SOURCE = N'Keep this phrase a secr#t'
  ENCRYPTION BY PASSWORD = 'Us#aStrongP2ssword';
go


-- open the key
open symmetric key MySalaryProtector
 decryption by password='Us#aStrongP2ssword';


-- requery
 select 
  id
, firstname
, lastname
, title
, Salary = cast(cast(DecryptByKey(EnryptedSalary) as nvarchar) as numeric(10,2))
, EnryptedSalary
 from EmployeeData
;
go


-- close the key
close symmetric key MySalaryProtector;

-- create a different key
create symmetric key NewSalaryProtector
 WITH ALGORITHM=AES_256
    , IDENTITY_VALUE = 'Salary Protection Key'
    , Key_SOURCE = N'Keep this phrase a secr#t'
  ENCRYPTION BY PASSWORD = 'ADiff#r3ntStrongP2ssword';
go


-- can't do that. Same GIUD.


-- drop key
drop symmetric key MySalaryProtector;


-- recreate new key
create symmetric key NewSalaryProtector
 WITH ALGORITHM=AES_256
    , IDENTITY_VALUE = 'Salary Protection Key'
    , Key_SOURCE = N'Keep this phrase a secr#t'
  ENCRYPTION BY PASSWORD = 'ADiff#r3ntStrongP2ssword';
go


-- open the key
open symmetric key NewSalaryProtector
 decryption by password = 'ADiff#r3ntStrongP2ssword';


-- query
 select 
  id
, firstname
, lastname
, title
, Salary = cast(cast(DecryptByKey(EnryptedSalary) as nvarchar) as numeric(10,2))
, EnryptedSalary
 from EmployeeData
;
go


-- cleanup
drop symmetric key NewSalaryProtector;
drop table EmployeeData;

