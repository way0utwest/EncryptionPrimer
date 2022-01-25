/*
Encryption Primer Setup

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.

*/
IF NOT EXISTS (SELECT [name] FROM sys.databases WHERE name = 'EncryptionPrimer'
  CREATE DATABASE EncryptionPrimer
GO
USE EncryptionPrimer
GO
IF
    (   SELECT d.is_master_key_encrypted_by_server
        FROM   sys.databases AS d
        WHERE  d.name = 'EncryptionPrimer') = 0
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Always$UseStr0ngP@sswords%';
GO

-- OTHER Tasks
-- Need: c:\EncryptionPrimer
-- Need XVI32.exe


