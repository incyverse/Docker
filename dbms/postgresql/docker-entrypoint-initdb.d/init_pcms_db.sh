#!/bin/bash
set -e

# ALTER ROLE pcms CREATEROLE;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	SET TIMEZONE TO '$TZ';
	REVOKE ALL ON DATABASE postgres FROM PUBLIC;
	CREATE USER pcms WITH PASSWORD 'pcms(!)2022';
	CREATE DATABASE pcms WITH OWNER pcms;
	GRANT ALL PRIVILEGES ON DATABASE pcms TO pcms;
	GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO pcms;
EOSQL

psql -v ON_ERROR_STOP=1 --username "pcms" --dbname "pcms" <<-EOSQL
	REVOKE ALL ON DATABASE pcms FROM PUBLIC;
	CREATE SCHEMA tuss AUTHORIZATION pcms;
	ALTER USER pcms SET search_path=public,tuss;
EOSQL

# -- 시퀀스 초기화
# -- ALTER SEQUENCE users_code_seq RESTART WITH 1;
# -- TRUNCATE TABLE users RESTART IDENTITY CASCADE;

# 분류 테이블
psql -v ON_ERROR_STOP=1 --username "pcms" --dbname "pcms" <<-EOSQL
	DROP TABLE IF EXISTS tuss.terms, tuss.term_taxonomy CASCADE;
	CREATE TABLE IF NOT EXISTS tuss.terms
	(
		id            BIGSERIAL,
		name          VARCHAR(200)                                       NOT NULL,
		slug          VARCHAR(200)                                       NOT NULL,
		term_group    INT                      DEFAULT 1                 NOT NULL,
		description   TEXT,
		created_date  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
		writer        VARCHAR(50)                                        NOT NULL,
		modified_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
		modifier      VARCHAR(50)                                        NOT NULL,
		deleted_date  TIMESTAMP WITH TIME ZONE,
		deleter       VARCHAR(50),
		CONSTRAINT terms_pk PRIMARY KEY (id)
	);
	COMMENT ON TABLE tuss.terms IS '분류 테이블';
	COMMENT ON COLUMN tuss.terms.id IS '용어 번호';
	COMMENT ON COLUMN tuss.terms.name IS '용어 명칭';
	COMMENT ON COLUMN tuss.terms.slug IS '용어 아이디';
	COMMENT ON COLUMN tuss.terms.term_group IS '단계 그룹';
	ALTER TABLE tuss.terms OWNER TO pcms;
	GRANT ALL ON tuss.terms TO pcms;
	CREATE UNIQUE INDEX IF NOT EXISTS terms_udx ON tuss.terms (slug);
	CREATE INDEX IF NOT EXISTS terms_idx ON tuss.terms (name);
EOSQL

# 분류 상세 테이블
psql -v ON_ERROR_STOP=1 --username "pcms" --dbname "pcms" <<-EOSQL
	CREATE TABLE IF NOT EXISTS tuss.term_taxonomy
	(
		id       BIGSERIAL,
		term_id  BIGINT      			      NOT NULL,
		parent   BIGINT      DEFAULT 0        NOT NULL,
		sequence INT         DEFAULT 1        NOT NULL,
		value    VARCHAR(200),
		status   VARCHAR(10) DEFAULT 'active' NOT NULL,
		taxonomy VARCHAR(50) DEFAULT ''       NOT NULL,
		CONSTRAINT term_taxonomy_pk PRIMARY KEY (id),
		CONSTRAINT term_taxonomy_terms_id_fk FOREIGN KEY (term_id) REFERENCES tuss.terms (id)
	);
	COMMENT ON TABLE tuss.term_taxonomy IS '분류 상세 테이블';
	COMMENT ON COLUMN tuss.term_taxonomy.id IS '용어 분류 번호';
	COMMENT ON COLUMN tuss.term_taxonomy.term_id IS '용어 번호';
	COMMENT ON COLUMN tuss.term_taxonomy.parent IS '부모';
	COMMENT ON COLUMN tuss.term_taxonomy.sequence IS '순서';
	COMMENT ON COLUMN tuss.term_taxonomy.value IS '값';
	COMMENT ON COLUMN tuss.term_taxonomy.status IS '활성화 상태';
	COMMENT ON COLUMN tuss.term_taxonomy.taxonomy IS '용어 분류 명칭';
	ALTER TABLE tuss.term_taxonomy OWNER TO pcms;
	GRANT ALL ON tuss.term_taxonomy TO pcms;
	CREATE INDEX IF NOT EXISTS term_taxonomy_idx ON tuss.term_taxonomy (taxonomy);
EOSQL

# 사용자 테이블
# -- CREATE SEQUENCE IF NOT EXISTS users_code_seq INCREMENT 1 MINVALUE 0000 START WITH 0001;
# -- SELECT CONCAT('U', TO_CHAR(created_date, 'YYYYMM'), REGEXP_REPLACE(code, '^\s+', '')) AS code, * FROM users;
psql -v ON_ERROR_STOP=1 --username "pcms" --dbname "pcms" <<-EOSQL
	DROP SEQUENCE IF EXISTS users_code_seq CASCADE;
	CREATE SEQUENCE IF NOT EXISTS users_code_seq INCREMENT 1 MINVALUE 1 MAXVALUE 999 CYCLE;
	ALTER SEQUENCE IF EXISTS users_code_seq OWNER TO pcms;
	GRANT ALL ON SEQUENCE users_code_seq TO pcms;
	SELECT SETVAL('users_code_seq', 1, FALSE);

	DROP TABLE IF EXISTS tuss.users, tuss.user_meta CASCADE;
	CREATE TABLE IF NOT EXISTS tuss.users
	(
		id            BIGSERIAL,
		code          CHAR(3)                  DEFAULT TO_CHAR(NEXTVAL('users_code_seq'::regclass), 'FM000') NOT NULL,
		avatar        VARCHAR(200),
		login         VARCHAR(50)                                                                            NOT NULL,
		pass          VARCHAR(50)                                                                            NOT NULL,
		name          VARCHAR(20)                                                                            NOT NULL,
		email         VARCHAR(50),
		contact       VARCHAR(20),
		created_date  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP                                     NOT NULL,
		writer        VARCHAR(50)                                                                            NOT NULL,
		modified_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP                                     NOT NULL,
		modifier      VARCHAR(50)                                                                            NOT NULL,
		deleted_date  TIMESTAMP WITH TIME ZONE,
		deleter       VARCHAR(50),
		CONSTRAINT users_pk PRIMARY KEY (id)
	);
	COMMENT ON TABLE tuss.users IS '사용자 테이블';
	COMMENT ON COLUMN tuss.users.id IS '사용자 번호';
	COMMENT ON COLUMN tuss.users.code IS '사용자 코드';
	COMMENT ON COLUMN tuss.users.avatar IS '사용자 사진';
	COMMENT ON COLUMN tuss.users.login IS '로그인 아이디';
	COMMENT ON COLUMN tuss.users.pass IS '로그인 비밀번호';
	COMMENT ON COLUMN tuss.users.name IS '사용자 이름';
	COMMENT ON COLUMN tuss.users.email IS '사용자 이메일';
	COMMENT ON COLUMN tuss.users.contact IS '사용자 연락처';
	ALTER TABLE tuss.users OWNER TO pcms;
	GRANT ALL ON tuss.users TO pcms;
	CREATE UNIQUE INDEX IF NOT EXISTS users_udx ON tuss.users (login);
	CREATE INDEX IF NOT EXISTS users_idx ON tuss.users (name);
EOSQL

# 사용자 메타 테이블
psql -v ON_ERROR_STOP=1 --username "pcms" --dbname "pcms" <<-EOSQL
	CREATE TABLE IF NOT EXISTS tuss.user_meta
	(
		id         BIGSERIAL,
		user_id    BIGINT NOT NULL,
		meta_key   VARCHAR(100),
		meta_value TEXT,
		CONSTRAINT user_meta_pk PRIMARY KEY (id),
		CONSTRAINT user_meta_users_id_fk FOREIGN KEY (user_id) REFERENCES tuss.users (id)
	);
	COMMENT ON TABLE tuss.user_meta IS '사용자 메타 정보';
	ALTER TABLE tuss.user_meta OWNER TO pcms;
	GRANT ALL ON tuss.user_meta TO pcms;
	CREATE INDEX IF NOT EXISTS user_meta_idx ON tuss.user_meta (meta_key, meta_value);
EOSQL