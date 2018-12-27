/*
LP_DP_LCTGR_SUB8_L('1234', 1, 120);
*/
declare 
    arg_disp_spce_cd VARCHAR2(10);
    arg_first_num NUMBER;
    arg_last_num NUMBER;
    TYPE typ_numbers IS TABLE OF NUMBER;
    v_DISP_ADVRT_NOs    typ_numbers;
    v_Totz_Date         ST_IF_BEST_PRD.TOTZ_DATE%TYPE;

BEGIN

    arg_disp_spce_cd := '1234';
    arg_first_num := 1;
    arg_last_num := 120;
    
    DBMS_OUTPUT.PUT_LINE('카테고리번호1 : '|| arg_first_num);
    
    select 1 / 0 into arg_first_num from dual;
    
    --insert 문 등...
    

    DBMS_OUTPUT.PUT_LINE('카테고리번호2 : '|| arg_first_num);

    commit;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[오류발생]' || SQLERRM);
        
END;