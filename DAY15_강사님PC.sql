-- PL/SQL --
-- 데이터를 처리할 때 사용하는 정적인 SQL을
-- 보다 동적으로 처리하기 위한 스크립트
--
-- DECLARE : 선언부
-- BEGIN : 실행부
-- EXCEPTION : 예외처리부
-- END;
-- /

-- 프로시져 (PROCEDURE)
-- PL/SQL 구문을 저장하는 객체
-- 스크립트를 필요할 때마다 호출하여 사용하는
-- 것이 목적이다.

/*
 [사용형식]
 CREATE [OR REPLACE] PROCEDURE 프로시져명 
        (매개변수1 [IN/OUT/IN OUT] 자료형[, 매개변수2 [MODE] 자료형 . . . ])
  -- 변수의 MODE(유형)
  -- IN : 프로시져에서 사용할 변수 값을 외부에서 전달 받을 때 사용하는 모드
  -- OUT : 스크립트를 실행한 결과를 외부로 추출할 때 사용하는 모드(Ex) RETURN)
  -- IN OUT : IN과 OUT 두가지 모두 허용하는 모드 
     (단, IN / OUT 둘 중 하나의 기능만 사용할 수 있다.)
  IS  -- DECLARE와 동일
     -- 지역변수를 선언;
  BEGIN
     실행할 스크립트1;
     실행할 스크립트2;
     -- 함수 호출, 절차적 알고리즘, SQL 구문
  END;
  /  
  
  [호출방식]
   EXECUTE 프로시져명 [(전달값1, 전달값2 ... )];
   EXEC       ''         '';
   
  [삭제]
   DROP PROCEDURE 프로시져명;
  
  [프로시져 조회]
  데이터 사전 : USER_SOURCE;
  NAME : 저장한 프로시져 이름 
  TEXT : 해당 프로시져의 소스 코드를 저장
*/

CREATE TABLE EMP_DUP
AS SELECT * FROM EMPLOYEE;

SELECT * FROM EMP_DUP;

-- 직원 정보를 모두 삭제하는
-- 프로시져 만들기

CREATE OR REPLACE PROCEDURE DEL_ALL_EMP
IS
  -- 지역변수 선언이 없을 경우에도
  -- IS를 생략할 수 없다.
BEGIN
  DELETE FROM EMP_DUP;
  COMMIT;
END;
/

-- 프로시져 실행
EXEC DEL_ALL_EMP;

-- 처리한 내용 확인
SELECT * FROM EMP_DUP;

-- 매개변수가 있는 프로시져

-- [ IN ] --

DROP TABLE EMP_01;

CREATE TABLE EMP_01
AS SELECT * FROM EMPLOYEE;

-- 특정 이름을 가진 직원 정보 삭제하기

-- 삭제할 직원 정보 확인
SELECT * FROM EMP_01
WHERE EMP_NAME LIKE '이%';

-- 매개변수가 있는 프로시져 생성
CREATE OR REPLACE PROCEDURE
       DEL_EMPNAME(V_NAME IN EMP_01.EMP_NAME%TYPE)
IS
BEGIN
    DELETE FROM EMP_01
    WHERE EMP_NAME LIKE V_NAME;
    DBMS_OUTPUT.PUT_LINE(V_NAME || '관련 직원 정보가 삭제되었습니다.');
    COMMIT;
END;
/

SET SERVEROUTPUT ON;
SHOW ERRORS;

EXEC DEL_EMPNAME('이%');

SELECT * FROM EMP_01
WHERE EMP_NAME LIKE '이%';

-- [ OUT ] --
/*
   OUT 모드는 내부의 값을 외부로 전달하기 때문에
   외부에서도 값을 받을 수 있는 VARIABLE(변수) 객체를
   생성하여야 한다.
   
   -- 내부의 값을 전달받을 변수 선언
   VARIABLE 변수명 자료형(바이트);
   
   EXEC 프로시져명(전달값, :전달받을 변수명);
   
   CREATE OR REPLACE 프로시져명 (변수명 OUT 자료형)
   -- OUT으로 선언한 변수의 자료형과, VARIABLE로 전달받을
   -- 변수의 자료형은 반드시 동일해야 한다.
   
   -- 받은 값 출력 시
   PRINT 변수명;
*/

-- 직원 정보를 조회하여 변수에 직원 정보를 삽입한 후 꺼내오기
-- DROP PROCEDURE SAL_EML_ID;
CREATE OR REPLACE PROCEDURE
     SAL_EMP_ID( VEMPID IN EMPLOYEE.EMP_ID%TYPE,
                 VEMPNAME OUT EMPLOYEE.EMP_NAME%TYPE,
                 VSAL OUT EMPLOYEE.SALARY%TYPE,
                 VJOB OUT EMPLOYEE.JOB_CODE%TYPE)
IS
BEGIN
     SELECT EMP_NAME, SALARY, JOB_CODE
     INTO VEMPNAME, VSAL, VJOB
     FROM EMPLOYEE
     WHERE EMP_ID = VEMPID;
END;
/

VARIABLE VAR_ENAME VARCHAR2(20);
VARIABLE VAR_SAL NUMBER;
VARIABLE VAR_JOB CHAR(2);

PRINT VAR_ENAME;

EXEC SAL_EMP_ID(300, :VAR_ENAME, :VAR_SAL, :VAR_JOB);

PRINT VAR_ENAME;
PRINT VAR_SAL;
PRINT VAR_JOB;

-- 자동으로 입력된 값 출력하기 위한 설정
SET AUTOPRINT ON;

EXEC SAL_EMP_ID(900, :VAR_ENAME, :VAR_SAL, :VAR_JOB);

-- IN OUT : 둘 중 하나의 역할을 모두 수행하는 모드
CREATE OR REPLACE PROCEDURE
     SAL_EMP_ID( VEMPID IN EMPLOYEE.EMP_ID%TYPE,
                 VEMPNAME IN OUT EMPLOYEE.EMP_NAME%TYPE,
                 VSAL OUT EMPLOYEE.SALARY%TYPE,
                 VJOB OUT EMPLOYEE.JOB_CODE%TYPE)
IS
BEGIN
     SELECT EMP_NAME, SALARY, JOB_CODE
     INTO VEMPNAME, VSAL, VJOB
     FROM EMPLOYEE
     WHERE EMP_ID = VEMPID;
END;
/

-- 1. 실습

CREATE TABLE DEPT_01
AS
SELECT * FROM DEPARTMENT;

-- 부서코드를 입력받아 해당 부서를 삭제한 뒤에
-- 삭제된 부서의 이름을 출력하는 프로시져를 만들어 보시오.
-- 단, 만약 조회한 부서가 없을 경우
-- NO_DATA_FOUND를 활용하여 '해당 부서가 존재하지 않습니다.'라는
-- 문장을 출력하시오.

VARIABLE DEPT_TITLE VARCHAR2(35 BYTE);

CREATE OR REPLACE PROCEDURE 
       DEL_DEPT(V_DEPT_ID IN DEPT_01.DEPT_ID%TYPE,
                V_DEPT_TITLE OUT DEPT_01.DEPT_TITLE%TYPE)
IS
BEGIN
       SELECT DEPT_TITLE
       INTO V_DEPT_TITLE
       FROM DEPT_01
       WHERE DEPT_ID = V_DEPT_ID;
       
       DELETE FROM DEPT_01
       WHERE DEPT_ID = V_DEPT_ID;
       
       COMMIT;
       
       DBMS_OUTPUT.PUT_LINE(V_DEPT_TITLE||'부서가 삭제되었습니다.');
       
EXCEPTION
      WHEN NO_DATA_FOUND
      THEN DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
END;
/

EXEC DEL_DEPT('D1', :DEPT_TITLE);

EXEC DEL_DEPT('D0', :DEPT_TITLE);

-- FUNCTION
-- 내부에서 계산된 결과를 반환하는 객체
-- SUM(*), AVG(*), MAX(*), MIN(*), COUNT(*)
-- 프로시져와 사용용도가 매우 흡사하다.

/*
   [사용형식]
   CREATE [OR REPLACE] FUNCTION 함수이름(매개변수 [MODE] 자료형)   
   RETURN 자료형; -- 반환할 결과의 자료형태
   IS
       -- 지역변수;
   BEGIN
       -- 실행할 스크립트;
   RETURN 결과 데이터;
   END;
   /
   
   [사용방법]
   
   밖에서 받을 변수
   VARIABLE 변수명 자료형;
   EXEC :변수명 := 함수명(전달값, :OUT변수 , ...);
   
*/

-- 입력한 사번에 해당하는 직원의 보너스 계산하기

CREATE OR REPLACE FUNCTION 
       BONUS_CALC(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
  V_SAL EMPLOYEE.SALARY%TYPE;
  V_BONUS EMPLOYEE.BONUS%TYPE;
  CALC_SAL NUMBER;
BEGIN
  SELECT SALARY, NVL(BONUS, 0)
  INTO V_SAL, V_BONUS
  FROM EMPLOYEE
  WHERE EMP_ID = V_EMP_ID;
  
  CALC_SAL := V_SAL * V_BONUS;
  RETURN CALC_SAL;
END;
/

VARIABLE RESULT_SAL NUMBER;

EXEC :RESULT_SAL  := BONUS_CALC('&사번');

SELECT EMP_NAME, SALARY, BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) > 500000;

-- 2. 실습
-- 직원들의 연봉을 계산하는 함수를 만들어 보시오.
-- 단 매개변수는 사원번호만을 받으며 연봉 계산식은 하단의 내용과 같다.
-- 연봉 계산식 = (급여+(급여 * NVL(보너스,0)))*12
--            = (급여 + BONUS_CALC(EMP_ID)) * 12


CREATE OR REPLACE FUNCTION 
       YEARLY_SAL(V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS
  CALC_SAL NUMBER;
BEGIN
  SELECT (SALARY + BONUS_CALC(EMP_ID)) * 12
  INTO CALC_SAL
  FROM EMPLOYEE
  WHERE EMP_ID = V_EMP_ID;
  
  RETURN CALC_SAL;
END;
/

SELECT EMP_NAME,
       LTRIM(TO_CHAR(SALARY,'L9,999,999')) 급여, 
       LTRIM(TO_CHAR(BONUS_CALC(EMP_ID),'L9,999,999')) 보너스, 
       LTRIM(TO_CHAR(YEARLY_SAL(EMP_ID),'L999,999,999')) 연봉
FROM EMPLOYEE;

-- CURSOR (커서)
-- 처리 결과가 여러 행으로 구해지는 SELECT 문을 처리할 때 사용하는 객체
-- 한 행 한 행을 처리하면서 각 행의 결과를 임시로 담아 놓아
-- 각 행들의 결과를 모두 출력한다.

-- CURSOR의 상태 (시작부터 실행, 종료까지의 상태)
-- OPEN : 커서가 시작됨을 의미
-- FETCH : 한 줄씩 읽어오는 , 실행 중인 상태
-- CLOSE : 커서의 반복이 종료됨을 의미
-- OPEN ~ FETCH ~ CLOSE

-- CURSOR의 상태에 따른 분류
-- %NOTFOUND : 커서 영역의 데이터가 모두 FETCH(실행)되었음 의미하며
-- 만약 다음 행이 존재하지 않는다면 TRUE를 반환한다.
-- %FOUND : 커서 실행 다음 데이터 아직 존재하면 TRUE
-- %ISOPEN : 커서가 OPEN된 상태면 TRUE
-- %ROWCOUNT : 읽어온 레코드(행)의 숫자

-- 커서를 활용하여 각 부서의 부서코드, 부서명, 지역코드 출력하기

-- 1 --
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1
    IS
    SELECT * FROM DEPARTMENT;
BEGIN
    OPEN C1; -- 커서의 시작
    LOOP
      FETCH C1
      INTO
         V_DEPT.DEPT_ID,
         V_DEPT.DEPT_TITLE,
         V_DEPT.LOCATION_ID;
      
      EXIT WHEN C1%NOTFOUND;
    
      DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID 
                 || ', 부서명 : ' || V_DEPT.DEPT_TITLE
                 || ', 지역코드 : ' || V_DEPT.LOCATION_ID);
    
    END LOOP;
    CLOSE C1; -- 커서의 끝
END;
/

EXEC CURSOR_DEPT;

-- FOR IN 반복문을 사용하면
-- 반복시에 자동으로 커서를 OPEN하고
-- 각 행을 자동으로 FETCH하며
-- 반복이 종료될 때 자동으로 커서를 CLOSE한다.

-- 2 --
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1
    IS
    SELECT * FROM DEPARTMENT;
BEGIN
   FOR V_DEPT IN C1 LOOP
      DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID 
                 || ', 부서명 : ' || V_DEPT.DEPT_TITLE
                 || ', 지역코드 : ' || V_DEPT.LOCATION_ID);
   END LOOP;
END;
/

EXEC CURSOR_DEPT;


-- 3 --
CREATE OR REPLACE PROCEDURE CURSOR_DEPT
IS
    V_DEPT DEPARTMENT%ROWTYPE;
BEGIN
    FOR V_DEPT IN (SELECT * FROM DEPARTMENT) LOOP
        DBMS_OUTPUT.PUT_LINE('부서코드 : ' || V_DEPT.DEPT_ID
                  ||', 부서명 : ' || V_DEPT.DEPT_TITLE
                  ||', 지역코드 : ' || V_DEPT.LOCATION_ID);
    END LOOP;
END;
/

EXEC CURSOR_DEPT;

-- 3. 실습
-- 각 사원들의
-- 사원명, 부서명, 직급명, 급여를 모두 출력하는
-- 프로시져를 만들어 보시오.
-- 단, 2가지 방식으로 작성하되
-- CURSOR_EMP_01 은 1번 방식으로
-- CURSOR_EMP_02 는 3번 방식으로 작성해 보시오.

---------- CURSOR LOOP 활용시 ------------

CREATE OR REPLACE PROCEDURE CURSOR_EMP_01
IS
     TYPE EMP_RECORD_TYPE IS RECORD (
        V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        V_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        V_JOB_NAME JOB.JOB_NAME%TYPE,
        V_SAL EMPLOYEE.SALARY%TYPE
     );
     
     EMP_RECORD EMP_RECORD_TYPE;
     
     CURSOR C1
     IS
     SELECT EMP_NAME, DEPT_TITLE, JOB_NAME, SALARY
     FROM EMPLOYEE E, DEPARTMENT D, JOB J
     WHERE E.DEPT_CODE = D.DEPT_ID
     AND E.JOB_CODE = J.JOB_CODE;
BEGIN
     OPEN C1;
     LOOP
        FETCH C1
        INTO EMP_RECORD.V_EMP_NAME,
             EMP_RECORD.V_DEPT_TITLE,
             EMP_RECORD.V_JOB_NAME,
             EMP_RECORD.V_SAL;
        
        EXIT WHEN C1%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('사원명 : ' || EMP_RECORD.V_EMP_NAME ||
                             ', 부서명 : ' || EMP_RECORD.V_DEPT_TITLE ||
                             ', 직급명 : ' || EMP_RECORD.V_JOB_NAME ||
                             ', 급여 : ' || EMP_RECORD.V_SAL);
     
     END LOOP;
     CLOSE C1;
END;
/

EXEC CURSOR_EMP_01;


---------- FOR IN 문 활용시 ------------

CREATE OR REPLACE PROCEDURE CURSOR_EMP_02
IS
     TYPE EMP_RECORD_TYPE IS RECORD (
        V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE,
        V_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE,
        V_JOB_NAME JOB.JOB_NAME%TYPE,
        V_SAL EMPLOYEE.SALARY%TYPE);
     
     EMP_RECORD EMP_RECORD_TYPE;
BEGIN
     FOR EMP_RECORD IN (SELECT EMP_NAME "V_EMP_NAME", 
                               DEPT_TITLE "V_DEPT_TITLE", 
                               JOB_NAME "V_JOB_NAME", 
                               SALARY "V_SAL"
                        FROM EMPLOYEE E, DEPARTMENT D, JOB J
                        WHERE E.DEPT_CODE = D.DEPT_ID
                        AND E.JOB_CODE = J.JOB_CODE) LOOP
        
        DBMS_OUTPUT.PUT_LINE('사원명 : ' || EMP_RECORD.V_EMP_NAME ||
                             ', 부서명 : ' || EMP_RECORD.V_DEPT_TITLE ||
                             ', 직급명 : ' || EMP_RECORD.V_JOB_NAME ||
                             ', 급여 : ' || EMP_RECORD.V_SAL);
     END LOOP;
END;
/

EXEC CURSOR_EMP_02;

-- TRIGGER --
-- 특정 테이블이나 뷰에서 DML 동작이 수행될 때 해당 시점을
-- 감지하여 자동으로 동작하는 스크립트를 정의할 수 있는 객체
-- 즉, 사용자가 직접 DML을 수행하는 것이 아니라
-- 데이터베이스에서 자동으로 처리하는 로직이다.
-- 트리거 종류 : 전체 행에 대한 트리거
--              각 행에 대한 트리거

-- 신입 사원 입사 시에
-- ' OOO 사원이 입사했습니다, 환영해 주세요~' 문구 출력하기

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT -- BEFORE [INSERT | UPDATE | DELETE]
ON EMPLOYEE
DECLARE
   V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_NAME
    INTO V_EMP_NAME
    FROM (SELECT * FROM EMPLOYEE ORDER BY HIRE_DATE DESC)
    WHERE ROWNUM = 1;
    
    DBMS_OUTPUT.PUT_LINE(V_EMP_NAME||'사원이 입사했습니다.');
    DBMS_OUTPUT.PUT_LINE('환영해 주세요~');
END;
/

INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL, '흠길동', '700101-1234567', 'hmmgildong123@kh.or.kr',
        '01011122223', 'D5', 'J7', 'S5', 3000000, 0.1, '200', SYSDATE,
        NULL, DEFAULT);

COMMIT;

INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL, '길상춘', '710101-1234567', 'hmmgildong123@kh.or.kr',
        '01011122223', 'D5', 'J7', 'S5', 3000000, 0.1, '200', SYSDATE,
        NULL, DEFAULT);
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL, '김상추', '720101-1234567', 'hmmgildong123@kh.or.kr',
        '01011122223', 'D5', 'J7', 'S5', 3000000, 0.1, '200', SYSDATE,
        NULL, DEFAULT);
        
COMMIT;

SELECT * FROM USER_SEQUENCES;

-- 트리거를 응용한 사례 --
-- 제품 관리 시스템
-- 제품 정보 테이블
/* P001 -> P999 == P000001 -> P999999 */
-- 실제 데이터를 많이 저장해야 하는 테이블들의
-- 기본키는 보통 일반 숫자 데이터를 활용한다.
-- 1 --> 999 == 1000 ==> 9999 (유지보수가 증가한다.)
-- 기본키를 통한 숫자 연산에 주의해야 한다.

CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(30),
    BRAND VARCHAR2(30),
    PRICE NUMBER,
    STOCK NUMBER DEFAULT 0
);

-- 제품 입.출고 내역 테이블 --
CREATE TABLE PRODUCT_DETAIL(
    DCODE NUMBER PRIMARY KEY,
    PCODE NUMBER NOT NULL,
    PDATE DATE DEFAULT SYSDATE,
    AMOUNT NUMBER,
    STATUS CHAR(6) CHECK (STATUS IN ('입고', '출고')),
    CONSTRAINT FK_PCODE FOREIGN KEY(PCODE) REFERENCES PRODUCT(PCODE)
);

SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_DETAIL;

CREATE SEQUENCE SEQ_PRODUCT;
CREATE SEQUENCE SEQ_DETAIL;

-- 제품 등록 --

-- INSERT INTO PRODUCT
-- VALUES (SEQ_PRODUCT.NEXTVAL, '제품명', '브랜드', 가격, DEFAULT);

 INSERT INTO PRODUCT
 VALUES (SEQ_PRODUCT.NEXTVAL, '노트북', '사성', 3000000, DEFAULT);

 INSERT INTO PRODUCT
 VALUES (SEQ_PRODUCT.NEXTVAL, '전동킥보드', '샤우미', 700000, DEFAULT);

 INSERT INTO PRODUCT
 VALUES (SEQ_PRODUCT.NEXTVAL, '모나미볼펜', '모아미', 500, DEFAULT);

SELECT * FROM PRODUCT;

-- 제품 입.출고 관련 재고 증감 트리거 --
SELECT * FROM PRODUCT_DETAIL;

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT
ON PRODUCT_DETAIL
FOR EACH ROW
BEGIN
   IF :NEW.STATUS = '입고'
   THEN
     UPDATE PRODUCT
     SET STOCK = STOCK + :NEW.AMOUNT
     WHERE PCODE = :NEW.PCODE;
   END IF;
   
   IF :NEW.STATUS = '출고'
   THEN
     UPDATE PRODUCT
     SET STOCK = STOCK - :NEW.AMOUNT
     WHERE PCODE = :NEW.PCODE;
   END IF;
END;
/

-- 입.출고 진행하기 --

SELECT * FROM PRODUCT;
SELECT * FROM PRODUCT_DETAIL;

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 1, SYSDATE, 500, '입고');
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 2, SYSDATE, 100, '입고');
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 3, SYSDATE, 50, '입고');

COMMIT;

INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 1, SYSDATE, 100, '출고');
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 2, SYSDATE, 50, '출고');
INSERT INTO PRODUCT_DETAIL
VALUES(SEQ_DETAIL.NEXTVAL, 3, SYSDATE, 10, '출고');

COMMIT;





