SELECT ROWNUM FROM DUAL
connect by level <= 10;
