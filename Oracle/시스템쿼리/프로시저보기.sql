set long 100000

--select * from user_objects where object_type = 'PROCEDURE';

select text from user_source where name = upper('FN_DP_SATISFACTION_SCORE_INFO'); 