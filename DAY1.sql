
-- 한 테이블의 모든 컬럼과 모든 행을 검색(조회)
SELECT * FROM EMPLOYEE;

-- 사원의 ID와 사원명, 연락처
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- 실습 --
-- 1. EMPLOYEE 테이블에서 사번(EMP_ID), 사원명을 조회하시오.

SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

-- WHERE 구문
-- 테이블에서 조건을 만족하는 값을 가진 행을 골라내는 구문
-- 여러 개의 조건을 사용할 경우 AND | OR

-- 부서 코드가 'D6'인 사원의 사번, 사원명, 급여를 조회 하시오.
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- 직급이 'J1'인 사원의 사번, 사원명, 직급 코드, 부서 코드를 조회 하시오.
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';

-- EMPLOYEE 테이블에서 급여가 300만원 이상인 사원의 모든 정보를 조회하시오.
SELECT *
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 조회하는 컬럼명에 별칭달기

-- 1. AS 표현

SELECT EMP_ID AS "사번",
       EMP_NAME AS "사원명"
FROM EMPLOYEE;

-- 2. AS 생략하기

SELECT EMP_ID 사번,
       EMP_NAME 사원명
FROM EMPLOYEE;

-- 컬럼 값을 사용해 산술연산한 연봉 정보를 조회하기
-- 만약 계산에 NULL 값이 들어있다면,
-- 그 값은 어떤 연산을 거쳐도 NULL이 된다.

SELECT EMP_NAME 사원명,
       (SALARY * 12) 연봉,
       ((SALARY + (SALARY * BONUS)) * 12) 연봉총합
FROM EMPLOYEE;

-- NVL() : 만약 현재 조회한 값이 NULL이라면
--         설정한 특정 값으로 변경한다.
-- NVL(컬럼명, 기본값)

SELECT EMP_NAME 사원명,
       SALARY * 12,
       (SALARY + NVL(SALARY * BONUS, 0)) * 12
FROM EMPLOYEE;

-- 리터럴 : 일반 컬럼의 값처럼
--         원하는 값을 반복해서 출력하고자 할 경우
--         그냥 값을 기입하여 표현할 수 있다.

SELECT EMP_NAME 사원명,
       SALARY * 12,
       '원' 단위
FROM EMPLOYEE;

-- DISTINCT
--  만약 해당하는 컬럼의 값이 하나 이상일 경우
--  중복을 제거하고 한 개만 보여준다. (null 포함)

SELECT EMP_NAME 사원명,
       DEPT_CODE 부서코드
FROM EMPLOYEE;

SELECT DISTINCT DEPT_CODE 부서코드
FROM EMPLOYEE;

-- WHERE AND | OR 실습

-- 1. 부서 코드가 'D6' 이면서
--    급여를 200만원보다 많이 받는 직원의 
--    사번, 사원명, 급여를 조회 하시오.

-- SELECT ----> 5 
-- FROM ------> 1
-- WHERE -----> 2
-- GROUP BY --> 3
-- HAVING ----> 4
-- ORDER BY --> 6

SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
  AND SALARY > 2000000;


-- 2. 부서 코드가 'D6'이거나
--    급여를 200만원 보다 많이 받는 직원의
--    사번, 사원명, 부서 코드, 급여를 조회 하시오.

SELECT EMP_ID 사번, 
       EMP_NAME 사원명,
       DEPT_CODE "부서 코드",
       SALARY 급여
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6'
   OR SALARY > 2000000;

-- 연결 연산자 '||'
--  여러 컬럼의 값이나 특정 리터럴을 하나의 컬럼으로 묶어서 표현
--  하고자 할 경우 사용하는 연산자.
--  사용하는 데이터의 포맷을 특정 포맷으로 맞추어 다른 애플리케이션에게
--  전달하고자 할 때 사용한다.

-- '사번'을 가진 사원의 이름은 'OOO'입니다.

SELECT EMP_ID || '을 가진 사원의 이름은 ' || EMP_NAME ||'입니다.'
FROM EMPLOYEE;


-- 비교 연산자
-- = 같다 / !=, <>, ^= 같지 않다
-- >, <, >=, <= 부등호도 사용할 수 있다.

-- EMPLOYEE 테이블에서 부서코드가 'D9'이 아닌 직원들의
-- 모든 정보를 조회하시오.

SELECT * FROM EMPLOYEE
-- WHERE DEPT_CODE <> 'D9';
-- WHERE DEPT_CODE ^= 'D9';
WHERE DEPT_CODE != 'D9';

-- EMPLOYEE 테이블에서 SALARY가 
-- 350만원 이상 550만원 이하인 직원의
-- 사번, 사원명, 부서코드, 직급코드, 급여를 
-- 조회 하시오.

-- 1. BETWEEN A AND B 를 사용하지 않을 경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000
AND   SALARY <= 5500000;

-- 2. BETWEEN A AND B 를 사용할 경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 5500000;

-- 위와 동일한 직원 정보를 조회하되
-- 350 미만이거나 550 을 초과할 경우

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3500000 AND 5500000;

-- LIKE :
--   입력한 문자 혹은 숫자가 포함된 값을 조회하기 위한 연산자
--   '%' : 몇자리 문자든 관계 없이
--   '_' : 반드시 한 개

-- 사원 중 이름 가운데 글자가 '중'이 들어가는
-- 사원의 사번, 사원명을 조회하시오.

SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%중%';

-- 사원 중 주민등록번호 기준
-- 남성인 사원만 조회하시오.

SELECT * FROM EMPLOYEE
WHERE EMP_NO LIKE '______-1%';

-- 사원 중 이메일 아이디가 
-- 5글자를 초과하는 사원을 찾아
-- 해당 사원의 사번, 사원명, 이메일을 조회 하시오.

SELECT * FROM EMPLOYEE
WHERE EMAIL LIKE '______%@%';

-- 사원 중 이메일의 4번째 자리가 '_'인 사원을
-- 제외한 모든 사원의 사번, 사원명, 이메일을 조회 하시오.
-- ESCAPE 문자 선언하기, 자바의 '역슬래쉬' 처럼
-- 뒤에 올 특수 문자를 일반 문자로 변경하는 명령어

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL NOT LIKE '___#_%' ESCAPE '#';

-- EMPLOYEE 테이블에서
-- 이씨 성을 가진 직원의 사번, 사원명, 부서코드, 근무여부(ENT_YN)를
-- 조회하시오.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, ENT_YN
FROM EMPLOYEE
WHERE EMP_NAME LIKE '이%';


-- IN 연산자
--    IN (값1, 값2 . . . .)
--    주어진 값들과 하나라도 일치하는 값이 있을 때
--    해당 정보를 출력하는 연산자.

-- 부서코드가 'D1'이거나 'D6'인 사원들의
-- 사번, 사원명, 직급, 부서코드, 급여를 조회 하시오.

SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D1', 'D6');

SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D1', 'D6');


-- 연산자의 우선순위
-- 1. 산술 연산자
-- 2. 연결 연산자
-- 3. 비교 연산자
-- 4. IS NULL / IS NOT NULL, LIKE, IN / NOT IN
-- 5. BETWEEN A AND B / NOT BETWEEN
-- 6. NOT
-- 7. AND
-- 8. OR


-- 1. 직급이 'J2' 직급이면서 200만원 이상 받는 직원 이거나,
--    직급이 'J7' 직급인 직원의 사번, 사원명, 직급코드, 급여를 조회 하시오.

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' 
  AND SALARY >= 2000000
   OR JOB_CODE = 'J7';


-- 2. 직급이 'J7' 이거나 'J2' 이면서 200만원 이상 받는 직원의
--    사번, 사원명, 직급코드, 급여를 조회 하시오.

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7'
   OR JOB_CODE = 'J2')
  AND SALARY >= 2000000;





