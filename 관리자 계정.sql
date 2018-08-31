-- 사용자 계정을 생성할 때
-- CREATE USER 사용자명 IDENTIFIED BY 비밀번호;

-- 이후 사용자가 접속가능케 권한을 설정해 주어야 한다
-- 이때 쓰는 명령어 스크립트
-- GRANT CONNECT, RESOURCE TO 사용자명;

-- 한 줄 주석
/*
여러 줄 주석
*/


CREATE USER EMPLOYEE IDENTIFIED BY EMPLOYEE;
-- 비밀번호는 대소문자 구분함
GRANT CONNECT, RESOURCE TO EMPLOYEE;
