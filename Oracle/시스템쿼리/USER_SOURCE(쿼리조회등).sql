select * From 
USER_SOURCE
where text like '%DP_PRD_SUMMARY%'




-- DDL Script for VIEW SYS.USER_SOURCE. Orange for ORACLE.
-- Generated on 2009/01/13 11:32:27 by TMALL_CP@DEV

CREATE OR REPLACE VIEW SYS.USER_SOURCE
(   NAME,
    TYPE,
    LINE,
    TEXT
)
AS
select o.name,
       decode(o.type#, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY', 12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY', 'UNDEFINED'),
       s.line,
       s.source
from   sys.obj$ o,
       sys.source$ s
where  o.obj# = s.obj#
and    ( o.type# in (7, 8, 9, 11, 12, 14)
        OR     ( o.type# = 13
                AND    o.subname is null))
and    o.owner# = userenv('SCHEMAID')
union all
select o.name,
       'JAVA SOURCE',
       s.joxftlno,
       s.joxftsrc
from   sys.obj$ o,
       x$joxfs s
where  o.obj# = s.joxftobn
and    o.type# = 28
and    o.owner# = userenv('SCHEMAID');

GRANT SELECT ON SYS.USER_SOURCE TO PUBLIC WITH GRANT OPTION;

CREATE PUBLIC SYNONYM USER_SOURCE FOR SYS.USER_SOURCE;

COMMENT ON TABLE USER_SOURCE IS 'Source of stored objects accessible to the user' ;

COMMENT ON COLUMN USER_SOURCE.LINE IS 'Line number of this line of source' ;
COMMENT ON COLUMN USER_SOURCE.NAME IS 'Name of the object' ;
COMMENT ON COLUMN USER_SOURCE.TEXT IS 'Source text' ;
COMMENT ON COLUMN USER_SOURCE.TYPE IS 'Type of the object: "TYPE", "TYPE BODY", "PROCEDURE", "FUNCTION",
"PACKAGE", "PACKAGE BODY" or "JAVA SOURCE"' ;