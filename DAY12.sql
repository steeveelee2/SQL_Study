-- DAY12

SELECT * FROM SCOTT.EMP;
SELECT * FROM SCOTT.DEPT;
-- 권한만 부여받으면 다른 테이블의 정보도 조회 가능하다

SELECT * FROM USER_ROLE_PRIVS;




-----------------------------------------------------
-- 인덱스
-- SQL 명령어의 조회 처리 속도를 향상시키기 위한 객체이다
-- 한 테이블의 식별자(기본키, UNIQUE)가 되는 컬럼 값에 대해 각 컬럼 단위로 일정 간격을 계산하여 조회 속도를 향상시킨다
-- 내부에서는 이진트리(B*트리) 구조로 검색을 수행한다

-- 장점
-- 검색 속도가 향상된다

-- 단점
-- 만약 인덱스가 존재하는 테이블이 데이터가 자주 변경되는 테이블이라면 오히려 성능이 저하될 수 있따
-- 인덱스를 저장하기 위한 별도의 공간이 필요하다

-- 인덱스 생성 방법
-- CREATE [UNIQUE] INDEX 인덱스명
-- ON 테이블명 (컬럼명[, 컬럼명...] | 함수식 | 함수명)

-- 인덱스를 관리하는 데이터 사전
SELECT * FROM USER_IND_COLUMNS;

-- 인덱스의 구조
SELECT ROWID, EMP_ID, EMP_NAME
FROM EMPLOYEE;

-- ROWID : 테이블 생성 및 데이터 삽입 시 오라클에서 해당 객체를 관리하기 위해 자동으로 부여하는 객체 및 데이터 순번
--         시스템에서 직접 관리하기 때문에 사용자는 조회만 가능하고, 내용을 변경하거나 추가, 삭제를 직접 할 수 없다

-- 인덱스의 종류
-- 1. 고유 인덱스 (UNIQUE INDEX)
-- 2. 비고유 인덱스 (NONUNIQUE INDEX)
-- 3. 단일 인덱스 (SINGLE INDEX)
-- 4. 결합 인덱스 (COMPOSITE INDEX)
-- 5. 함수기반 인덱스 (FUNCTION BASED INDEX)

-- UNIQUE INDEX
-- 인덱스 생성 시 고유 값을 기준으로 생성되는 인덱스를 뜻함
-- 오라클 PRIMARY KEY 제약조건을 사용하면 자동으로 생성되는 인덱스
-- 일반적으로 PRIMARY KEY 컬럼과 함께 조회할 경우 검색석도가 빨라질 수 있다

-- 만약 생성하고자 하는 인덱스가 이미 존재한다면 중복으로 생성할 수 없다
CREATE UNIQUE INDEX IDX_EMPNO
ON EMPLOYEE (EMP_NO);

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='EMPLOYEE';

-- 만약 테이블 내의 컬럼이 중복값이 존재한다면 UNIQUE INDEX로 생성할 수 없다
-- 따라서 UNIQUE 제약조건이 설정되어 있는 컬럼에 사용한다
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE (DEPT_CODE);


-- NONUNIQUE INDEX
-- 내가 자주 조회하는 컬럼 정보에 대해 검색속도를 향상시키고 싶을 때 사용한다
CREATE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='EMPLOYEE';

SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE='D9';

-- 결합 인덱스
-- 여러 컬럼을 하나로 묶어서 인덱스로 만든 것
CREATE INDEX IDX_DEPT
ON DEPARTMENT (DEPT_ID, DEPT_TITLE);

SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='DEPARTMENT';

SELECT * FROM DEPARTMENT;
SELECT * FROM DEPARTMENT WHERE DEPT_ID>'0' AND DEPT_TITLE>'0';

-- 함수 기반 인덱스
-- SELECT 구문이나 WHERE 구문에서 산술 계산식(함수식)이 사용된 경우 계산식을 통해 검색 조건을 생성하는 인덱스
-- 특정 기산식을 수행하는 일이 많다면 이를 인덱스를 통해 계산을 더욱 빨리 수행할 수 있다
CREATE INDEX IDX_EMP_SSAL_CAL
ON EMPLOYEE(SALARY+(SALARY*NVL(BONUS,0))*12);

SELECT EMP_ID, EMP_NAME, SALARY, SALARY+(SALARY*NVL(BONUS,0))*12 연봉
FROM EMPLOYEE
WHERE SALARY+(SALARY*NVL(BONUS,0))*12 > 1000000;

-- DML 작업(DELETE)을 수행한 경우 해당 인덱스 내의 노드가 논리적으로만 삭제되고 실제 노드의 공간은 그대로 남아있게 된다
-- 따라서 인덱스가 존재하는 테이블의 데이터를 수정, 삭제, 삽입하는 경우 해당 노드를 새로 구성하기 위해 인덱스를 재생성할 필요가 있따
ALTER INDEX IDX_DEPT REBUILD;

-- 인덱스 삭제
DROP INDEX IDX_EMP_SAL_CAL;



-- 동의어 (SYNONYM)
-- 다른 데이터 베이스가 가진 객체를 참조할때 사용하는 별칭
-- 여러 사용자가 하나의 테이블을 공유할 경우 일반적으로 '사용자명.테이블명' 형식으로 접근하지만
-- 동의어를 사용하면 간단하게 줄여서 접근할 수 있다
-- SCOTT.EMP --> EMP
-- CREATE SYNONYM 약어 FOR 사용자명.객체명'

CREATE SYNONYM EMP FOR EMPLOYEE.EMPLOYEE;

SELECT * FROM EMP;

-- 동의어 종류
-- 1. 비공개 동의어
-- 객체에 대한 접근 권한을 부여받은 사용자만 정의할 수 있는 동의어
-- 2. 공개 동의어
-- 모든 권한을 가진 관리자(DBA)가 정의한 동의어
-- 모든 사용자가 접근할수있다(PUBLIC)
-- EX) DUAL

-- 동의어 삭제
DROP SYNONYM EMP;














