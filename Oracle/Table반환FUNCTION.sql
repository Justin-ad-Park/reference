-- 참고
-- http://www.databasejournal.com/features/oracle/article.php/2222781#fig1

CREATE OR REPLACE PACKAGE P_CORR_DATA is
  type tab_CORR_DATA is record (ID VARCHAR2(10), BSDT VARCHAR2(8), KEYID VARCHAR2(10), KEYVAL NUMBER(12,8));
  type tab_CORR_DATA_table is table of tab_CORR_DATA;
END P_CORR_DATA;
/

CREATE OR REPLACE FUNCTION F_CORR_DATA(CLASS1 VARCHAR2, CLASS2 VARCHAR2, SDATE VARCHAR2, EDATE VARCHAR2)
                           RETURN P_CORR_DATA.tab_CORR_DATA_table PIPELINED IS
TYPE         ref0 IS REF CURSOR;
cur0         ref0;
v_CLASS1     VARCHAR2(10);
v_CLASS2     VARCHAR2(10);
v_SDATE      VARCHAR2(8);
v_EDATE      VARCHAR2(8);
out_rec      P_CORR_DATA.tab_CORR_DATA; -- := MY_TYPES2.tab_CORR_DATA(NULL,NULL,NULL,0);
BEGIN
v_CLASS1 := CLASS1;
v_CLASS2 := CLASS2;
v_SDATE  := SDATE;
v_EDATE  := EDATE;

OPEN cur0 FOR 'select ID, BSDT, KEYID, KEYVAL from CDMCORR where (ID = :1 or ID= :2) and (BSDT >= :3 and BSDT <= :4)' USING v_CLASS1, v_CLASS2, v_SDATE, v_EDATE;
  LOOP
    FETCH cur0 INTO out_rec.ID, out_rec.BSDT, out_rec.KEYID, out_rec.KEYVAL;
    EXIT WHEN cur0%NOTFOUND;
    PIPE ROW(out_rec);
  END LOOP;
CLOSE cur0;

RETURN;
END F_CORR_DATA;
/

commit

-- 테스트
select * from table(F_CORR_DATA('EUR', 'EUR', '20020101', '20021231'))