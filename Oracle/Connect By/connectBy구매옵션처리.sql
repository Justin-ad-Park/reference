select 
       min(ord_no) ord_no
       ,min(prd_no) prd_no
       ,max(POCNFRM_DT) pocnfrm_dt
       ,SUBSTR (MAX (SYS_CONNECT_BY_PATH (SLCT_PRD_OPT_NM, ',')), 2) SLCT_PRD_OPT_NM
       ,sum(decode(tmp,1,ord_qty)) ord_qty
       ,sum(decode(tmp,1,ord_prd_won_stl)) ord_prd_won_stl
       ,min(sel_prc) sel_prc
       ,min(prd_nm) prd_nm
      from          (
                    select a.*
                           ,rownum rnum
                           ,b.tmp
                      from tr_ord_prd a
                           ,(select rownum tmp from tr_ord_prd where rownum <3) b
                     where ord_no = 200911038147416
					   and prd_no = 35761697
					   and ord_prd_stat='901'
                 	   and POCNFRM_DT >= sysdate-30
                      ) a
                  START WITH rnum = 1 CONNECT BY PRIOR rnum = rnum - 2 ; 