-- DAY 6

-- 서브쿼리(SUB QUERY)
-- 주가 되는 쿼리문 안에 하나의 조건이나 검색을 위한 부가적인 쿼리문을 작성할 수 있는데 이를 서브쿼리라고 말한다

-- EX) 노옹철 사원의 부서 코드를 조회하고 해당 부서에 근무하는 직원들의 정보를 조회하시오
-- 1
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME='노옹철';
-- 2
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE='D9';
-- 서브쿼리로 한방에
-- 바깥 쿼리가 주 쿼리 혹은 메인쿼리 안에있는 쿼리는 부가쿼리 혹은 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE=(
        SELECT DEPT_CODE
        FROM EMPLOYEE
        WHERE EMP_NAME='노옹철'
    );

-- 서브쿼리의 유형
-- 단일 행 서브쿼리 : 서브쿼리의 결과가 1개 나오는 쿼리
--                  컬럼명|계산식=(서브쿼리) (1:1)
-- 다중 행 서브쿼리 : 서브쿼리의 결과가 여러개 나오는 쿼리
--                  컬럼명|계산식 IN('D1,'D2','D3'....) (1:N)
-- 다중 열 서브쿼리 : 서브쿼리의 조회 결과의 컬럼 갯수가 여러개일때
--                  컬럼명 [, 컬럼명] = ('노옹철','D9') (N:M)
-- 다중 행 다중 열 서브쿼리 : 조회 결과의 행과 열 수가 여러개일떄

-- 서브쿼리는 그 유형에 따라 사용되는 연산자가 다르다

-- 단일 행 서브 쿼리
-- 단일 행 서브쿼리 앞에는 일반 연산자를 사용할 수 있다
-- >, <, >=, <=, =, !=, ^=, <> (서브쿼리)

-- 1. 실습
-- 노옹철 사원의 급여보다 많이 받는 놈 정보
-- 사번, 이름 부서 직급 급여
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_CODE 부서,
    JOB_CODE 직급,
    SALARY 급여
FROM EMPLOYEE
WHERE SALARY>(
    SELECT SALARY
    FROM EMPLOYEE
    WHERE EMP_NAME='노옹철'
    );
    
-- 2. 실습
-- 사내 돈 가장 못버는 찐따의 사번, 사원명,급여정보
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    SALARY 급여
FROM EMPLOYEE
WHERE SALARY=(
    SELECT MIN(SALARY)
    FROM EMPLOYEE
    );
-- 서브쿼리를 활용하여 그룹함수의 값을 일반 조회문에도 활용할 수 있다

-- 서브 쿼리는 SELECT, FROM, WHERE, HAVING 구문에서도 사용할 수 있다

-- 3. 실습
-- 부서별 급여의 합계 중 합계가 가장 큰 부서의 부서명, 급여합계
-- 1) 서브쿼리 완성시킨다
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 2) 메인쿼리를 완성하고 조건이되는 부분을 ()로 남겨둔다
SELECT DEPT_TITLE,
    SUM(SALARY)
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY)=();

-- 3) 합체
SELECT DEPT_TITLE,
    SUM(SALARY)
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY)=(
    SELECT MAX(SUM(SALARY))
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
);


-- 다중 행 서브쿼리 : 결과값이 여러개
-- 다중행 서브쿼리 앞에는 일반연산자를 사용불가
-- IN / NOT IN : 여러 개의 결과값 중 한 개라도 일치하는 값이 있을 / 없을 경우를 판별하는 연산자
-- > ALL / < ALL : 여러개의 결과값 전부가 현재 비교하는 값보다 크거나 작은 경우를 비교하는 연산자
-- EX) 100>ALL(10,20,30)
--     100<ALL(200,300,1000)
-- ALL() 안에 포함된 값 중에 가장 큰 값보다 크거나 가장 작은 값보다 작을 경우 판별한다

-- > ANY / < ANY : 여러 결과값 중 어느 하나라도 크거나 작을 경우 판별
-- EXISTS / NOT EXISTS : 해당하는 ㄱ밧이 존재하는지 안하는지 판별

-- 부서 별 최고 급여를 받는 직원의 사원명, 직급, 부서, 급여
SELECT EMP_NAME,
    JOB_CODE,
    DEPT_CODE,
    SALARY
FROM EMPLOYEE
WHERE SALARY IN(
    SELECT MAX(SALARY)
    FROM EMPLOYEE
    GROUP BY DEPT_CODE
);

-- 4. 실습
-- 모든 사원들의 정보를 조회하되 해당하는 사원이 관리자인지 확인하여 조회하셈
-- 사번 이름 부서명 직급 관리자
-- 관리자와 일반 사원의 정보를 각각 쿼리문으로 조회하여 두 개의 결과를 UNION

SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    JOB_NAME 직급명,
    DECODE(MANAGER_ID,NULL,'O','X') "관리자 여부"
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN JOB USING(JOB_CODE)
ORDER BY 5;


SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    JOB_NAME 직급명,
    '관리자' "관리자 여부"
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN JOB USING(JOB_CODE)
WHERE EMP_ID IN(
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
)
UNION
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    JOB_NAME 직급명,
    '직원' "관리자 여부"
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN JOB USING(JOB_CODE)
WHERE EMP_ID NOT IN(
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL
)
ORDER BY 5;

-- SELECT 구문에서 관리자 여부를 서브쿼리르 판단할 경우

SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    DEPT_TITLE 부서명,
    JOB_NAME 직급명,
    CASE WHEN EMP_ID IN(SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEE
    WHERE MANAGER_ID IS NOT NULL) THEN '관리자'
    ELSE '직원' END 구분
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN JOB USING(JOB_CODE)
ORDER BY 구분;

-- 5. 실습
-- 자기 직급의 평균 급여를 받는 직원의 사번, 사원명, 직급, 급여
-- 급여 평균은 만원단위로 계산

SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 직급,
    SALARY 급여
FROM EMPLOYEE
WHERE SALARY IN(
    SELECT TRUNC(AVG(SALARY),-5)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
);

-- 직급 코드가 다른 직원임에도 불구하고 직급 평균에 해당하는 급여를 받는 직원이 같이 조회된다

-- 다중 행 다중 열 서브쿼리

SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 직급,
    SALARY 급여
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN(
    SELECT JOB_CODE, TRUNC(AVG(SALARY),-5)
    FROM EMPLOYEE
    GROUP BY JOB_CODE
);

-- 6.실습
-- 퇴사한 여직원이 있음 해당 직원과 같은 부서 같은 직급에 해당하는 사원 조회
SELECT EMP_ID 사번,
    EMP_NAME 사원명,
    JOB_CODE 직급코드,
    DEPT_CODE 부서코드,
    HIRE_DATE 입사일
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN (
    SELECT DEPT_CODE, JOB_CODE
    FROM EMPLOYEE
    WHERE ENT_YN='Y'
) AND ENT_YN='N';






-- DDL (CREATE)

-- CREATE : 데이터베이스의 객체를 생성하는 명령어(DDL)
CREATE TABLE TEST(
    COL_ID NUMBER,
    COL_DATA VARCHAR2(30)
);

COMMENT ON COLUMN TEST.COL_ID IS '테스트컬럼1';
COMMENT ON COLUMN TEST.COL_DATA IS '테스트컬럼2';
























