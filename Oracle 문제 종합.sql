-- 1. 여자 사원들 중에 직급이 대리가 아닌 사원명, 직급명, 부서명, 급여를 출력하세요
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, SALARY 급여
FROM EMPLOYEE E JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE AND JOB_NAME!='대리') JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE SUBSTR(EMP_NO,8,1)=2;

-- 2. 직급이 대리이며 성별은 남자의 나이와 연봉(보너스 금액 포함)이 1000만원이 넘는 직원을 조회하세요
SELECT EMP_NAME 사원명, DEPT_TITLE 부서, JOB_NAME 직금, SALARY*12*(1+NVL(BONUS,0)) 연봉,
    TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(EMP_NO,1,6)))/12) 나이
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID) JOIN JOB USING(JOB_CODE)
WHERE SUBSTR(EMP_NO,8,1)=1 AND SALARY*12*(1+NVL(BONUS,0))>10000000;

-- 3. KH컴퍼니 사내 이벤트에 당첨된 부서인 해외영업1부 사원들을 조회하고자 한다
--    해외영업1부에 근무하는 사원들의 이름과 부서명, 생년월일(주민번호 앞 번호로 대체),핸드폰번호를 조회하시오(단, 핸드폰 번호 가운데 자리는 *로 가림)
SELECT EMP_NAME 이름, DEPT_TITLE 부서명,
    SUBSTR(EMP_NO,1,6) 생년월일,
    CONCAT(RPAD(SUBSTR(PHONE,1,3),DECODE(SUBSTR(PHONE,1,3),'010',7,6),'*'),SUBSTR(PHONE,-4,4)) 휴대폰번호
FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID AND DEPT_TITLE='해외영업1부');

-- 4. 매니저 아이디가 존재하며 아시아에서 근무하지 않는 직원의 사번, 사원명, 부서명, 근무지역명, 최소급여 대비 인상률을 출력하시오 (인상률 계산 : (M-N)/N*100 )
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 근무지역명, ROUND((SALARY-MIN_SAL)/MIN_SAL*100,1) 인상률
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE AND LOCAL_NAME NOT IN('ASIA%')) JOIN SAL_GRADE USING(SAL_LEVEL)
WHERE MANAGER_ID IS NOT NULL;

-- 5. 해외영업부에 근무하는 직원들의 사원번호, 사원명, 부서명을 조회하시오
SELECT EMP_ID 사원번호, EMP_NAME 사원명, DEPT_TITLE 부서명
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID AND DEPT_TITLE LIKE '해외영업%');

-- 6. 2000년 이후에 입사한 '남자 사원'의 사번, 이름, 주민번호, 입사일, 직급코드, 급여를 조회하시오
--    (단, 나이 기준 내림차순, 주민번호 뒷 6자리를 '*'로, 급여는 통화기호를 붙인다.)
SELECT EMP_ID 사번, EMP_NAME 사원명,
    RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호, HIRE_DATE 입사일, JOB_CODE 직급코드, TO_CHAR(SALARY,'L999,999,999,999') 급여
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE)>2000 AND SUBSTR(EMP_NO,8,1)=1;

-- 7. 핸드폰 번호에 숫자 4와 2가 2번 이상씩 포함되는 직원의 사번, 사원명, 핸드폰번호를 조회하시오
SELECT EMP_ID 사번, EMP_NAME 사원명, PHONE 휴대폰번호
FROM EMPLOYEE
WHERE PHONE LIKE('%4%4%') AND PHONE LIKE('%2%2%');

-- 8. 현재 부장들의 근속년수의 평균을 구하시오 근속년수는 12개월을 1년으로 계산하며, 나머지 개월 수는 포함하지 않는다
SELECT TRUNC(AVG(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)) "부장 평균 근속년수"
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE=J.JOB_CODE AND JOB_NAME='부장');

-- 9. EMPLOYEE 테이블에서 재직여부를 확인해서 현재 날짜와 비교해서 재직 중이면 근속년수를,퇴사했으면 퇴사한지 몇 년되었는지 출력하세요
--    입사날짜가 빠른 순으로 정렬하고 입사날짜가같으면 사원번호로 정렬하세요(전체 사원) 단, 년차는 개월 수로 계산하지 않고 년도로만 계산한다
SELECT EMP_ID 사번, EMP_NAME 사원명, HIRE_DATE 입사일,
    DECODE(ENT_YN,'N','X',ENT_DATE) 퇴사여부,
    DECODE(ENT_YN,'N','입사 '||TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)||'년차',
        CEIL(MONTHS_BETWEEN(SYSDATE,ENT_DATE)/12)||'년 전 퇴사') 근속년수
FROM EMPLOYEE
GROUP BY EMP_ID, EMP_NAME, HIRE_DATE, DECODE(ENT_YN,'N','X',ENT_DATE), ENT_YN, 'N', 'X', ENT_DATE,
    DECODE(ENT_YN,'N','입사 '||TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)||'년차', 
    CEIL(MONTHS_BETWEEN(SYSDATE,ENT_DATE)/12)||'년 전 퇴사')
ORDER BY 3 DESC, 1 ASC;

-- 10. 부서마다 여성직원이 몇 명인지 구하시오
SELECT DEPT_CODE 부서코드, COUNT(*) "여성직원 수"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)=2
GROUP BY DEPT_CODE;

-- 11. 부서별 평균 급여와 합계를 계산하고 부서명, 부서별 최대급여, 최소급여, 평균급여,급여합계를 조회하시오
--     단, 금액은 ￦99,999,999 형식으로 표시하시오
SELECT DEPT_TITLE 부서명,
    TO_CHAR(MAX(SALARY),'L999,999,999,999') 최대급여,
    TO_CHAR(MIN(SALARY),'L999,999,999,999') 최소급여,
    TO_CHAR(AVG(SALARY),'L999,999,999,999') 평균급여,
    TO_CHAR(SUM(SALARY),'L999,999,999,999') 급여합계
FROM DEPARTMENT JOIN EMPLOYEE ON (DEPT_ID=DEPT_CODE)
GROUP BY DEPT_TITLE;

-- 12. 이오리 사원보다 직급이 높으면서 낮은 급여를 받는 직원 중
--     핸드폰 4,5,8,10번째 자리가 7인 사원의 이름, 부서명, 직급명, 급여를 조회 해보자 (급여 포맷은 ￦99,999,999 형식)
SELECT M.EMP_NAME 이름, DEPT_TITLE 부서명, J.JOB_NAME 직급명, TO_CHAR(M.SALARY,'L999,999,999,999') 급여
FROM EMPLOYEE E
JOIN EMPLOYEE M ON(E.JOB_CODE>M.JOB_CODE AND E.SALARY>M.SALARY AND E.EMP_NAME='이오리' AND M.PHONE LIKE('___77__7_7_'))
JOIN DEPARTMENT ON(M.DEPT_CODE=DEPT_ID) JOIN JOB J ON(M.JOB_CODE=J.JOB_CODE);

-- 13. SELF JOIN을 이용해 임시환씨보다 늦게 입사한 사원의 이름과 입사일을 출력하시오 (입사일 기준 오름차순)
SELECT M.EMP_NAME 사원명, M.HIRE_DATE 입사일
FROM EMPLOYEE E JOIN EMPLOYEE M ON(E.HIRE_DATE<M.HIRE_DATE AND E.EMP_NAME='임시환');

-- 14. 같은 부서, 같은 직급에서 월급이 가장 적은 직원의 월급과 가장 많이 받는 직원의 월급을 출력하시오
--     또한 퇴사자는 제외하고, 월급은 보너스까지 적용한 걸 기준으로 한다 단 해당 부 서에 해당직급의 직원이 여러 명일 경우만 출력하시오
--     (EX. D9 부서에 J2가 2명, J1이 1명 있으므로 J2만 비교할 것)
SELECT DEPT_CODE 부서코드, JOB_CODE 직급코드, MIN(SALARY*(1+NVL(BONUS,0))) 최소연봉, MAX(SALARY*(1+NVL(BONUS,0))) 최고연봉
FROM EMPLOYEE
WHERE ENT_YN='N'
GROUP BY DEPT_CODE, JOB_CODE
HAVING MIN(SALARY*(1+NVL(BONUS,0)))!=MAX(SALARY*(1+NVL(BONUS,0)));

-- 15. 각 부서별 인원에 대한 평균 연봉 구해서 부서 순위를 정하려고 한다
--     부서가 NULL인 사원 은 제외하고, 부서 평균 연봉을 소수점 둘째자리까지 반올림한 후, 내림차순으로 정렬하여 조회 하시오
SELECT DEPT_CODE 부서번호, DEPT_TITLE 부서이름, COUNT(*) 인원수, ROUND(AVG(SALARY),2) 평균연봉
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE DEPT_CODE IS NOT NULL
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY 평균연봉 DESC;

-- 16. EMPLOYEE 테이블에서 부서코드가 'D9', 'D5', 'D2'인 부서 중 1994년도에 입사한 직원의 사 원명, 부서코드, 입사일을 조회하되,
--     관리부서가 'D9' 면 총무부, 'D5' 면 해외영업1부, 'D2' 이 면 회계관리부로 출력하고, 사원명을 기준으로 내림차순 하시오
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, HIRE_DATE 입사일
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID AND DEPT_CODE IN('D9','D5','D2'))
WHERE EXTRACT(YEAR FROM HIRE_DATE)=1994
ORDER BY 사원명 DESC;

-- 17. 퇴직금 계산 1달마다 봉급의 10%, 보너스 없는 직원은 퇴직금 없음, 부장 +10%, 과장 15%, 대표 20%로 하며 사번, 이름, 연봉, 근속개월, 퇴직금 조회
SELECT EMP_ID 사번, EMP_NAME 이름, TO_CHAR(SALARY*(1+NVL(BONUS,0)),'L999,999,999,999') 연봉, TRUNC(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) 근속개월, 
    DECODE(BONUS,NULL,'없음',TO_CHAR(ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)*(SALARY/10)*DECODE(JOB_NAME,'부장',1.1,'과장',1.5,'대표',1.2,1),-3),'L999,999,999,999')) 퇴직금
FROM EMPLOYEE JOIN JOB USING(JOB_CODE);

-- 18. 직급이 대리이고, EU에서 근무하는 직원의 이름, 부서명, 근무지역 이름(한국어)을 조회하세요
SELECT EMP_NAME, DEPT_TITLE 부서명, NATIONAL_NAME 국가명
FROM EMPLOYEE E JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE AND LOCAL_NAME='EU')
JOIN NATIONAL USING(NATIONAL_CODE) JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE AND JOB_NAME='대리');

-- 19. 사원의 사번, 사원명, 급여와 관리자번호, 관리자명, 사원의 부서, 관리자의 부서를 사번 기준 오름차순으로 정렬하여 조회하시오
SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, E.SALARY 급여, E.MANAGER_ID 관리자번호, M.EMP_NAME 관리자명, DE.DEPT_TITLE 사원부서, DM.DEPT_TITLE 관리자부서
FROM EMPLOYEE E JOIN EMPLOYEE M ON(E.MANAGER_ID=M.EMP_ID) JOIN DEPARTMENT DE ON(E.DEPT_CODE=DE.DEPT_ID) JOIN DEPARTMENT DM ON(M.DEPT_CODE=DM.DEPT_ID)
ORDER BY 1 ASC;

-- 20. 입사년도가 1996년 이후인 사원들의 월급의 합을 부서별, 직급별로 부서코드, 직급명, 월급의 합을 조회하시오
--     단, 부서코드의 NULL값은 '그외 부서'로 처리하고 부서코드 오름차순 정렬하시오
SELECT NVL(DEPT_CODE,'그외 부서') 부서코드, JOB_NAME 직급명, SUM(SALARY) 월급합계
FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM HIRE_DATE)>1996
GROUP BY NVL(DEPT_CODE,'그외 부서'), DEPT_CODE, '그외 부서', JOB_NAME;

-- 21. 김해술보다 후에 고용된 직원들의 이름과 고용일을 조회하되, SUB QUERY로 작성하고, 고용 일을 기준으로 내림차순 한다
SELECT EMP_NAME 이름, HIRE_DATE 고용일
FROM EMPLOYEE
WHERE HIRE_DATE>(SELECT HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME='김해술')
ORDER BY 2 DESC;

-- 22. 부서별 평균 보너스율을 조회하여 부서이름, 평균 보너스율 출력하세요
--     단, 부서이름이  없으면( DEPT_NONE)출력,평균 값은 소수점 둘째자리에서 버림
SELECT NVL(DEPT_TITLE,'DEPT_NONE') 부서이름, TRUNC(AVG(NVL(BONUS,0)),2) 평균보너스
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
GROUP BY NVL(DEPT_TITLE,'DEPT_NONE');

-- 23. 부서코드가 D1 , D2 , D7 인 사원의 사원명, 연봉, 부서이름을 구하고 부서명 오름차순, 부서 가 같다면 연봉 내림차순으로 정렬
--     단, 연봉은 ￦100,000,000 형식을 사용
SELECT EMP_NAME 사원명, TO_CHAR(SALARY*(1+NVL(BONUS,0)),'L999,999,999,999') 연봉, DEPT_TITLE 부서이름
FROM EMPLOYEE JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID AND DEPT_CODE IN('D1','D2','D7'))
ORDER BY 3 ASC, 2 DESC;

-- 24. 입사기간이 10년 이상인 대리는 퇴직 연금으로 연봉 * 입사기간/100 의 금액을 받는다
--     올해까지 일하여 퇴직금을 포함한다고 하였을 때, 회사에서 받은 총 급여를 조회하시오
SELECT EMP_NAME 사원명, JOB_NAME 직급, HIRE_DATE 입사일,
    TO_CHAR(TRUNC(SALARY*(1+NVL(BONUS,0))*(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12)
    +SALARY*(1+NVL(BONUS,0))*(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/1200),0),'L999,999,999,999') "총급여(퇴직금 포함)"
FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12>10;

-- 25. 입사한지 가장 오래된 직원의 입사년도와 해당 직원의 사번, 사원명, 부서코드, 직급코드, 급여를 조회하시오
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_CODE 부서코드, JOB_CODE 직급코드, SALARY 급여, HIRE_DATE 입사일
FROM EMPLOYEE
WHERE HIRE_DATE=(SELECT MIN(HIRE_DATE) FROM EMPLOYEE);

-- 26. 휴대폰번호 뒷자리중 앞 두자리가 44 인 회원의 이름, 직급, 휴대폰번호, 관리자 이름을 출력하세요
SELECT E.EMP_NAME 사원명, JOB_NAME 직급, E.PHONE 휴대폰번호, M.EMP_NAME 관리자이름
FROM EMPLOYEE E JOIN JOB USING(JOB_CODE) JOIN EMPLOYEE M ON(E.MANAGER_ID=M.EMP_ID)
WHERE SUBSTR(E.PHONE,-4,2)='44';
