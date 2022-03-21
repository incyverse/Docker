USE master

-- DB 생성
-- collation_name: Korean_Wansung_CI_AS, SQL_Latin1_General_CP1_CI_AS
CREATE DATABASE THiRAUTECH COLLATE Korean_Wansung_CI_AS
ALTER DATABASE THiRAUTECH COLLATE Korean_Wansung_CI_AS

-- DB 삭제
DROP DATABASE THiRAUTECH

-- DB List
SELECT name, collation_name FROM sys.databases

-- LANGUAGE
SELECT * FROM sys.syslanguages

-- SQL Server 인스턴스에 연결하는 사용자 또는 프로세스 생성
-- https://docs.microsoft.com/ko-kr/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver15
CREATE LOGIN pcms
    WITH PASSWORD = 'pcmsStrong(!)Password' MUST_CHANGE, -- MUST_CHANGE: SQL Server 로그인에만 적용, 새 암호를 묻는 메시지 표시
    CREDENTIAL = RestrictedFaculty, -- 새 SQL Server 로그인에 매핑할 자격 증명 이름
    DEFAULT_DATABASE = THiRAUTECH,
    -- DEFAULT_LANGUAGE = Korean
    CHECK_EXPIRATION = OFF, -- 암호 만료 정책
    CHECK_POLICY = OFF -- SQL Server가 실행 중인 컴퓨터의 Windows 암호 정책을 적용

ALTER LOGIN pcms

-- LOGIN List
SELECT * FROM sys.syslogins

-- 유저 정보 조회
sp_helplogins pcms

USE THiRAUTECH
GO
-- SQL Developer: db_owner이지만, SP, Function, Trigger를 제외한 다른 개체에 대한 DDL문 사용 권한이 없다.
-- Developer: data_reader & data_writer이고, 모든 SP에 대한 EXECUTE와 View Definition 권한이 있다.

-- https://docs.microsoft.com/ko-kr/sql/relational-databases/security/authentication-access/create-a-database-user?view=sql-server-ver15
CREATE USER pcms FOR LOGIN pcms WITH DEFAULT_SCHEMA = dbo
GO

CREATE ROLE pcms AUTHORIZATION dbo
GO

ALTER ROLE db_owner ADD MEMBER pcms
GO

EXEC sp_addrolemember 'db_datareader', pcms
EXEC sp_addrolemember 'db_datawriter', pcms
EXEC sp_addrolemember 'db_owner', pcms

-- DB Server 유저 조회
SELECT * FROM sys.server_principals WHERE name = pcms
GO

CREATE TABLE terms
(
    id BIGINT(20) NOT NULL,
    name NVARCHAR(200) NOT NULL,
    slug NVARCHAR(200) NOT NULL,
    term_group BIGINT(10) NOT NULL
)
GO