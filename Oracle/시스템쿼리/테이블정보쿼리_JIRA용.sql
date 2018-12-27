/*���̺� COMMENT JIRA�� */ 
SELECT /*+ CHOOSE */
       'h4. \[' || table_name || '\] : ' || b.comments
  FROM ALL_TAB_COMMENTS b
 WHERE table_name = :TABLE_NAME

 UNION ALL 

/*���̺� �÷� ����Ʈ JIRA�� */
-- JIRA��
select '\\
|| �÷� || NULL || Ÿ�� || ���� || ��� ||' AS COMMENTS  FROM DUAL
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

/* INDEX ���� -- JIRA�� */ 
select '\\
|| INDEX�� || UNIQUENESS || COLUMNS_���� || ��� ||' AS COMMENTS  FROM DUAL
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



/*���̺� COMMENT*/
SELECT /*+ CHOOSE */
       table_name , b.comments
  FROM ALL_TAB_COMMENTS b
 WHERE table_name = :TABLE_NAME;

  
/*���̺� �÷� ��� */
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

