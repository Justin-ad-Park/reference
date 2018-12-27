/*테이블 COMMENT*/
SELECT /*+ CHOOSE */
       b.comments
  FROM ALL_TAB_COMMENTS b
 WHERE table_name = :TABLE_NAME
   AND owner = :OWNER
;   
   
/*테이블 컬럼 목록 */
SELECT /*+ CHOOSE */
       column_name
     , data_type || '('|| DECODE(data_type, 'NUMBER', data_precision + data_scale, data_length) || ')' length
     , nullable
     , data_default
  FROM ALL_TAB_COLUMNS
 WHERE table_name = :TABLE_NAME
       AND owner = :OWNER
ORDER BY column_id
;
 

--테이블 컬럼 정보 상세 
SELECT /*+ CHOOSE */
       column_name
     , data_type
     , DECODE(data_type, 'NUMBER', data_precision + data_scale, data_length) length
     , data_precision
     , data_scale scale
     , data_length dlength
     , nullable
     , data_default
  FROM ALL_TAB_COLUMNS
 WHERE table_name = :TABLE_NAME
       AND owner = :OWNER
ORDER BY column_id
;

/*테이블정보 - 테이블 스페이스 */
SELECT /*+ choose */
       table_name
     , tablespace_name
     , pct_free
     , pct_used
     , (initial_extent/1024) initial_extent
     , (next_extent/1024) next_extent
     , pct_increase
     , degree
     , instances
     , decode(ltrim(cache), 'Y', 'CACHE', 'NOCACHE') cache
     , ini_trans
     , max_trans
     , min_extents
     , max_extents
     , freelists
     , freelist_groups
     , cluster_name
     , iot_name
     , partitioned
     , iot_type
     , decode(ltrim(logging), 'YES', 'LOGGING', 'NOLOGGING') logging
     , temporary
     , duration
     , monitoring
     , buffer_pool
  FROM ALL_TABLES
 WHERE table_name = :TABLE_NAME
   AND owner = :OWNER
;

SELECT a1.constraint_name
     , i1.uniqueness
     , i1.index_name
     , i1.tablespace_name
     , (i1.initial_extent/1024) initial_extent
     , i1.pct_increase
     , i1.pct_free
     , i1.ini_trans
     , i1.max_trans
     , (i1.next_extent/1024) next_extent
     , i1.min_extents
     , i1.max_extents
     , i1.partitioned
     , i1.freelists
     , i1.freelist_groups
     , i1.degree
     , i1.buffer_pool
  FROM ALL_CONSTRAINTS a1
     , USER_INDEXES    i1
 WHERE a1.constraint_type = 'U'
   AND a1.table_name = :TABLE_NAME
   AND a1.owner = :OWNER
   AND i1.table_name      = :TABLE_NAME
   AND i1.table_owner     = :OWNER
   AND i1.index_name      = a1.constraint_name

;

/*PK정보*/
SELECT a1.constraint_name
     , i1.uniqueness
     , i1.index_name
     ,               i1.tablespace_name
     ,           (i1.initial_extent/1024) initial_extent
     ,        i1.pct_increase
     ,              i1.pct_free
     ,                  i1.ini_trans
     ,                 i1.max_trans
     ,                 (i1.next_extent/1024) next_extent
     ,        i1.min_extents
     ,               i1.max_extents
     ,               i1.partitioned
     ,               i1.freelists
     ,                 i1.freelist_groups
     ,          i1.degree
     ,                    i1.buffer_pool
  FROM ALL_CONSTRAINTS a1
     , USER_INDEXES    i1
WHERE a1.constraint_type = 'P'
  AND a1.table_name      = :name
  AND a1.owner           = :owner
  AND i1.table_name      = :name
  AND i1.table_owner     = :owner
  AND i1.index_name      = a1.constraint_name
 ORDER BY 3
;

/*INDEX에 포함된 칼럼명*/
SELECT column_name,
       position
  FROM ALL_CONS_COLUMNS
  WHERE owner           = :OWNER
    AND constraint_name = 'PK_MB_MEM'
    AND table_name      = :TABLE_NAME
  ORDER BY 2
;

SELECT /*+ CHOOSE */
       c.constraint_name,
       c.table_name,
       c.owner,
       c.r_owner,
       c.r_constraint_name,
       p.table_name r_table_name,
       c.status,
       c.delete_rule,
       c.deferrable
  FROM ALL_CONSTRAINTS c,
       ALL_CONSTRAINTS p
 WHERE c.constraint_type = 'R'
   AND p.owner           = c.r_owner
   AND p.constraint_name = c.r_constraint_name
   AND c.table_name      = :TABLE_NAME
   AND c.owner           = :OWNER
;

SELECT /*+ CHOOSE */                                   
       a.uniqueness,                                   
       a.index_name,                                   
       a.table_name,                                   
       a.tablespace_name,                              
       (a.initial_extent/1024) initial_extent,         
       a.ini_trans,                                    
       a.max_trans,                                    
       a.pct_increase,                                 
       a.pct_free,                                     
       (a.next_extent/1024) next_extent,               
       a.min_extents,                                  
       a.max_extents ,                                 
       a.index_type ,                                  
       a.owner,                                        
       a.freelists,                                    
       a.freelist_groups ,                             
       a.degree,                                       
       a.buffer_pool                              
  FROM ALL_INDEXES a                    
 WHERE a.table_owner = :owner                      
   AND a.table_name  = :name                       
   AND a.index_type <> 'LOB'                     
   AND a.index_name NOT IN (SELECT constraint_name 
                              FROM ALL_CONSTRAINTS         
                             WHERE constraint_type IN ('U','P')
                               AND owner           = :owner                    
                               AND table_name      = :name)
;


SELECT column_name,                  
       column_position          
  FROM ALL_IND_COLUMNS 
 WHERE index_owner = :owner      
   AND index_name  = :name       
   AND table_name  = :tbname   
 ORDER BY 2
;


SELECT column_name,                  
       column_position          
  FROM ALL_IND_COLUMNS 
 WHERE index_owner = :owner      
   AND index_name  = :name       
   AND table_name  = :tbname   
 ORDER BY 2
;


SELECT column_name,                  
       column_position          
  FROM ALL_IND_COLUMNS 
 WHERE index_owner = :owner      
   AND index_name  = :name       
   AND table_name  = :tbname   
 ORDER BY 2
 ;
 
 
SELECT column_name,                  
       column_position          
  FROM ALL_IND_COLUMNS 
 WHERE index_owner = :owner      
   AND index_name  = :name       
   AND table_name  = :tbname   
 ORDER BY 2
;
