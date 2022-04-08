#!/bin/bash
set -e

# ALTER ROLE aming CREATEROLE;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	SET TIMEZONE TO '$TZ';
	REVOKE ALL ON DATABASE postgres FROM PUBLIC;
	CREATE USER aming WITH PASSWORD 'aming(!)2022';
	CREATE DATABASE aming WITH OWNER aming;
	GRANT ALL PRIVILEGES ON DATABASE aming TO aming;
	GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO aming;
EOSQL

psql -v ON_ERROR_STOP=1 --username "aming" --dbname "aming" <<-EOSQL
	REVOKE ALL ON DATABASE aming FROM PUBLIC;
	CREATE SCHEMA aming AUTHORIZATION aming;
	ALTER USER aming SET search_path=public,aming;
EOSQL

# -- 시퀀스 초기화
# -- ALTER SEQUENCE users_code_seq RESTART WITH 1;
# -- TRUNCATE TABLE users RESTART IDENTITY CASCADE;

# 분류 테이블
# psql -v ON_ERROR_STOP=1 --username "aming" --dbname "aming" <<-EOSQL
# 	DROP TABLE IF EXISTS aming.terms, aming.term_taxonomy CASCADE;
# 	CREATE TABLE IF NOT EXISTS aming.terms
# 	(
# 		id            BIGSERIAL,
# 		name          VARCHAR(200)                                       NOT NULL,
# 		slug          VARCHAR(200)                                       NOT NULL,
# 		term_group    INT                      DEFAULT 1                 NOT NULL,
# 		description   TEXT,
# 		created_date  TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
# 		writer        VARCHAR(50)                                        NOT NULL,
# 		modified_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
# 		modifier      VARCHAR(50)                                        NOT NULL,
# 		deleted_date  TIMESTAMP WITH TIME ZONE,
# 		deleter       VARCHAR(50),
# 		CONSTRAINT terms_pk PRIMARY KEY (id)
# 	);
# 	COMMENT ON TABLE aming.terms IS '분류 테이블';
# 	COMMENT ON COLUMN aming.terms.id IS '용어 번호';
# 	COMMENT ON COLUMN aming.terms.name IS '용어 명칭';
# 	COMMENT ON COLUMN aming.terms.slug IS '용어 아이디';
# 	COMMENT ON COLUMN aming.terms.term_group IS '단계 그룹';
# 	ALTER TABLE aming.terms OWNER TO aming;
# 	GRANT ALL ON aming.terms TO aming;
# 	CREATE UNIQUE INDEX IF NOT EXISTS terms_udx ON aming.terms (slug);
# 	CREATE INDEX IF NOT EXISTS terms_idx ON aming.terms (name);
# EOSQL

# 분류 상세 테이블
# psql -v ON_ERROR_STOP=1 --username "aming" --dbname "aming" <<-EOSQL
# 	CREATE TABLE IF NOT EXISTS aming.term_taxonomy
# 	(
# 		id       BIGSERIAL,
# 		term_id  BIGINT      			      NOT NULL,
# 		parent   BIGINT      DEFAULT 0        NOT NULL,
# 		sequence INT         DEFAULT 1        NOT NULL,
# 		value    VARCHAR(200),
# 		status   VARCHAR(10) DEFAULT 'active' NOT NULL,
# 		taxonomy VARCHAR(50) DEFAULT ''       NOT NULL,
# 		CONSTRAINT term_taxonomy_pk PRIMARY KEY (id),
# 		CONSTRAINT term_taxonomy_terms_id_fk FOREIGN KEY (term_id) REFERENCES aming.terms (id)
# 	);
# 	COMMENT ON TABLE aming.term_taxonomy IS '분류 상세 테이블';
# 	COMMENT ON COLUMN aming.term_taxonomy.id IS '용어 분류 번호';
# 	COMMENT ON COLUMN aming.term_taxonomy.term_id IS '용어 번호';
# 	COMMENT ON COLUMN aming.term_taxonomy.parent IS '부모';
# 	COMMENT ON COLUMN aming.term_taxonomy.sequence IS '순서';
# 	COMMENT ON COLUMN aming.term_taxonomy.value IS '값';
# 	COMMENT ON COLUMN aming.term_taxonomy.status IS '활성화 상태';
# 	COMMENT ON COLUMN aming.term_taxonomy.taxonomy IS '용어 분류 명칭';
# 	ALTER TABLE aming.term_taxonomy OWNER TO aming;
# 	GRANT ALL ON aming.term_taxonomy TO aming;
# 	CREATE INDEX IF NOT EXISTS term_taxonomy_idx ON aming.term_taxonomy (taxonomy);
# EOSQL

# 사용자 테이블
# -- CREATE SEQUENCE IF NOT EXISTS users_code_seq INCREMENT 1 MINVALUE 0000 START WITH 0001;
# -- SELECT CONCAT('U', TO_CHAR(created_date, 'YYYYMM'), REGEXP_REPLACE(code, '^\s+', '')) AS code, * FROM users;
psql -v ON_ERROR_STOP=1 --username "aming" --dbname "aming" <<-EOSQL
	DROP SEQUENCE IF EXISTS users_code_seq CASCADE;
	CREATE SEQUENCE IF NOT EXISTS users_code_seq INCREMENT 1 MINVALUE 1 MAXVALUE 999 CYCLE;
	ALTER SEQUENCE IF EXISTS users_code_seq OWNER TO aming;
	GRANT ALL ON SEQUENCE users_code_seq TO aming;
	SELECT SETVAL('users_code_seq', 1, FALSE);

	DROP TABLE IF EXISTS aming.users, aming.user_meta CASCADE;
	CREATE TABLE IF NOT EXISTS aming.users
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
	COMMENT ON TABLE aming.users IS '사용자 테이블';
	COMMENT ON COLUMN aming.users.id IS '사용자 번호';
	COMMENT ON COLUMN aming.users.code IS '사용자 코드';
	COMMENT ON COLUMN aming.users.avatar IS '사용자 사진';
	COMMENT ON COLUMN aming.users.login IS '로그인 아이디';
	COMMENT ON COLUMN aming.users.pass IS '로그인 비밀번호';
	COMMENT ON COLUMN aming.users.name IS '사용자 이름';
	COMMENT ON COLUMN aming.users.email IS '사용자 이메일';
	COMMENT ON COLUMN aming.users.contact IS '사용자 연락처';
	ALTER TABLE aming.users OWNER TO aming;
	GRANT ALL ON aming.users TO aming;
	CREATE UNIQUE INDEX IF NOT EXISTS users_udx ON aming.users (login);
	CREATE INDEX IF NOT EXISTS users_idx ON aming.users (name);
EOSQL

# 사용자 메타 테이블
psql -v ON_ERROR_STOP=1 --username "aming" --dbname "aming" <<-EOSQL
	CREATE TABLE IF NOT EXISTS aming.user_meta
	(
		id         BIGSERIAL,
		user_id    BIGINT NOT NULL,
		meta_key   VARCHAR(100),
		meta_value TEXT,
		CONSTRAINT user_meta_pk PRIMARY KEY (id),
		CONSTRAINT user_meta_users_id_fk FOREIGN KEY (user_id) REFERENCES aming.users (id)
	);
	COMMENT ON TABLE aming.user_meta IS '사용자 메타 정보';
	ALTER TABLE aming.user_meta OWNER TO aming;
	GRANT ALL ON aming.user_meta TO aming;
	CREATE INDEX IF NOT EXISTS user_meta_idx ON aming.user_meta (meta_key, meta_value);
EOSQL