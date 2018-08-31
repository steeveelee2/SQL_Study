-- 데이터 딕셔너리

-- 현재 접속한 사용자 계정(세션) 정보 확인하기
SELECT * FROM V$SESSION;

SELECT * FROM SYS.ALL_ALL_TABLES WHERE OWNER='EMPLOYEE';