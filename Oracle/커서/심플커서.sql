DECLARE
	v_seller_hmpg_no NUMBER;	--��ǥ�̴ϸ� ��ȣ
	v_existsCnt NUMBER;		--�ܰ� �� ��� ����	
	
BEGIN
    FOR cur1 IN
    (
            select seller_hmpg_no, mem_no FROM tmp_mt_seller_cust_120630
            where 1 = 1
    )
    LOOP
			
			--��ǥ �̴ϸ� ��ȣ ��ȸ    
    	select seller_hmpg_no into v_seller_hmpg_no
    	from mt_seller_hmpg
    	where mem_no = (select mem_no from mt_seller_hmpg where seller_hmpg_no = cur1.seller_hmpg_no)
    		and seller_hmpg_kd_cd = '01';
    	
    	--��ǥ �̴ϸ��� �ش� �� �� ��� ����
    	select count(*) into v_existsCnt from mt_sellershp_mg_cust
    	where seller_hmpg_no = v_seller_hmpg_no and mem_no = cur1.mem_no;    	
    
    
			UPDATE mt_sellershp_mg_cust
			 SET seller_hmpg_no = v_seller_hmpg_no
			WHERE seller_hmpg_no = cur1.seller_hmpg_no and mem_no = cur1.mem_no
				and v_existsCnt = 0;
			
			COMMIT;
    END LOOP;
 END;
