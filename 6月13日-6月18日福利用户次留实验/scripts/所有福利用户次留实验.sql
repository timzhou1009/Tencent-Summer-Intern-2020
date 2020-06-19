-- 所有福利用户 6月13日
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200613
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days >= 1
	) a 
	join
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"155297") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"155306") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200613
						and recommend_id_map['ugroup'] in ('zuma_34new','zuma_34old')
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = imp_date = 20200613
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	date_add(20200613,1)
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有福利用户 6月14日
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200614
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days >= 1
	) a 
	join
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"155297") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"155306") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200614
						and recommend_id_map['ugroup'] in ('zuma_34new','zuma_34old')
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = imp_date = 20200614
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	date_add(20200614,1)
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有福利用户 6月15日
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200615
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days >= 1
	) a 
	join
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"155297") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"155306") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200615
						and recommend_id_map['ugroup'] in ('zuma_34new','zuma_34old')
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200615
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = date_add(20200615,1)
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有福利用户 6月16日
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200616
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days >= 1
	) a 
	join
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"155297") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"155306") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200616
						and recommend_id_map['ugroup'] in ('zuma_34new','zuma_34old')
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200616
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = date_add(20200616,1)
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有福利用户 6月17日
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200617
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days >= 1
	) a 
	join
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"155297") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"155306") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200617
						and recommend_id_map['ugroup'] in ('zuma_34new','zuma_34old')
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = imp_date = 20200617
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	date_add(20200617,1)
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;


