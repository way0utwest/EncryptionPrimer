Use Master
go

CREATE DATABASE [EncryptionPrimer]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EncryptionPrimer', FILENAME = N'D:\mssqlserver\MSSQL11.MSSQLSERVER\MSSQL\DATA\EncryptionPrimer.mdf' , SIZE = 10240KB , FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'EncryptionPrimer_log', FILENAME = N'D:\mssqlserver\MSSQL11.MSSQLSERVER\MSSQL\DATA\EncryptionPrimer_log.ldf' , SIZE = 4096KB , FILEGROWTH = 10%)
GO
