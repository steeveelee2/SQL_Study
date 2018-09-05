-- DAY 13

-- PL/SQL
-- (PROCEDURE LANGUAGE EXTENSION TO SQL)
-- SQL에서 확장된 형태의 스크립트 언어
-- 오라클 자체에서 내장된 절차적 언어
-- 기존 SQL의 단점을 극복하기 위해 변수의 정의, 조건처리, 반복처리, 예외처리 등을 지원하는 언어

-- PL/SQL의 구조
-- 선언부, 실행부, 예외처리부로 구성됨
-- 선언부 : DECLARE, 변수나 상수를 선언하는 부분
-- 실행부 : BEGIN, 제어문, 반복문, 함수 정의등을 작성하는 부분
-- 예외처리부 : EXCEPTION, 예외 발생시 처리할 내용을 작성하는 부분

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello World');
END;
/
-- / : 즉시 실행하여 확인하겠다는 뜻
-- 화면에 작성한 출력문이 보이도록 설정하기
-- 시스템 관련 설정이기 때문에 접속을 종료하면 다시 초기화된다
SET SERVEROUTPUT ON;

-- 변수의 선언과 초기화, 변수값 출력
SELECT * FROM EMPLOYEE;

/* 변수의 선언 */
DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(15);
BEGIN /* 오라클의 대입 연산자 ":=" */
    EMP_ID:=300;
    EMP_NAME:='홍길동';
    -- 값 출력
    DBMS_OUTPUT.PUT_LINE('EMP_ID = ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME = ' || EMP_NAME);
END;
/
    
    

-- 실제 테이블을 활용한 레퍼런스 변수(참조변수)를 선언하고 사용하는 방법
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE EMP_ID='&EMP_ID';
    -- &를 붙이면 동적쿼리(우리가 입력가능)
    DBMS_OUTPUT.PUT_LINE('EID = '||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME = '||ENAME);
END;
/

-- 1. 실습
-- EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를 참조변수로 선언하고 EMPLOYEE에서 해당 정보들을 추출하여 출력
--  이름은 직접 입력, 월급은 통화기호와 쉼표를 붙여 표현
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL VARCHAR2(30);
BEGIN
    SELECT EMP_ID, EMP_NAME, NVL(DEPT_CODE,'--'), JOB_CODE, LTRIM(TO_CHAR(SALARY,'L9,999,999'),' ')
    INTO EID, ENAME, DCODE, JCODE, SAL
    FROM EMPLOYEE
    WHERE EMP_NAME='&EMP_NAME';
    DBMS_OUTPUT.PUT_LINE('EMP_ID = '||EID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME = '||ENAME);
    DBMS_OUTPUT.PUT_LINE('DEPT_CODE = '||DCODE);
    DBMS_OUTPUT.PUT_LINE('JOB_CODE = '||JCODE);
    DBMS_OUTPUT.PUT_LINE('SALARY = '||SAL);
END;
/

-- %TYPE : 한 컬럼의 자료형을 받아올 떄 사용하는 명령어
-- %ROWTYPE : 테이블의 한 행의 모든 컬럼의 자료형을 참조할 때 사용하는 명령어

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE
    WHERE EMP_NAME='&사원명';
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여정보 : '||E.SALARY);
END;
/

-- IF : 조건문
-- 점수를 입력받아 SCORE 변수에 저장하고 90점 이상은 'A' 80점 B 70 C 나머지 F '당신의 점수는 00이며, 0학점입니다.' 출력
DECLARE
    SCORE INT;
    GRADE VARCHAR2(2);
BEGIN
    SCORE := '&점수';
    -- IF 조건문
    IF SCORE >= 90 THEN GRADE := 'A';
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    ELSE GRADE := 'F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'이며, '||GRADE||'학점입니다.');
END;
/

-- PL/SQL 반복문

-- 일반적으로 하나의 PL/SQL은 하나의 결과만 반환한다
-- 이러한 현상을 해결하기 위한 것이 바로 LOOP 반복구문
DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO E
    FROM EMPLOYEE;
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||E.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여정보 : '||E.SALARY);
END;
/

------
DECLARE -- 변수선언과 동시에 초기화
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N := N+1;
        IF N>5 THEN EXIT;
        END IF;
    END LOOP;
END;
/
    

CREATE TABLE TEST1(
    NO NUMBER,
    TEST_DATE DATE
);
-- FOR LOOP
BEGIN 
    FOR I IN 1..10
        LOOP
            INSERT INTO TEST1 VALUES(I,SYSDATE+I);
        END LOOP;
END;
/

SELECT * FROM TEST1;


-- 즉시 실행하는 PL/SQL 스크립트를 저장하는 PL/SQL 객체 프로시저
-- PROCEDURE
-- 필요할 때마다 직접 스크립트를 작성하는 방식이 아니라 특정 스크립트를 저장해 두었다가 필요로 할 때 호출하는 방식
-- 간편한 스크립트 실행이 목적이다

COMMIT;

CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_DUP;

-- 1. 스크립트 작성
-- 2. 프로시져를 생성해 스크립트 저장
CREATE OR REPLACE PROCEDURE DEL_EMP_WITH_ID
IS
BEGIN 
    DELETE FROM EMP_DUP
    WHERE EMP_ID='&사번';
END;
/

-- 3. 생성한 프로시저 호출
EXECUTE DEL_EMP_WITH_ID;
EXEC DEL_EMP_WITH_ID;

-- DEL_EMP_ALL 이라는 이름으로 프로시져 생성하여 EMP_DUPE 정보 삭제
CREATE OR REPLACE PROCEDURE DEL_EMP_ALL
IS
BEGIN 
    DELETE FROM EMP_DUP;
END;
/

EXEC DEL_EMP_ALL;

DROP TABLE EMP_DUP;
DROP PROCEDURE DEL_EMP_WITH_ID;

-- 프로시져도 데이터 사전에 등록되어있음
-- 프로시져를 관리하는 데이터 사전
SELECT * FROM USER_SOURCE;
SELECT * FROM USER_PROCEDURES;

COMMIT;

-- 트리거(TRIGGER)
-- 테이블이나 뷰에 INSERT, UPDATE, DELETE 등의 DML을 수행할때 해당 시점을(수행되는 순간)을 감지하여 자동으로 스크립트를 실행시키는 객체
-- 즉, 사용자가 직접 스크립트를 호출하여 사용하는 방식이 아니라 데이터베이스에서 자동으로 동작시키는 객체
-- 트리거의 종류는 크게 전체트랜잭션에 대한 스크립트를 수행하는 트리거와 각 행의 변경 시점을 감지하여 동작하는 행 별 수행 트리거로 분류함

-- 신입사원 입사 시 입사 안내 공문을 출력하는 트리거
-- 1. 수행할 스크립트를 작성
BEGIN
    DBMS_OUTPUT.PUT_LINE('"신병 받아라!"');
    DBMS_OUTPUT.PUT_LINE('더블백을 바닥에 때기친다');
END;
/

-- 2. 작성한 스크립트가 동작할 트리거를 생성한다
-- (트리거가 동작하는 시점)
-- DML이 수행되기 전, 후
-- BEFORE INSERT | UPDATE | DELETE --> 값이 삽입되기 전에
-- AFTER INSERT | UPDATE | DELELTE --> 값이 삽입된 후에
CREATE OR REPLACE TRIGGER TRG_01 /* 트리거 이름 설정 */
AFTER INSERT /* 트리거 실행 시점 설정 */
ON EMPLOYEE /* 트리거 적용 테이블 */
BEGIN /* 트리거 실행 내용 작성 */
    DBMS_OUTPUT.PUT_LINE('"신병 받아라!"');
    DBMS_OUTPUT.PUT_LINE('더블백을 바닥에 때기친다');
END; /* 트리거 종료 */
/

INSERT INTO EMPLOYEE
VALUES(SEQ_EID.NEXTVAL,'오날두','681105-1234567','oh_nd@kh.or.kr','01012387699','D2','J3','S2',6000000,NULL,200,SYSDATE,NULL,DEFAULT);

SELECT * FROM EMPLOYEE;

COMMIT;

