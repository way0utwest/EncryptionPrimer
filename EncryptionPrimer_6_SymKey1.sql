/*
Symmetric Key Demo

Steve Jones, copyright 2022 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
use EncryptionPrimer;
go


-- create a table
CREATE TABLE Employees
( id INT IDENTITY(1,1)
, firstname VARCHAR(200)
,lastname VARCHAR(200)
,title VARCHAR(200)
,salary NUMERIC(10, 4)
);
GO
INSERT Employees 
 VALUES ('Steve','Jones','CEO', 5000)
 ,      ('Delaney','Jones','Manure Shoveler', 10)
 ,      ('Kendall','Jones','Window Washer', 5);
 GO
-- check the data
SELECT 
 id
,firstname
,lastname
,title
,salary
 FROM Employees
GO




-- don't want to disclose salary
-- let's encrypt it
-- alter the table
ALTER TABLE Employees
 ADD EncryptedSalary VARBINARY(MAX);
GO


-- create a symmetric key
CREATE SYMMETRIC KEY MySalaryProtector
 WITH ALGORITHM=AES_256
    , IDENTITY_VALUE = 'Salary Protection Key'
    , KEY_SOURCE = N'Keep this phrase a secr#t'
  ENCRYPTION BY PASSWORD = 'Us#aStrongP2ssword';
go


-- open the key
open symmetric key MySalaryProtector
 decryption by password='Us#aStrongP2ssword';


-- encrypt the data
update Employees
 set EncryptedSalary = ENCRYPTBYKEY(key_guid('MySalaryProtector'),cast(salary as nvarchar));
 go
 -- remove the old data
 update employees
   set salary = 0;
 go


 -- check the data
select 
  id
, firstname
, lastname
, title
, salary
, EncryptedSalary
 from Employees;
go


SELECT key_guid('MySalaryProtector') ;


-- decrypt the data
select 
  id
,firstname
,lastname
,title
,Salary = DecryptByKey(EncryptedSalary)
,EncryptedSalary
 from Employees
go


-- decrypt the data, with the casting
select 
  id
, firstname
, lastname
, title
, Salary = cast(cast(DecryptByKey(EncryptedSalary) as nvarchar) as numeric(10,2))
, EncryptedSalary
 from Employees
;
go


-- no need to open the key
-- we will look at this in a minute


-- There's a problem:
-- Delaney accesses the table
update E 
 set EncryptedSalary = b.EncryptedSalary
 from Employees e, Employees b
 where E.ID = 2
 and b.ID = 1;


-- check the data:
select 
  id
, firstname
, lastname
, title
, Salary = cast(cast(DecryptByKey(EncryptedSalary) as nvarchar) as numeric(10,2))
, EncryptedSalary
 from Employees
;
go








-- We have an attack without decryption.









-- Fix the table
update Employees
 set salary= 5000
 where ID = 1;
update Employees
 set salary = 10
 where ID = 2;
update Employees
 set salary = 5
 where ID= 3;
 go




-- add a new column
alter table Employees
 add rowguidID uniqueidentifier;
go

-- populate the data:
update Employees
 set rowguidID = NewID();
go

-- check
select 
  id
, firstname
, lastname
, title
, Salary
, rowguidID
 from Employees;
go


-- Now re-encrypt, with an authenicator
update Employees
 set EncryptedSalary = ENCRYPTBYKEY(key_guid('MySalaryProtector'), cast(salary as nvarchar), 1, cast(rowguidid as nvarchar(100)));
 go


-- check the data again
select 
  id
, title
, Salary = cast(DECRYPTBYKEY(EncryptedSalary, 1,cast(rowguidid as nvarchar(100))) as nvarchar(200))
, rowguidID
, firstname
, lastname
 from Employees;
go


-- attack again
update E 
 set EncryptedSalary = b.EncryptedSalary
 from Employees e, Employees b
 where E.ID= 2
 and b.ID= 1;


-- doesn't work
select 
  id
, title
, Salary = cast(DECRYPTBYKEY(EncryptedSalary, 1,cast(rowguidid as nvarchar(100))) as nvarchar)
, rowguidID
, firstname
, lastname
, EncryptedSalary
 from Employees;
go




-- cleanup
drop symmetric key MySalaryProtector;
drop table Employees;
go

