USE master;
-- Korean_Wansung_CI_AS, SQL_Latin1_General_CP1_CI_AS
CREATE DATABASE THiRA COLLATE Korean_Wansung_CI_AS;
ALTER DATABASE THiRA COLLATE Korean_Wansung_CI_AS;
DROP DATABASE THiRA;
SELECT name, collation_name FROM sys.databases;

CREATE LOGIN pcms WITH PASSWORD = 'pcms@2022', DEFAULT_DATABASE = [THiRA], DEFAULT_LANGUAGE = [Korean], CHECK_EXPIRATION = OFF, CHECK_POLICY = OFF;

USE THiRAAMING;
-- SQL Developer: db_owner이지만, SP, Function, Trigger를 제외한 다른 개체에 대한 DDL문 사용 권한이 없다.
-- Developer: data_reader & data_writer이고, 모든 SP에 대한 EXECUTE와 View Definition 권한이 있다.
CREATE USER pcms FOR LOGIN pcms WITH DEFAULT_SCHEMA = dbo;
CREATE ROLE pcms AUTHORIZATION dbo;
ALTER ROLE db_owner ADD MEMBER pcms;
EXEC sp_addrolemember N'db_datareader', N'pcms';
EXEC sp_addrolemember N'db_datawriter', N'pcms';
EXEC sp_addrolemember N'db_owner', N'pcms';
SELECT * FROM sys.database_principals WHERE name = N'pcms';

CREATE TABLE A (id INT, name NVARCHAR(100) COLLATE Korean_Wansung_CI_AS, code NVARCHAR(100));
sp_help A;
INSERT A(name) VALUES ('테스터');
SELECT * FROM A;
