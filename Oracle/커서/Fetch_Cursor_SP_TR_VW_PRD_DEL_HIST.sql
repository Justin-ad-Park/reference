CREATE OR REPLACE PROCEDURE GLOBAL.(days IN NUMBER)
IS
	c_name              CONSTANT VARCHAR2(100) := 'SP_TR_VW_PRD_DEL_HIST'; 
    c_sysdate           CONSTANT DATE          := SYSDATE; 
    c_title             CONSTANT VARCHAR2(100) := 'TR_VW_PRD LOG DELETE'; 
    c_author            CONSTANT VARCHAR2(100) := 'ANDIKA'; 
    c_part              CONSTANT VARCHAR2(100) := 'CP'; 
    v_delete_cnt                 NUMBER := 0;
	v_batch_no                   NUMBER := 30000;

	TYPE typ_numbers IS TABLE OF NUMBER;
	v_VW_PRD_SEQ typ_numbers;
	
	LOOP_CNT NUMBER := 0;
    LIMIT_ROWS NATURAL := 100;
    
	/* Declare Cursor */
    CURSOR s1 IS
    SELECT /*+ INDEX(A IX3_TR_VW_PRD) */	
	       VW_PRD_SEQ
      FROM TR_VW_PRD A
	 WHERE VW_DT < SYSDATE-days
	;
	 
BEGIN

  DBMS_APPLICATION_INFO.SET_MODULE(c_name,'');
  
  /* Duplication Execute Check */
  IF FN_IS_BATCH_APP_RUNNING(v_batch_no) = 'Y' THEN
     SP_SY_BATCH_APP_LOG(v_batch_no, SYSDATE, SYSDATE, '-1', 'Duplication Exec', 'START', 'Y', c_name || ' : FAIL', c_name || ' : FAIL');
  ELSE
     SP_SY_BATCH_APP_START(v_batch_no, c_name);
	 
     OPEN s1;
  
	 /* Bulk Insert - 100rows */
	 LOOP FETCH s1 BULK COLLECT INTO v_VW_PRD_SEQ 
     LIMIT limit_rows;
	 
	 LOOP_CNT := LOOP_CNT + 1;

	   FORALL i in v_VW_PRD_SEQ.FIRST .. v_VW_PRD_SEQ.LAST
	   DELETE /*+ INDEX(T PK_TR_VW_PRD) */
		 FROM TR_VW_PRD T
		WHERE VW_PRD_SEQ = v_VW_PRD_SEQ(i)
		;
		
	   v_delete_cnt := v_delete_cnt + TO_NUMBER(SQL%ROWCOUNT);
		
	   COMMIT;
		
	   EXIT WHEN s1%NOTFOUND ;
		
	 END LOOP;
	  
	 CLOSE s1;
	  
	 COMMIT;
	 
	 SP_SY_LOG(c_name, c_title,c_sysdate,sysdate,c_part,c_author,sqlcode,sqlerrm,'('||v_delete_cnt||') ROWS DELETE'); 
	 SP_SY_BATCH_APP_END(v_batch_no, SQLCODE, SQLERRM, 'END', 'N', c_name || ' : batch success', '');
  
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    SP_SY_LOG(c_name, c_title, c_sysdate, sysdate, c_part, c_author, sqlcode, sqlerrm, c_name || ' : FAIL'); 
    SP_SY_BATCH_APP_END(v_batch_no, SQLCODE, SQLERRM, 'ERR LOCATION', 'Y', c_name || ' : FAIL', '');

    COMMIT;

END;