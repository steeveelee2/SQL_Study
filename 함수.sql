-- 함수 (FUNCTION)

-- 특정 컬럼의 값을 계산하여 처리한 결과를 리턴하는 스크립트
-- 종류
-- 단일 행 함수 : 각각의 컬럼을 계산하여 결과값이 컬럼의 갯수만큼 리턴되는 함수
-- 그룹 함수 : 여러 컬럼을 계산하여 하나의 결과를 리턴하는 함수

-- 주의) SELECT 구문에는 단일행 함수와 그룹 함수를 함께 사용할 수 없다

-- 함수를 사용하는 위치
-- SELECT, WHERE, GROUP BY, HAVING, ORDER BY 구문에서 사용 가능

-- 단일 행 함수
-- 문자 관련 함수 : LENGTH / LENGTHB
-- LENGTH(컬럼값 | '문자데이터') : 글자의 수를 반환
-- LENGTHB(컬럼값 ㅣ '문자데이터') : 글자의 바이트 수를 반환
 
-- 임시로 사용할 컬럼의 계산 값이 필요할 경우 DUAL 테이블을 활용하여 계산한 결과를 확인가능함
SELECT LENGTH('Hello'),
        LENGTHB('Hello')
FROM DUAL;

-- 한글은 XE에서 3바이트 취급
SELECT LENGTH('안녕하세요'),
        LENGTHB('안녕하세요')
FROM DUAL;


-- INSTR('문자데이터' | 컬럼명, '찾을 문자데이터', 시작 위치 인덱스[, 빈도]) : 해당 컬럼이나 문자 데이터 중 찾을 문자의 위치를 반환한다
-- DBMS에서의 시작값(인덱스)은 1부터 시작한다
SELECT INSTR('ABCDE','C',1)
FROM DUAL;
-- 빈도 : 3번째 B를 찾겠다
SELECT INSTR('AABCCAAABBCC','B',1,3) 
FROM DUAL;
-- 찾고자 하는 값이 없다면 0을 리턴
SELECT INSTR('AABCCAAA','B',1,5)
FROM DUAL;
-- 시작 위치를 음수로 잡으면 거꾸로 찾음
SELECT INSTR('AAABBCCAAAAABBBBBCCCCC','BC',-1,2)
FROM DUAL;


-- SUBSTR(커럼값 | '문자데이터', 시작 인덱스부터, 몇개까지 불러올거임) : 특정 구간에 존재하는 문자 데이터를 쪼개서 반환
SELECT SUBSTR('Hello World',1,5)
FROM DUAL;


-- 1. 실습
--INSTR과 SUBSTR을 사용하여 EMPLOYEE 테이블에서 사원들의 이메일 아이디를 조회하여 추출한뒤 출력
SELECT EMP_NAME||':'||SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1)-1) 아이디
FROM EMPLOYEE;



-- LPAD / RPAD
-- (컬럼 명 | '문자 데이터', 글자갯수, 채울 문자)
SELECT LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;
-- 공백으로 하면 정렬한 척 씹가능
SELECT RPAD(EMAIL,20,'#')
FROM EMPLOYEE;


-- LTRIM / RTRIM
-- (컬럼 명 | '문자 데이터'[, '찾을 문자 형식'])
-- 현재 컬럼 값이나 문자 데이터에서 특정 문자를 지우는 함수
SELECT LTRIM('     Hello')
FROM DUAL;

SELECT RTRIM('Hello     ')
FROM DUAL;

SELECT LTRIM('012345','0')
FROM DUAL;

SELECT LTRIM('111222333', '1')
FROM DUAL;

SELECT LTRIM('123123KH123','123')
FROM DUAL;

-- TRIM
-- 해당 문자 데이터의 양 끝쪽에서 특정 문자를 지워주는 함수
SELECT TRIM('    KH     ')
FROM DUAL;
--  양 끝의 특정 값을 지우고자할때
SELECT TRIM('Z' FROM 'ZZzKHzZZ')
FROM DUAL;

-- LEADING / TRAILING
-- 엘트림알트림과 같음 
SELECT TRIM(LEADING 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;

SELECT TRIM(TRAILING 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;
-- 보스=트림기본값
SELECT TRIM(BOTH 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;


-- LOWER / UPPER / INITCAP
-- 해당하는 영문자를 소문자 대문자 앞글자만 대문자, 나머지 소문자로
SELECT LOWER('HELLO'),
    UPPER('hello'),
    INITCAP('hELLO')
FROM DUAL;


-- CONCAT : 여러 문자 데이터를 하나로 합쳐줌 ('앞데이터','뒷데이터')
SELECT CONCAT('숙취해소','하고싶다')
FROM DUAL;

SELECT CONCAT('입장료 : ',15000)
FROM DUAL;
-- 콘캣없이 연결연산자로도 쓸수있다
SELECT '입장료 : '||15000
FROM DUAL;


-- REPLACE : 주어진 문자열을 특정 문자열로 바꾸는 함수
SELECT REPLACE('서울시 강남구 역삼동','역삼동', '삼성동')
FROM DUAL;



-- 2. 실습
-- EMPLOYEE 테이블서 사원의 주민등록번호를 확인해 생년월일을 각각 출력해
SELECT EMP_NAME||' '||SUBSTR(EMP_NO,1,2)||'년 '||SUBSTR(EMP_NO,3,2)||'월 '||SUBSTR(EMP_NO,5,2)||'일' 
FROM EMPLOYEE;
-- SUBSTR을 통해 날짜 데이터도 쪼갤 수 있다
SELECT EMP_NAME||' '||SUBSTR(HIRE_DATE,1,2)||'년 '||SUBSTR(HIRE_DATE,4,2)||'월 '||SUBSTR(HIRE_DATE,7,2)||'일' 
FROM EMPLOYEE;


-- 3. 실습
-- EMPLOYEE 테이블에서 사번, 이름, 이메일, 주민번호를 출력하되 이메일은 골뱅이전까지 주민번호는 성별이후는 별표

SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    SUBSTR(EMAIL,1,INSTR(EMAIL,'@',1)-1) 아이디,
    RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE
ORDER BY 사원명;



-- 4. 실습
-- EMPLOYEE 테이블에서 회사에 근무하는 사원 중 여성사원에 대한 사번, 이름, 직급코드를 조회
-- Single row function -- 단일행 함수
-- WHERE 구문에서도 함수사용이 가능하다
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 직급코드
FROM EMPLOYEE
WHERE ENT_YN='N' AND SUBSTR(EMP_NO,8,1)=2
ORDER BY 사원명;


-- 5. 실습
-- EMPLOYEE 테이블에서 직급코드가 '대리'면서 급여가 300마넌 이상 500마넌 이하인 직원들의 사번 일므 관리자사번
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    MANAGER_ID 관리자사번
FROM EMPLOYEE
WHERE JOB_CODE='J6' AND SALARY BETWEEN 3000000 AND 5000000;
-- 관리자의 정체는?
SELECT *
FROM EMPLOYEE
WHERE EMP_ID=214;









-- 그룹함수 GROUP
-- 여러 행을 조회하여 처리한 결과가 1개
-- SUM(), AVG(), MAX(), MIN(), COUNT() 등

-- SUM(숫자가 기록된 컬럼) : 해당 컬럼들의 합계
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 2-1. 실습
-- 임플로이이 테이블에서 D9번 부서에 근무하는 직원의 급여 합계
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

-- AVG(숫자가 기록되 콜롬컬럼) : 평균계산
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- MAX('') : 모든 행을 조회하여 가장 큰 값을 가지는 결과를 반환
SELECT MAX(SALARY)
FROM EMPLOYEE;

-- MIN('') : 조회해서 가장 작은값을 반환
SELECT MIN(SALARY)
FROM EMPLOYEE;


-- 2-2. 실습
-- EMPLOYEE 테이블에서 가장 최그네 입사한 직원의 입사 년도 해당 지구원의 사번, 사원명, RMQDUFMF WHGHLGKTLDH
-- WHERE 구문에서는 단일 행 함수만 사용할 수 있다
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    SALARY 급여
FROM EMPLOYEE
WHERE HIRE_DATE=(SELECT MAX(HIRE_DATE) FROM EMPLOYEE);

-- COUNT(컬럼명) : 행의 갯수를 반환하는 함수
-- COUNT(DISTINCT 컬럼명) : 중복을 제외한 행의 갯수를 반환
SELECT COUNT(*)
FROM EMPLOYEE;

SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;
-- NULL값은 안세줌 ㅅㄱ
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;







-- 날짜 처리 함수 
-- SYSDATE : 현재 컴퓨터의 날짜를 반환하는 함수
SELECT SYSDATE
FROM DUAL;

-- MONTHS_BETWEEN(날짜1, 날짜2)
SELECT MONTHS_BETWEEN(SYSDATE, HIRE_DATE)
FROM EMPLOYEE;

-- ADD_MONTHS(날짜,개월수)
SELECT ADD_MONTHS(SYSDATE,6)
FROM DUAL;

-- EXTRACT(YEAR | MONTH | DAY FROM 날짜) : 지정한 날짜 값으로부터 특정 날짜 정보를 추출하는 함수
SELECT EMP_NAME 사원명,
    EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
    EXTRACT(MONTH FROM HIRE_DATE) 입사월,
    EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE;





--- 형변환 함수
-- TO_DATE(), TO_CHAR(), TO_NUMBER()


-- TO_CHAR()
SELECT HIRE_DATE,
    TO_CHAR(HIRE_DATE,'YYYY-MM-DD'),
    TO_CHAR(HIRE_DATE,'YY-MON-DD')
FROM EMPLOYEE;

-- TO_CHAR 함수를 통해 숫자 데이타를 특정 포맷으로 변환가능
-- 9: 빈 자리를 표시하지 않는다, 0: 빈 자리는 0으로 채운다
-- 포맷을 적용할대 반드시 숫자의 자릿수 이상의 값을 포맷으로 적용해야한다
SELECT SALARY,
    TO_CHAR(SALARY, 'L999,999,999,999'),
    TO_CHAR(SALARY, '000,000,000,000')
FROM EMPLOYEE;


-- TO_DATE()
SELECT 20180821,
    TO_DATE(20180821,'YYYYMMDD'),
    TO_DATE('2018/08/21','YYYY/MM/DD')
FROM DUAL;



-- DECODE()
-- JAVA 삼항연산자 비스무레한거
-- DECODE(컬럼명|데이터, 비교값1, 결과1, 비교값2, 결과2[,.....])

-- 현재 근무하는 직원들의 성별을 남, 여로 구분짓는 조회 쿼리
SELECT EMP_NAME 이름,
    DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여') 성별
FROM EMPLOYEE
ORDER BY 성별;


SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_CODE 부서코드,
    JOB_CODE 직급코드,
    DECODE(ENT_YN,'N','근무자','Y','퇴사') 근무여부,
    DECODE(NVL(MANAGER_ID,0),0,'관리자','일반 사원') 관리자여부
FROM EMPLOYEE;


SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_CODE 부서코드,
    JOB_CODE 직급코드,
    CASE WHEN ENT_YN='N' THEN '근무자'
        WHEN ENT_YN='Y' THEN '퇴사'
        END 근무여부,
    CASE WHEN NVL(MANAGER_ID,0)=0 THEN '관리자'
        WHEN NVL(MANAGER_ID,0)!=0 THEN '일반사원'
        END 관리자여부    
FROM EMPLOYEE;



-- NVL2(컬럼명|데이터, NULL이 아닐 경우 값, NULL일 경우 값)
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    BONUS 보너스,
    NVL2(BONUS,TO_CHAR(BONUS,'0.0'),'X') NVL함수,
    NVL2(BONUS, 'O', 'X') NVL2함수
FROM EMPLOYEE;










