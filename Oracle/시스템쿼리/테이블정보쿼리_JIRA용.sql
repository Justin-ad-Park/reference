/*테이블 COMMENT JIRA용 */ 
SELECT /*+ CHOOSE */
       'h4. \[' || table_name || '\] : ' || b.comments
  FROM ALL_TAB_COMMENTS b
 WHERE table_name = :TABLE_NAME

 UNION ALL 

/*테이블 컬럼 리스트 JIRA용 */
-- JIRA용
select '\\
|| 컬럼 || NULL || 타입 || 설명 || 비고 ||' AS COMMENTS  FROM DUAL
UNION ALL
SELECT * FROM 
(
SELECT /*+ CHOOSE */
      '| ' || M.column_name
      || ' | ' || nullable
      || ' | ' || data_type || '(' || DECODE(data_type, 'NUMBER', data_precision + data_scale, data_length) || ')' 
      --|| ' | ' || ' '
      || ' | ' || C.COMMENTS
      || ' | |'  
  FROM ALL_TAB_COLUMNS M
  , ALL_COL_COMMENTS C
 WHERE M.table_name = :TABLE_NAME
    AND M.table_name (+)= C.table_name
    AND M.COLUMN_NAME (+)= C.COLUMN_NAME
    AND M.owner = :OWNER
    ORDER BY column_id
)
union all

/* INDEX 정보 -- JIRA용 */ 
select '\\
|| INDEX명 || UNIQUENESS || COLUMNS_순서 || 비고 ||' AS COMMENTS  FROM DUAL
UNION ALL
SELECT * FROM 
(
SELECT 
    ' | ' || ix.INDEX_NAME
    || ' | ' || UNIQUENESS
    || ' | ' || REPLACE(RTRIM(XMLAGG(XMLELEMENT(x, IC.COLUMN_NAME,CHR(35))).EXTRACT('//text()'),'#') , '#','+')
    || ' | |'
FROM USER_INDEXES IX,
    USER_IND_COLUMNS IC
WHERE IC.INDEX_NAME = IX.INDEX_NAME
    AND IC.TABLE_NAME = :TABLE_NAME
GROUP BY ix.INDEX_NAME, UNIQUENESS
ORDER BY  ix.INDEX_NAME
) aa
;



/*테이블 COMMENT*/
SELECT /*+ CHOOSE */
       table_name , b.comments
  FROM ALL_TAB_COMMENTS b
 WHERE table_name = :TABLE_NAME;

  
/*테이블 컬럼 목록 */
SELECT /*+ CHOOSE */
       M.column_name
     , nullable
     , data_type || '('|| DECODE(data_type, 'NUMBER', data_precision + data_scale, data_length) || ')' as TYPE
     , data_default
     , C.COMMENTS
  FROM ALL_TAB_COLUMNS M
  , ALL_COL_COMMENTS C
 WHERE M.table_name = :TABLE_NAME
    AND M.table_name (+)= C.table_name
    AND M.COLUMN_NAME (+)= C.COLUMN_NAME
   -- AND owner = :OWNER
ORDER BY column_id;

/* index */
SELECT 
    ix.INDEX_NAME
    , UNIQUENESS
    ,RTRIM(XMLAGG(XMLELEMENT(x, IC.COLUMN_NAME,CHR(35))).EXTRACT('//text()')) ATTRS
FROM USER_INDEXES IX,
    USER_IND_COLUMNS IC
WHERE IC.INDEX_NAME = IX.INDEX_NAME
    AND IC.TABLE_NAME = :TABLE_NAME
GROUP BY ix.INDEX_NAME, UNIQUENESS
ORDER BY  ix.INDEX_NAME
;

