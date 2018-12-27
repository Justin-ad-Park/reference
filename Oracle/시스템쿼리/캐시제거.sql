10g 이상 버전이라면.. 
alter system flush buffer_cache;
 
그 이전 버전이라면.. 
alter session set events = ‘immediate trace name flush_cache’;
 
참고로 shared pool을 삭제하고 싶다면.. (sql 파싱된 것도 속도에 아주 약간 영향을 미칩니다)
alter system flush buffer_pool;
 

 

 
