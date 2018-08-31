-- 숫자 데이터 함수

-- ABS() : 주어진 컬럼값이나 숫자 데이터를 절대값으로 변경하는 함수
SELECT ABS(10), ABS(-10)
FROM DUAL;

-- MOD(컬럼명|숫자데이터, 나눌 숫자) : 주어진 컬럼이나 값을 나눈 나머지를 반환하는 함수
SELECT MOD(10, 3), MOD(10,2),MOD(10,5)
FROM DUAL;

-- 1. 실습
-- EMPLOYEE 테이블에서 입사한 월이 홀수인 직원들의 사번, 사원명, 입사일
SELECT EMP_NO, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE MOD(TO_CHAR(HIRE_DATE,'MM'),2)=1;
--WHERE MOD(EXTRACT(MONTH FROM HIRE_DATE),2)=1;
--WHERE MOD(SUBSTR(HIRE_DATE,4,2),2)=1;


-- 표현식 : 컬럼명|숫자데이터|계산된데이터
-- ROUND(표현식, 반올림할 자릿수) : 자릿수에 맞춰 반올림해줌
SELECT ROUND(123.456,0),
    ROUND(123.456,1),
    ROUND(123.456,2),
    ROUND(123.456,-2) -- 10의 제곱수에 따른 반올림
FROM DUAL;

-- CEIL(표현식) : 소숫점 첫째자리에서 올림(정수로 바까줌)
SELECT CEIL(123.456)
FROM DUAL;

-- FLOOR(표현식) : 소숫점 이하 벌미
SELECT FLOOR(123.456)
FROM DUAL;

-- TRUNC(표현식, 자릿수):지정한 위치까지 절삭(버림)하는 함수
SELECT TRUNC(123.456,0),
    TRUNC(123.456,1),
    TRUNC(123.456,2),
    TRUNC(123.456,-2)
FROM DUAL;


-- 날자 데이타 함수
-- SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, EXTRACT

-- 오늘날자
-- SYSTIMESTAMP : 오늘 날짜와 시간을 ㅏㄷ 가쟈옴
SELECT SYSDATE,SYSTIMESTAMP FROM DUAL;

-- MONTHS_BETWEEN(날짜1, 날짜2) : 두 날짜 사이의 월 차
SELECT EMP_NAME,
    HIRE_DATE,
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))
FROM EMPLOYEE;

-- ADD_MONTHS(특정 날짜, 이후의 개월 수) : 지정한 개월 후의 날짜를 계산하여 반환하는 함수
SELECT EMP_NAME,
    HIRE_DATE,
    ADD_MONTHS(HIRE_DATE,6)
FROM EMPLOYEE;

-- NEXT_DAY(날짜, 요일명) : 가장 가까운 그요일 찾아줌
SELECT NEXT_DAY(SYSDATE,'토요일') FROM DUAL;
SELECT NEXT_DAY(SYSDATE,'토') FROM DUAL;
-- 요일을 숫자로 해도 됨 (일-토, 1-7)
SELECT NEXT_DAY(SYSDATE, 7) FROM DUAL;
-- 영어 못읽음 시스템 기본 설정이 한국어라서
SELECT NEXT_DAY(SYSDATE, 'SATURDAY') FROM DUAL;

-- 현재 계정에 설정된 데이터베이스 정보 확인하기
-- 데이터 딕셔너리 : 관계형 데이터 베이스는 DBMS의 설정 정보들을 테이블 형태로 관리하는데 이를 데이터 딕셔너리라 한다
--                  기본적으로 시스템의 관리자만 설정을 변경할 수 있따
--                  단 사용자 계정과 관련된 설정은 사용자가 접속한 동안에 임시로 변경할 수 있으며
--                  접속 해제할때 설정이 초기화되고 재접속할 경우 이전의 설정이 반영되지 않는다
SELECT * FROM V$NLS_PARAMETERS;
-- 언어를 변경해줌
ALTER SESSION SET NLS_LANGUAGE=AMERICAN;
ALTER SESSION SET NLS_LANGUAGE=KOREAN;

-- LAST_DAY(날자) : 그달의 마지막날
SELECT LAST_DAY(SYSDATE) FROM DUAL;



-- 2. 시릇ㅂ
-- EMPLOYEE 테이블에서 사원 정보를 조회하되 근무 년수가 20년 이상인 사원들의 사번, 사원명, 부서코드, 입사일
SELECT EMP_NO,
    EMP_NAME,
    DEPT_CODE,
    HIRE_DATE
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>=12*20;
-- 날자값은 가장 최근 날짜일수록 큰 값이며 날짜 값 끼리 더하고 밸 수 잇다


-- 3. 실습
-- EMPLOYEE 테이블에서 각 직원들의 사번, 이름, 입사일, 근무년수조회
SELECT EMP_NO 사번,
    EMP_NAME 사원명,
    HIRE_DATE 입사일,
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
FROM EMPLOYEE;

SELECT EMP_NO 사번,
    EMP_NAME 사원명,
    HIRE_DATE 입사일,
    TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) 근무년수
FROM EMPLOYEE;



-- 형번환 함수

-- TO_CHAR(날짜|숫자, '포맷') : 날짜나 숫자 데이터를 포맷에 맞게 변환하여 반환
SELECT TO_CHAR(1234), TO_CHAR(1234,'99999'), TO_CHAR(1234,'00000') FROM DUAL;
SELECT TO_CHAR(1234,'$99,999'), TO_CHAR(1234,'L99,999'), TO_CHAR(1234,'99,999') FROM DUAL;


-- 4. 실습
-- EMPLOYEE 테이블서 모든 지궝 ㄴ사번 이름 급여 급여는 딸라
SELECT EMP_NO 사번,
    EMP_NAME 사원명,
    TO_CHAR(SALARY,'L999,999,999,999') 급여
FROM EMPLOYEE;

-- 시간데이터도 뽑아낼 수 있다
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS'),
    TO_CHAR(SYSDATE, 'AM HH:MI:SS')
FROM DUAL;


SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY'),
    TO_CHAR(SYSDATE, 'YYYY-FMMM-DD DAY'),
    TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY'),
    TO_CHAR(SYSDATE, 'YEAR, Q"분기"')
FROM DUAL;

-- 오늘 날짜에 대한 4자리와 2자리 년도 포맷 문자
-- Y / R
SELECT TO_CHAR(SYSDATE,'YYYY'),
    TO_CHAR(SYSDATE,'RRRR'),
    TO_CHAR(SYSDATE,'YY'),
    TO_CHAR(SYSDATE,'RR')
FROM DUAL;

-- YY와 RR의 차이
-- 4자리의 년도를 추가할땐 문제 없으나 2자리를 추가할 경우 반드시 고려해야 할 포맷 문자 형식
-- YY는 현제 세기(2000년대)를 기준으로 적용
-- RR은 반세기(50년대)를 기준으로 적용
-- EX) 60을 하면 YY는 2060 RR은 1960

SELECT TO_CHAR(TO_DATE(49,'YY'),'YYYY'),
    TO_CHAR(TO_DATE(49,'RR'),'RRRR'),
    TO_CHAR(TO_DATE(51,'YY'),'YYYY'), 
    TO_CHAR(TO_DATE(51,'RR'),'RRRR')
FROM DUAL;

-- 오늘 날짜에서 일자만 처리학ㅣ
SELECT TO_CHAR(SYSDATE,'"1년 기준" DDD'),
    TO_CHAR(SYSDATE,'"1달 기준" DD'),
    TO_CHAR(SYSDATE,'"1주 기준" D')
FROM DUAL;



-- 5. 실습
-- EMPLOYEE 테이블에서 사원명과 입사일을 조회, 형식 마차서
SELECT EMP_NAME 사원명, 
    TO_CHAR(HIRE_DATE,'YYYY"년" MM"월" DD"일" (DAY)') 입사일
FROM EMPLOYEE;



-- TO_DATE(데이터, '읽을 포맷') : 특정 값을 날짜의 포맷 형식을 통해 읽어서 날짜데이터로 바꿔주는 함수
SELECT TO_DATE(20000101,'YYYYMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE(20101010,'YYYYMMDD'),'YEAR, MON') FROM DUAL;

-- TO_NUMBER(문자데이터, 숫자 포맷) : 문자데이터를 숫자로
SELECT TO_NUMBER('123456') FROM DUAL;
-- 숫자데이터와 다른 데이터는 기본적으로 사칙연산 불가능
SELECT '123'||'123ABC' FROM DUAL;
SELECT '123'+'456' FROM DUAL;



-- 선택함수
-- DECODE()
SELECT EMP_NAME,
    EMP_NO,
    DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자')
FROM EMPLOYEE;

-- CASE()
SELECT EMP_NAME,
    EMP_NO,
    CASE WHEN SUBSTR(EMP_NO,8,1)=1 THEN '남자'
        WHEN SUBSTR(EMP_NO,8,1)=2 THEN '여자'
        END
FROM EMPLOYEE;


-- 6. 실습
-- 연봉협상 (조건)
SELECT 
    EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 직급코드,
    CASE WHEN JOB_CODE='J5' THEN TO_CHAR(SALARY*1.2,'L999,999,999')
        WHEN JOB_CODE='J6' THEN TO_CHAR(SALARY*1.15,'L999,999,999')
        WHEN JOB_CODE='J7' THEN TO_CHAR(SALARY*1.1,'L999,999,999')
        ELSE TO_CHAR(SALARY*1.05,'L999,999,999')
        END "인상된 급여"
FROM EMPLOYEE;





-- 실습문제

-- 1
SELECT EMP_NAME 직원명,
    RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE;

-- 2
SELECT EMP_NAME 직원명,
    JOB_CODE 직급코드,
    TO_CHAR(SALARY+SALARY*NVL(BONUS,0),'L999,999,999,999') "연봉(원)"
FROM EMPLOYEE;

--3
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 부서코드,
    HIRE_DATE 입사일
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D9') AND EXTRACT(YEAR FROM HIRE_DATE)=2004;


--4
SELECT EMP_NAME 직원명,
    HIRE_DATE 입사일,
    TO_CHAR(LAST_DAY(HIRE_DATE),'DD')-TO_CHAR(HIRE_DATE,'DD') "입사한 달의 근무일수"
FROM EMPLOYEE;


--5
SELECT EMP_NAME 직원명,
    DEPT_CODE 부서코드,
    TO_CHAR(TO_DATE(SUBSTR(EMP_NO,1,6)),'YY"년"MM"월"DD"일"') 생년월일,
    EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,6))) 나이
FROM EMPLOYEE;


--6
SELECT 
    COUNT(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2001,1)) "2001년",
    COUNT(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2002,1)) "2002년",
    COUNT(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2003,1)) "2003년",
    COUNT(DECODE(TO_CHAR(HIRE_DATE,'YYYY'),2004,1)) "2004년"
FROM EMPLOYEE;

--7
SELECT EMP_NAME 사원명,
    CASE WHEN DEPT_CODE='D5' THEN '총무부'
        WHEN DEPT_CODE='D6' THEN '기획부'
        WHEN DEPT_CODE='D9' THEN '영업부'
        END 부서
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5','D6','D9')
ORDER BY DEPT_CODE ASC;







