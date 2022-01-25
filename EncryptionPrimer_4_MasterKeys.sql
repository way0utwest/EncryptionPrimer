/*
Master Key Demo

Steve Jones, copyright 2022 

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.
You are free to use this code inside of your own organization.
*/
CREATE DATABASE EncryptionPrimer2
;
go
USE EncryptionPrimer2
;
go

-- create master key
create master KEY
 encryption by password = 'MySup3rSafe5Passc0d#'
;
GO


CREATE TABLE TEST
( ID INT)

GO


INSERT INTO TEST
 SELECT 1


 SELECT * FROM TEST
