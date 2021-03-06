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


-- 롤업 큐브
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