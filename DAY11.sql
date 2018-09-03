-- Day11

CREATE OR REPLACE VIEW V_EMP(사번, 이름, 부서) 
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
-- 관리자계정에서 권한준다 (GRANT CREATE VIEW TO EMPLOYEE;)


-- VIEW (뷰)
-- SELECT 쿼리 실행의 결과 화면을 저장한 객체
-- (조회하는 SELECT 쿼리 자체를 저장하여 호출될 때마다 해당 쿼리를 실행하는 객체)
-- 논리적인 가상 테이블
-- 실질적으로 데이터를 담고 있지 않다
-- VIEW를 통한 결과는 일반 테이블과 동일하게 사용할 수 있다
-- 보통 일반 사용자에게 노출하고 싶지 않은 정보들이나, 업무에 필요한 정보만 출력하고자 할 떄 사용한다

-- [사용법]
-- CREATE [OR REPLACE] VIEW [뷰이름(뷰에서 사용하고자 하는 컬럼 별칭)]
-- AS 서브쿼리(뷰에서 확인할 컬럼을 조회하는 SELECT 쿼리)

SELECT * FROM V_EMP;

CREATE OR REPLACE VIEW V_EMP(사번, 이름, 부서, 직급)
AS SELECT EMP_NO, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE;
-- 뷰는 SELECT 쿼리문을 저장한 논리적인 가상 테이블이기 때문에 이미 생성되어 있더라도 새로 생성할 수 있다
-- 단 'OR REPLACE'라는 명령어를 포함해야한다


-- 1. 실습
-- 사번, 이름, 직급명, 부서명, 근무지역을 조회하고 V_RESULTSET_EMP라는 뷰에 저장
CREATE OR REPLACE VIEW V_RESULTSET_EMP(사번, 이름, 직급명, 부서명, 근무지역)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE JOIN JOB USING(JOB_CODE) JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE);

-- 1-2. 실습
-- 뷰로 205번 사원 조회
SELECT * FROM V_RESULTSET_EMP WHERE 사번=205;
-- 보안성, 정보 조회의 편의성 향상

-- 등록된 뷰의 정보를 담고 있는 데이터 사전 조회하기
SELECT * FROM USER_VIEWS;

-- 뷰가 참조하는 원래의 테이블 정보가 변경되었을 때 뷰의 정보도 변경된다
UPDATE EMPLOYEE SET EMP_NAME='정중앙' WHERE EMP_ID=205;
SELECT * FROM V_RESULTSET_EMP WHERE 사번=205;


-- 뷰 삭제
DROP VIEW V_RESULTSET_EMP;

COMMIT;


-- 뷰에 연산결과도 함께 저장가능

CREATE OR REPLACE VIEW V_EMP_JOB (사번, 이름, 직급, 성별, 근속년수)
AS SELECT EMP_ID, EMP_NAME, JOB_CODE, DECODE(SUBSTR(EMP_NO,8,1),1,'남','여'),
            EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE;

-- 뷰에 데이터 삽입하기

CREATE OR REPLACE VIEW V_JOB
AS SELECT * FROM JOB;

INSERT INTO V_JOB VALUES('J8','인턴');

SELECT* FROM V_JOB;
SELECT * FROM JOB;
-- 뷰를 통한 데이터 삽입도 가능

-- 수정해도 바뀐다
UPDATE V_JOB
SET JOB_NAME='알바'
WHERE JOB_CODE='J8';

SELECT * FROM V_JOB;
SELECT * FROM JOB;

-- 삭제도 가능
DELETE FROM V_JOB WHERE JOB_CODE='J8';


-- DML 명령어(입력, 수정, 삭제)가 사용이 불가능한 경우
7-- 1. 뷰에 정의되지 않은 컬럼 값을 변경하고자 할 경우
-- 2. 뷰에 포함되지 않은 컬럼 중, 기본이 되는 테이블 컬럼이 NOT NULL 제약조건을 가진 경우
-- 3. 산술 연산이 포함된 경우 DML을 사용할 수 없다
-- 4. JOIN을 이용한 여러 테이블을 참조하는 경우
        -- 조회하는 정보 중 기본키의 요소가 단 하나일 경우는 가능(복합 뷰)
        -- 하지만 일반적으로는 불가능
-- 5. DISTINCT를 사용했을 경우
        -- 삽입, 수정, 삭제의 대상이 명확하지 않기 때문에
-- 6. 그룹함수를 사용하거나, GROUP BY를 통한 결과일 경우

-- 뷰에 정의되어 있지 않은 컬럼을 수정할 경우
CREATE OR REPLACE VIEW V_JOB2
AS SELECT JOB_CODE FROM JOB;

INSERT INTO V_JOB2 VALUES('J8','인턴'); -- 에러

UPDATE V_JOB2 SET JOB_NAME='인턴' WHERE JOB_CODE='J7'; -- 에러

COMMIT;



-- VIEW 생성 시에 설정할 수 있는 옵션
-- OR REPLACE : 기존에 존재하던 동일한 이름의 뷰가 있을 경우 해당 뷰를 덮어쓰고 없다면 새로 만든다
-- FORCE / NOFORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰를 생성할 수 있는 옵션 
-- WITH CHECK : 옵션을 설정한 컬럼의 값을 변경하지 못하게 막는 옵션


-- FORCE : 존재하지 않는 테이블이라도 뷰를 강제로 생성시키는 옵션
CREATE OR REPLACE FORCE VIEW V_EMP
AS SELECT TCODE, TVAME, TCONTENT
FROM T_TABLE;

SELECT * FROM V_EMP;

DROP VIEW V_EMP;

-- NOFORCE : 만약 생성하려는 뷰의 테이블이 존재하지 않는다면 생성하지 않는다 (기본값)
CREATE OR REPLACE NOFORCE VIEW V_EMP
AS SELECT TCODE, TNAME, TCONTENT
FROM T_TABLE;

-- WITH CHECK : 옵션으로 지정한 컬럼값을 수정하지 못하게 막는 옵션
CREATE OR REPLACE VIEW V_EMP
AS SELECT * FROM EMPLOYEE
WITH CHECK OPTION;

SELECT * FROM V_EMP;

-- VIEW의 원래 목적은 필요한 값들을 별도의 테이블 형태로 조회하기 위함, 정보의 보안성(은닉성), 검색의 편리성
-- WITH READ ONLY : DML을 통한 데이터 입력, 수정, 삭제를 불가능하게 막는 옵션
CREATE OR REPLACE VIEW V_EMP
AS SELECT * FROM EMPLOYEE
WITH READ ONLY;

SELECT * FROM V_EMP;

DELETE FROM V_EMP; -- 리드 온리라 못함




-- SEQUENCE( 시퀀스 ) 
-- 1, 2, 3, ....9,10 의 형식으로 숫자 데이터를 연속 처리하기 위한 객체 (자동 번호 발생기)
-- 순차적으로 정수값을 생성 (+/-)

/*
CREATE SEQUENCE 시퀀스이름
[START WITH 숫자] : 처음 시작할 숫자, 생략할 경우 1
[INCREMENT BY 숫자] : 다음 값에 대한 증감 수치, 생략할 경우 +1
[MAXVALUE 숫자 | NOMAXVALUE] : 최대값 설정(10^27-1)
[MINVALUE 숫자 | NOMINVALUE] : 최소값 설정(-10^26)
[CYCLE | NOCYCLE] : 순환여부 설정
[CACHE 바이트 크기 | NOCACHE] : 값을 미리 생성하는 설정, 기본값은 20바이트 최소값은 2바이트
*/

-- 시퀀스 생성
CREATE SEQUENCE SEQ_EMPTD
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- 시퀀스를 처음 생성했을 경우 반드시 1번은 동작시켜야한다
-- 시퀀스 실행
SELECT SEQ_EMPTD.NEXTVAL FROM DUAL;

SELECT SEQ_EMPTD.CURRVAL FROM DUAL;

SELECT SEQ_EMPTD.NEXTVAL FROM DUAL;
SELECT SEQ_EMPTD.NEXTVAL FROM DUAL;
-- 최대값을 지나면 멈춘다


-- 시퀀스 변경
ALTER SEQUENCE SEQ_EMPTD
-- START WITH 315 시작 숫자는 변경할수 없다 변경하려면 삭제하고 새로 만드셈
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;


-- 시퀀스 정보가 들어있는 데이터사전
SELECT * FROM USER_SEQUENCES;

-- SELECT문에서 데이터 조회시 SEQUENCE를 함께 사용할 수 있다
-- INSERT에서 VALUES를 통한 값 입력시 사용가능
-- UPDATE에서 SET을 통한 값 변경시 사용할 수 있따

-- 서브쿼리의 SELECT구문에서는 사용이 불가능, VIEW객체에서도 사용이 불가능
-- DISTINCT를 선언시 사용 불가능, 그룹조건에서도 불가능
-- ORDER BY 에서도 사용 불가능
-- CREATE TABLE 시 컬럼의 기본값 불가능
-- ALTER TABLE시의 기본값 선언에서 사용 불가능(MYSQL은 된다함)


-- 시퀀스 삭제
DROP SEQUENCE SEQ_EMPTD;

COMMIT;

-- 사용 사례
CREATE SEQUENCE SEQ_EID
START WITH 300
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

-- 시퀀스를 활용한 INSERT 구문 생성하기
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL,'홍길동','101010-1234567','hong123@kh.or.kr','01012344321','D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);

-- D2부서 J7직급 직원 4명 더 추가
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL,'공길동','111010-1234567','gong123@kh.or.kr','01012344321','D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL,'고길동','121010-1234567','go123@kh.or.kr','01012344321','D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL,'안중근','131010-1234567','ahn123@kh.or.kr','01012344321','D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);
INSERT INTO EMPLOYEE
VALUES (SEQ_EID.NEXTVAL,'박문수','141010-1234567','park123@kh.or.kr','01012344321','D2','J7','S1',5000000,0.1,200,SYSDATE,NULL,DEFAULT);



-- CYCLE 옵션
CREATE SEQUENCE SEQ_CYCLE
START WITH 200
INCREMENT BY 10
MAXVALUE 230
MINVALUE 15
CYCLE
NOCACHE;

SELECT SEQ_CYCLE.NEXTVAL FROM DUAL;
-- 최대값도달시 최소값부터 시작


-- CACHE ' NOCACHE
-- CACHE : CPU가 연ㅅ나을 그때 그때 즉시 수행하지 않고 미리 한번에 연산을 수행하여 연산한 결과들을 메모리에 담아 놓았다고 사용하는 방식
-- NOCACHE : CPU가 연산을 즉시 수행하는 설정 방식

CREATE SEQUENCE SEQ_CACHE
START WITH 10
INCREMENT BY 1
CACHE 5
NOCYCLE;

SELECT SEQ_CACHE.NEXTVAL FROM DUAL;

SELECT * FROM USER_SEQUENCES;
-- 5개 미리 준비해둠
-- 15에 도착하면 라스트늠바가 20으로 늘어난다(도달하면 또 5개 미리 계산)

-- 값을 미리 지정된 캐시의 사이즈만큼 수행한 후 데이터를 하나씩 사용하는 방식으로
-- 수행 속도는 빠를 수 있으나 만약 데이터 처리 중간에 오류가 발생하여 계산을 다시 수행해야 할 경우 마지막 부분에서 새로 시작한다
-- 따라서 순차적인 데이터 처리의 누수현상이 발생할 수 있다




