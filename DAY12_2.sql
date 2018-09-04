-- < 사용자 관리
-- 사용자의 계정과 암호설정, 권한 부여

-- ORACLE에서 기본적으로 제공하는 계정들
-- 1. SYS / 최상위 관리자
-- 2. SYSTEM / 일반 관리자
-- 3. SCOTT (교육용 샘플 계정) / 버전에 따라서 잠겨있을수도 있다
-- 4. HR (샘플계정) / 처음에는 잠겨있으나 11g버전에서는 별도로 제공하지 않는다

-- 보안을 위한 데이터베이스 관리자
-- 사용자계정을 생성하거나, 사용자가 데이터베이스 객체(테이블, 뷰 등)에 접근할 수 있는 특정 권한을 부여하는 역할
-- 다수의 사용자가 공유하는 데이터베이스 객체들, 정보들을 관리하는 역할
-- 따라서 사용자 계정에 따른 권한, 역할을 각각 다르게 부여할 수 있는 계정

-- 권한 : 사용자가 특정 테이블에 접근할 수 있도록 하거나, 해당 테이블에 SQL(CRUD)구문을 사용할 수 있도록 설정하는 일종의 명령어

-- 시스템 고유의 권한
-- 데이터베이스 관리자가 가지는 권한
-- CREATE USER : 사용자 계정 생성 권한
-- DROP USER : 사용자 계정 삭제 권한
-- DROP ANY TABLE : 임의의 테이블을 강제로 삭제하는 권한
-- QUERY REWRITE : 함수기반의 인덱스를 생성하는 권한
-- BACKUP : 테이블 정보를 백업할 수 있는 권한

CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
GRANT CONNECT, RESOURCE TO SAMPLE;
DROP USER SAMPLE;

-- 테이블 스페이스 (오라클 디스크 관리 객체)
-- 사용자가 생성한 테이블, 뷰, 시퀀스 등의 객체들을 실제로 저장하는 물리적인 디스크의 설정들을 관리하는 객체

SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS
WHERE USERNAME='EMPLOYEE';

-- EXPRESS EDITION (XE) 버전에서는 테이블 스페이스를 하나밖에 사용할 수 없다

-- 권한 부여시 설정할 수 있는 옵션

-- WITH ADMIN OPTION
-- 사용자 계정에 관리자 권한을 부여할 때 사용하는 옵션
-- 권한을 부여받은 사용자는 자신이 가진 권한에 한해서 다른 사용자에게 자신의 권한을 똑같이 부여해줄수있따

GRANT CREATE SESSION TO EMPLOYEE
WITH ADMIN OPTION;

-- 객체 권한 :
-- 테이블이나 뷰, 시퀀스 등 각 객체별로 DML(CRUD)권한을 각각 가질 수 있다
-- 권한부여형식
-- GRANT 권한 종류[(컬럼명)] | ALL
-- ON 객체명 | ROLE 이름 | PUBLIC
-- TO 사용자계정;

-- 권한종류     설정객체
-- ALTER       TABLE, SEQUENCE
-- DELETE      TABLE, VIEW
-- EXECUTE     PROCEDURE
-- INSERT      TABLE, VIEW
-- SELECT      TABLE, VIEW
-- UPDATE .........

GRANT SELECT ON SCOTT.EMP TO EMPLOYEE
WITH GRANT OPTION;

-- WITH GRANT OPTION
-- 사용자가 해당 객체의 권한을 부여 받으면서 해당 권한을 다른 사용자에게도 부여할 수 있는 옵션

-- 사용자가 부여받은 권한을 확인하는 데이터 사전
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_TAB_PRIVS_MADE;

-- 부여한 권한 회수
REVOKE SELECT ON SCOTT.EMP FROM EMPLOYEE;

-- 권한을 부여할 때
-- GRANT CREATE TABLE, CREATE VIEW, CREATE SEQUENCE ......

-- 권한 모음집 (ROLE : 롤)
-- 사용자에게 보다 편리한 방식의 권한 부여를 하기 위한 명령어
-- 다수의 사용자가 여러 권한을 필요로 할 때 하나 하나 부여하는 방식이 아닌 특정 역할(ROLE) 단위로 권한을 한꺼번에 부여할 수 있다

-- 역할(롤)의 종류
-- 1. 사전에 정의된 롤
-- 오라클 설치 시에 기본적으로 제공되는 롤
-- CONNECT ROLE
-- 사용자가 데이터 베이스에 접속할 수 있는 권한을 묶어 놓은 것
-- CREATE SESSION, ALTER SESSION

-- RESOURCE ROLE
-- 사용자가 객체를 생성할 수 있는 권한을 묶어 놓은 것
-- CREATE TABLE, ALTER TABLE, CREATE SEQUENCE, ALTER SEQUENCE

-- DBA ROLE
-- 사용자가 소유한 데이터베이스 객체들을 관리하고 사용자 계정을 생성, 삭제할 수 있는 관리자 권한

SELECT * FROM DICT
WHERE TABLE_NAME LIKE '%ROLE%';

SELECT * FROM USER_ROLE_PRIVS;

-- 2. 사용자가 정의한 롤
-- 롤 생성 시
-- CREATE ROLE 롤이름
-- GRANT 권한종류 TO 롤이름
-- 롤 부여 시
-- GRANT 롤이름 TO 사용자계정

CREATE ROLE MYROLE;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO MYROLE;

GRANT MYROLE TO SCOTT;

-- 롤 삭제
DROP ROLE MYROLE;


-- 공개 동의어
CREATE PUBLIC SYNONYM TEST FOR SYSTEM.HELP;
SELECT * FROM HELP;

DROP PUBLIC SYNONYM TEST;














