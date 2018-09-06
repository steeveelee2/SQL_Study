-- DAY 14

-- PL/SQL
-- PROCEDUAL LANGUAGE EXTENSION SQL
-- 기존의 DML으로만 작성하던 정적 SQL에서 벗어나 절차적 스크립트를 통해 동적 SQL을 작성하는 기술

SELECT * FROM EMPLOYEE
WHERE EMP_ID=200;

DECLARE
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME
    INTO V_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_ID='&사번';
    DBMS_OUTPUT.PUT_LINE('조회한 사원명 : '||V_EMP_NAME);
END;
/

-- 서버의 출력결과를 표시하겠다
SET SERVEROUTPUT ON;
-- 에러가 발생할 경우 에러를 표시하겠다
SHOW ERRORS;

-- PL/SQL 구조
-- [DECLARE : 선언부 (사용할 변수를 선언하는 부분)]
-- BEGIN : 실행부(사용할 스크립트가 작성되는 부분)
-- EXCEPTION : 예외처리부 (예외가 발생할 경우 실행할 스크립트 부분)
-- END;
-- / <- 즉시 실행하여 결과를 확인하겠따

-- HELLO WORLD 출력하기
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

-- 변수의 선언과 초기화, 변수값 출력하기

DECLARE
    EMP_ID NUMBER;
    EMP_NAME VARCHAR2(30);
BEGIN
    EMP_ID := 123;
    EMP_NAME := '최홍민';
    DBMS_OUTPUT.PUT_LINE('사번 : '||EMP_ID||', 이름 : '||EMP_NAME);
END;
/

-- 참조 변수 생성 및 초기화, 변수 출력하기
DECLARE
    V_EMP_ID EMPLOYEE.EMP_ID%TYPE;
    V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO V_EMP_ID, V_EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_NAME='&성명';
    DBMS_OUTPUT.PUT_LINE('사번 : '||V_EMP_ID||', 이름 : '||V_EMP_NAME);
END;
/

-- 다음은 부서별 급여 레포트를 제출하기 위한 정보를 출력하는 PL/SQL 구문 작성방법이다
-- 현 기업에 존재하는 D1 ~ D9 까지의 부서 코드를 통해 각각의 부서를 찾아 해당 부서의 부서명과 급여 합, 최대급여, 최소급여, 평균급여를 조회
-- 직접 선언한 레퍼런스 변수 및 일반 변수에 담아 출력하시오
-- 단 조회는 하나의 부서에 대해서만 할 수 있다고 가정하며 각각의 변수명은 직접 만들어 본다

DECLARE
    DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
    SUMSAL NUMBER;
    MAXSAL NUMBER;
    MINSAL NUMBER;
    AVGSAL NUMBER;
BEGIN
    SELECT DEPT_TITLE, SUM(SALARY), MAX(SALARY), MIN(SALARY), AVG(SALARY)
    INTO DEPT_TITLE, SUMSAL, MAXSAL, MINSAL, AVGSAL
    FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    WHERE DEPT_TITLE='&부서명'
    GROUP BY DEPT_TITLE;
    
    DBMS_OUTPUT.PUT_LINE('부서명         급여합         최대급여         최소급여         급여평균');
    DBMS_OUTPUT.PUT_LINE(DEPT_TITLE||'          '||TO_CHAR(SUMSAL,'L999,999,999')||'            '||TO_CHAR(MAXSAL,'L999,999,999')||'          '||TO_CHAR(MINSAL,'L999,999,999')||'           '||TO_CHAR(ROUND(AVGSAL,-4),'L999,999,999'));
END;
/


-- 변수명 테이블명.컬럼명%TYPE : 해당 컬럼에 대한 자료형을 참조하는 경우
-- 변수명 테이블명%ROWTYPE : 해당 테이블의 한 행에 대한 모든 컬럼의 자료형을 참조하는 경우

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

-- PL/SQL 조건문
-- IF 조건문
-- IF 조건식 THEN 수행할 스크립트;
-- ELSIF 조건식 THEN 수행할 스크립트;
-- ELSE 수행할 스크립트;
-- END IF;

-- CASE 조건문
-- 변수명 := CASE 변수명조건식
--          WHEN 비교값1 THEN 값1
--          WHEN 비교값2 THEN 값2
--          ELSE 값3
--          END;

-- 점수를 입력받아 SCORE 변수에 저장하고 ----------
DECLARE
    SCORE NUMBER;
    GRADE VARCHAR2(2);
BEGIN
    SCORE:='&점수';
    IF SCORE>=90 THEN GRADE:='A';
    ELSIF SCORE>=80 THEN GRADE:='B';
    ELSIF SCORE>=70 THEN GRADE:='C';
    ELSE GRADE:='F';
    END IF;
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'이고, 학점은 '||GRADE||'학점입니다.');
END;
/


DECLARE
    SCORE INT;
    GRADE VARCHAR2(2);
BEGIN
    SCORE:='&점수';
    GRADE:=CASE FLOOR(SCORE/10)
            WHEN 10 THEN 'A'
            WHEN 9 THEN 'A'
            WHEN 8 THEN 'B'
            WHEN 7 THEN 'C'
            ELSE 'F'
            END;
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||SCORE||'이고, 학점은 '||GRADE||'학점입니다.');
END;
/


-- PL/SQL 반복문
-- 특정 조건이나 값을 만족할때까지 반복하는 PL/SQL 구문
-- 일반 LOOP 반복문
-- LOOP
--  반복시킬 스크립트;
--  IF 반복 종료 조건
--      EXIT;
--  END IF;
-- 또는
--    EXIT(WHEN 반복종료조건)
-- END LOOP;

-- 1부터 5까지 반복
DECLARE
    N NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N:=N+1;
        IF N>5 THEN EXIT;
        END IF;
    END LOOP;
END;
/

-- FOR LOOP 반복문
-- 반복 횟수가 정해진 반복문
-- FOR 카운터변수 IN [REVERSE] 시작값..종료값 LOOP
--  반복할 스크립트;
-- END LOOP;

-- 반복 확인용 테이블
DROP TABLE TEST1;
CREATE TABLE TEST1(
    NO NUMBER,
    TEST_DATE DATE
);

BEGIN
    FOR I IN REVERSE 1..5 LOOP
        INSERT INTO TEST1 VALUES(I,SYSDATE+I);
    END LOOP;
END;
/

SELECT * FROM TEST1;

DELETE FROM TEST1;

-- 1. 실습
-- 구구단 짝수단을 출력하셈
-- FOR / IF 구문 활용
BEGIN
    FOR I IN 2..8 LOOP
        FOR J IN 1..9 LOOP            
            IF MOD(I,2)=0 THEN DBMS_OUTPUT.PUT_LINE(I||' * '||J||' = '||I*J);
            END IF;
        END LOOP;
    END LOOP;
END;
/

-- WHILE LOOP 반복문
-- 처음 반복문을 실행시 조건을 확인하여 TRUE면 반복을 실행하고 FALSE면 실행하지않는 조건부 무한 반복문
-- WHILE 반복할 조건식 LOOP
--  반복할 스크립트;
-- END LOOP;

DECLARE
    N NUMBER := 1;
BEGIN
    WHILE N<6 LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        N:=N+1;
    END LOOP;
END;
/

-- 구구단을 WHILE로 바꾸기
DECLARE
    I NUMBER := 2;
    J NUMBER;
BEGIN
    WHILE I<9 LOOP
        J:=1;
        WHILE J<10 LOOP         
            IF MOD(I,2)=0 THEN DBMS_OUTPUT.PUT_LINE(I||' * '||J||' = '||I*J);
            END IF;
            J:=J+1;
        END LOOP;
        I:=I+2;
    END LOOP;
END;
/

-- 레코드 단위의 변수 자료형 생성하기
-- 특정 테이블의 컬럼들을 뽑아 별도의 레코드 타입 변수를 생성하여 사용하는 방식으로
-- 테이블 내의 여러 값들을 뽑아서 하나의 테이블 형태의 데이터로 만든다

-- 사원의 정보를 RECORD 형식으로 출력하고자 할 때 
DECLARE
    TYPE EMP_RECORD_TYPE IS RECORD(
        EMP_ID EMPLOYEE.EMP_ID%TYPE,
        EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        JOB_NAME JOB.JOB_NAME%TYPE
    );
    
    EMP_RECORD EMP_RECORD_TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO EMP_RECORD
    FROM EMPLOYEE
    LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    JOIN JOB USING (JOB_CODE)
    WHERE EMP_NAME='&사원명';
    DBMS_OUTPUT.PUT_LINE('사번 '||EMP_RECORD.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 '||EMP_RECORD.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서명 '||EMP_RECORD.DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('직급명 '||EMP_RECORD.JOB_NAME);
END;
/

-- 예외처리(EXCEPTION)
-- EXCEPTION
--  WHEN 예외명1 THEN 처리문장1
--  WHEN 예외명2 THEN 처리문장2
--  WHEN 예외명3 OR 예외명4 THEN 처리문장3
--  WHEN OTHERS THEN 처리문장4
-- END;

/*
오라클에서 제공하는 익히 알려진 예외명들
NO_DATA_FOUND : SELECT INTO 구문의 결과가 하나도 없을 경우
CLASS_NOT_FOUND : CASE 문장에 ELSE도 없고, WHEN 구문에 명시한 조건에 일치하는 값이 없을 경우
LOGIN_DENIED : 잘못된 사용자명이나 비밀번호로 접근할 경우
DUP_VAL_ON_INDEX : UNIQUE 인덱스가 설정된 컬럼에 중복값이 들어갈 경우
CURSOR_ALREADY_OPEN : 이미 커서가 열려 있을 경우
INVALID_CURSOR : 아직 열려있지 않거나 사용중인 커서를 닫으려 할 경우
INVALID_NUMBER : 문자 데이터를 숫자로 변경하고자 할 때, 해당 문자를 숫자 데이터로 변경할 수 없는 경우
*/

-- 에러가 발생하는 상황
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID='&사번'
    WHERE EMP_ID='200';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사원입니다');
END;
/

-- 정의되지 않은 예외처리(예외번호를 모를 경우)
DECLARE
    DUP_EMP_ID EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUP_EMP_ID,-00001);
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID='&사번'
    WHERE EMP_ID='200';
EXCEPTION
    WHEN DUP_EMP_ID THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사원입니다');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('모르는에러');
END;
/

-- 사용자 정의 예외 처리
-- IF LENTH(PWD) < 7 THEN
-- RAISE TOO_SHORT_PASSWORD; (사용자가 생성한 예외를 강제로 발생시킨다.)
-- RAISE_APPLOCATION_ERROR(-20001,'비밀번호가 너무 작습니다');
-- END IF;

CREATE TABLE EXAM_MEMBERS(
    MID VARCHAR2(20) CONSTRAINT PK_EXAM PRIMARY KEY,
    PWD VARCHAR2(30),
    NAME VARCHAR2(15)
);

SELECT * FROM EXAM_MEMBERS;

INSERT INTO EXAM_MEMBERS
VALUES('ID','PW','NAME');

COMMIT;

DECLARE
    V_PWD VARCHAR2(30);
    TO0LONG_NAME EXCEPTION;
    TOOSHORT_PWD EXCEPTION;
    PRAGMA EXCEPTION_INIT(TOOLONG_NAME,-12899);
    PRAGMA EXCEPTION_INIT(TOOSHORT_PWD,-20001);
BEGIN
    V_PWD := '&비밀번호';
    IF LENGTH(V_PWD) <8 THEN RAISE TOOSHORT_PWD;
    -- RAISE_APPLICATION_ERROR(TOOSHORT_PWD,'비밀번호가 너무 작습니다');
    END IF;
    INSERT INTO EXAM_MEMBERS VALUES('AIDEE','V_PWD','EEREUM');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    DBMS_OUTPUT.PUT_LINE('아이디가 중복되었습니다.');
    WHEN TOOLONG_NAME THEN
    DBMS_OUTPUT.PUT_LINE('이름이 너무 깁니다.');
    WHEN TOOSHORT_PWD THEN
    DBMS_OUTPUT.PUT_LINE('비밀번호가 너무 짧습니다.');
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('관리자에게 문의하셈요');
END;
/
    
