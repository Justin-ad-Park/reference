-- 락걸린 테이블 확인

SELECT  do.object_name,  do.owner,  do.object_type,  do.owner,
  vo.xidusn,  vo.session_id,  vo.locked_mode
FROM 
  v$locked_object vo ,  dba_objects do
WHERE   vo.object_id = do.object_id ;
  
  
--해당테이블이 락에 걸렸는지..  

SELECT   A.SID,  A.SERIAL#,  B.TYPE,  C.OBJECT_NAME
FROM   V$SESSION A,  V$LOCK B,  DBA_OBJECTS C
WHERE   A.SID=B.SID AND  B.ID1=C.OBJECT_ID 
   AND  B.TYPE='TM'  AND  C.OBJECT_NAME IN ('MT_EVT_OPEN_PROMO_COMM_PRD');
    
 
 /* 락발생 사용자와 sql, object 조회 */

SELECT   distinct x.session_id,  a.serial#,
  d.object_name,  a.machine,  a.terminal,
  a.program,  b.address,  b.piece,  b.sql_text
FROM  v$locked_object x,  v$session a,  v$sqltext b,  dba_objects d
WHERE  x.session_id = a.sid  and
  x.object_id = d.object_id  and
  a.sql_address = b.address  
order by OBJECT_NAME, b.address,b.piece;

 
/* 락 발생 사용자확인 */

SELECT   distinct x.session_id,  a.serial#,
  d.object_name,  a.machine,  a.terminal,  a.program,
  a.logon_time ,  'alter system kill session ''' || a.sid || ',  ' || a.serial# || ''';'
FROM   gv$locked_object 
x, gv$session a,  dba_objects d
WHERE   x.session_id = a.sid  and  x.object_id = d.object_id 
order by d.object_name, logon_time;  


/* RDS 락 발생 사용자확인 및 Kill 명령 생성 */
SELECT   distinct x.session_id,  a.serial#,
  d.object_name,  a.machine,  a.terminal,  a.program,
  a.logon_time ,  'exec rdsadmin.rdsadmin_util.kill( ' || a.sid || ',  ' || a.serial# || ';'
FROM   gv$locked_object 
x, gv$session a,  dba_objects d
WHERE   x.session_id = a.sid  and  x.object_id = d.object_id 
order by d.object_name, logon_time;  


/* 접속 사용자 제거 */

--alter system kill session 'session_id,serial#';
--alter system kill session '26,6044'; 


/* 현재 접속자의 sql 분석 */
SELECT   distinct a.sid,  a.serial#,
  a.machine,  a.terminal,  a.program,
  b.address,  b.piece,  b.sql_text
FROM   v$session a,  v$sqltext b
WHERE   a.sql_address = b.address 
    --and a.sid = 167
order by a.sid, a.serial#,b.address,b.piece;
;

SELECT   distinct a.sid,  a.serial#,
  a.machine,  a.terminal,  a.program,
  b.address,  b.piece,  b.sql_text
FROM   v$session a,  v$sqltext b
WHERE   a.sql_address = b.address 
order by a.sid, a.serial#,b.address,b.piece;

/* 현재 실행중인 SQL 분석 */
SELECT   distinct a.sid,  a.serial#,
  a.machine,  a.terminal,  a.program,
  b.address,  b.piece,  b.sql_text
FROM   v$session a,  v$sqltext b
WHERE   a.sql_address = b.address 
    --and a.sid = 167
    --and v$sqltext like '%%'
--order by a.sid, a.serial#,b.address,b.piece;
;



-- Kill session in RDS
execute RDSADMIN.rdsadmin_util.kill(11331, 56409);

