-- SELECT 구문 실행 순서
-- 5: SELECT 컬럼명 AS 별칭, 계산식, 함수식
-- 1: FROM 테이블명
-- 2: WHERE 조건
-- 3: GROUP BY 그룹을 묶을 컬럼명
-- 4: HAVING 그룹에 대한 함수식, 조건식
-- 6: ORDER BY 컬럼명|별칭|컬럼 순서 [ASC|DESC] [, 컬럼명....]


SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE='D1';

SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE='D6';

-- GROUP BY 구문
-- 특정 컬럼이나 계산식을 하나의 그룹으로 묶어 한 테이블 내에 소그룹 별로 조회를 수행하는 구문

SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;


-- 7. 실습
-- 부서별 총인원 급여합계 급여평균 최대급여 최소급여
SELECT COUNT(*) 총인원,
     SUM(SALARY),
     TRUNC(AVG(SALARY)),
     MAX(SALARY),
     MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 8. 실습
-- 직급코드, 보너스를 받는 사원수, 직급코드순으로 오름차순
SELECT JOB_CODE,
    COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE ASC;

-- 9. 실습
-- 남성직원수 여성직원수

SELECT DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여') 성별,
    COUNT(*) 직원수
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);


-- HAVING 구문
-- GROUP BY 한 각 소그룹에 대한 조건을 설정하고자 할 때 그룹함수와 함께 사용

SELECT DEPT_CODE,
    AVG(SALARY) 평균
FROM EMPLOYEE
WHERE SALARY>3000000
GROUP BY DEPT_CODE;


SELECT DEPT_CODE,
    FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY)>3000000;


-- 10. 실습
-- 부서 별 그룹의 급여 합계 중 900마넌 초과하는 부서의 코드와 급여합계

SELECT DEPT_CODE 부서코드,
    SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)>9000000;


-- 11. 실습
-- 급여의 합계가 가장 높은 부서를 찾고 해당 부서의 부서코드와 급여합계
SELECT DEPT_CODE 부서코드,
    SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)=(
        SELECT MAX(SUM(SALARY))
        FROM EMPLOYEE
        GROUP BY DEPT_CODE
    ); 



-- 집계 함수
-- ROLLUP : 특정 그룹 별 중간 집계 및 총 집계를 산출하는 함수
-- GROUP BY 구문에서만 사용한다
-- 그룹 별로 묶인 값들에 대해 총 집계 값을 자동으로 계산해 준다

-- 직급 별 급여 합계
SELECT JOB_CODE 직급,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

-- CUBE : 특정 그룹 별 자동집계를 제공하는 함수
-- GROUP BY 구문에서만 사용
-- 각각의 소계 및 총 합계를 자동으로 산출해준다
SELECT JOB_CODE 직급,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- ROLLUP과 CUBE는 사용 형식이 다르지만 한개의 콜롬에 대한 그룹 집계를 계산할 때에는 동일한 결과가 나온다

-- 다중 그룹 지정하기
-- ROLLUP의 경우
-- 인자로 전달한 컬럽 그룹 중 가장 먼저 지정한 그룹 별 집계와 총 합계를 기준으로 동작한다

-- 부서 내 직급별 합계
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;

-- 그룹으로 지정된 모든 그룹에 대한 집계를 계산하여 각 그룹간 집계, 전체집계를 각각 산출하는 함수
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1,2;

-- GROUPING(컬럼명)
-- 자동 집계된 컬럼 값인지 확인하기 위한 함수

SELECT CASE WHEN GROUPING(DEPT_CODE)=1 AND GROUPING(JOB_CODE)=1 THEN '총합계'
            WHEN GROUPING(DEPT_CODE)=0 THEN NVL(DEPT_CODE,'소속부서 없음')
            WHEN GROUPING(DEPT_CODE)=1 THEN '부서별 합계'
            END 부서코드,
        CASE WHEN GROUPING(DEPT_CODE)=1 AND GROUPING(JOB_CODE)=1 THEN '총합계'
            WHEN GROUPING(JOB_CODE)=0 THEN JOB_CODE
            WHEN GROUPING(JOB_CODE)=1 THEN '직급별 합계'
            END 직급코드,
    SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
ORDER BY 1,2;


-- 12. 실습
-- 위에꺼 디코드로





