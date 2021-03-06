
select * from TR_ORDER_EXC_LOG
WHERE regexp_like (EXC_MSG, '^SqlMapClient|^An error')
order by EXC_DT
;

select * from TR_ORDER_EXC_LOG M
JOIN
    (
        SELECT column_value filter 
        FROM TABLE(sys.odcivarchar2list('sqlMapClient%','An error%'))
    ) ON M.EXC_MSG like filter
;

