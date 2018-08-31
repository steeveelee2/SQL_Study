-- 1. 실습
-- EMPLOYEE 테이블에서 이메일 아이디만 가져오기

SELECT EMP_NAME || ':' ||
       SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) "RESULT"
FROM EMPLOYEE;

-- LPAD / RPAD
-- (컬럼명 | '문자 데이터', 글자개수, 채울문자)
-- 주어진 글자 갯수에서 남은 칸을 특정 문자로 채우고자 할 때 사용한다.

SELECT LPAD(EMAIL, 20, '#')
FROM EMPLOYEE;

SELECT RPAD(EMAIL, 20, '-')
FROM EMPLOYEE;

-- LTRIM / RTRIM
-- (컬럼명 | '문자 데이터'[, '찾을 문자 형식'])
-- 현재 컬럼 값이나 문자 데이터에서 특정 문자를
-- 지우는 함수

SELECT LTRIM('     Hello')
FROM DUAL;

SELECT RTRIM('Hello     ')
FROM DUAL;

SELECT LTRIM('012345', '0')
FROM DUAL;

SELECT LTRIM('111222333', '1')
FROM DUAL;

SELECT LTRIM('123123KH123', '123')
FROM DUAL;

SELECT RTRIM('012345', '5')
FROM DUAL;

SELECT RTRIM('111222333', '3')
FROM DUAL;

SELECT RTRIM('123KH123123', '123')
FROM DUAL;


-- TRIM
-- '   KH   '
-- 해당 문자 데이터의 양 끝 쪽에서 특정 문자를 지워주는 함수

SELECT TRIM('    KH    ')
FROM DUAL;

-- 양 끝의 특정 값을 지우고자 할 때
SELECT TRIM('Z' FROM 'ZZzKHzZZ')
FROM DUAL;

-- LEADING / TRAILING
SELECT TRIM(LEADING 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;

SELECT TRIM(TRAILING 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;

SELECT TRIM(BOTH 'Z' FROM 'ZZZ123ZZZ')
FROM DUAL;

-- LOWER / UPPER / INITCAP
-- 해당하는 영문자를 각각 소문자, 대문자, 앞글자만 대문자로
-- 바꾸어 주는 함수

SELECT LOWER('HELLO'),
       UPPER('hello'),
       INITCAP('hELLO')
FROM DUAL;

-- CONCAT : 여러 문자 데이터를 하나로 합쳐주는 함수
-- ('앞에 들어갈 데이터', '뒤에 들어갈 데이터')

SELECT CONCAT('오라클은 ', '재미있어요 하하하')
FROM DUAL;

SELECT CONCAT('입장료 : ', 15000)
FROM DUAL;

-- 연결연산자 (not '짝대기') ||
SELECT '입장료 :' || 15000 FROM DUAL;

-- REPLACE
-- 주어진 문자열을 특정 문자열로 바꾸는 함수

SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

-- 2. 실습
-- EMPLOYEE 테이블에서
-- 사원의 주민등록번호를 확인하여
-- 생년 월일 을 각각 출력해 보세요

-- 이름 | 생년 | 생월 | 생일
-- 홍길 | 00년 | 0월 | 0일

SELECT EMP_NAME 이름,
       SUBSTR(EMP_NO, 1,2)||'년도' 생년,
       SUBSTR(EMP_NO, 3,2)||'월' 생월,
       SUBSTR(EMP_NO, 5,2)||'일' 생일
FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE;

-- SUBSTR을 통해 날짜 데이터도 쪼갤 수 있다.
SELECT EMP_NAME 사원명,
       SUBSTR(HIRE_DATE,1,2) ||'년' 입사년도,
       SUBSTR(HIRE_DATE,4,2) ||'월' "입사 월",
       SUBSTR(HIRE_DATE,7,2) ||'일' "입사 일"
FROM EMPLOYEE;

-- 3. 실습
-- EMPLOYEE 테이블에서
-- 사원의 사번, 사원명, 이메일, 주민등록번호를
-- 출력하되 이메일은 '@' 전까지,
-- 주민등록번호 7번째 자리 이후 부분을 '*'로
-- 채워서 출력하시오.

SELECT EMP_ID 사번,
       EMP_NAME 사원명,
       SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1) 아이디,
       RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE
ORDER BY 사원명;

-- 4. 실습
-- EMPLOYEE 테이블에서
-- 회사에 근무하는 사원 중 여성 사원에 대한 
-- 사번, 사원명, 직급코드를 조회 하시오.
-- ENT_YN : 현재 근무 여부를 파악하는 컬럼 'N'

SELECT EMP_ID, EMP_NAME, JOB_CODE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8,1) = '2'
AND ENT_YN = 'N';


-- 5. 실습
-- EMPLOYEE 테이블에서
-- 직급 코드가 '대리'의 직급 코드를
-- 가지면서 급여가 300 만원 이상 500 만원 이하인
-- 직원들의 사번, 사원명, 관리자 사번을 조회하시오.
-- 직급 정보는 JOB 테이블을 참조하여 확인한다.

SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
AND SALARY BETWEEN 3000000 AND 5000000;

-- 관리자 정보
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE FROM EMPLOYEE
WHERE EMP_ID = '214';


