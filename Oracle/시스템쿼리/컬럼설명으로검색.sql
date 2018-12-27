/*Å×ÀÌ÷ם COMMENT*/
SELECT /*+ CHOOSE */
       b.comments
       ,b.*
  FROM ALL_TAB_COMMENTS b
 WHERE UPPER(b.comments) like '%DEAL%';
;   
   