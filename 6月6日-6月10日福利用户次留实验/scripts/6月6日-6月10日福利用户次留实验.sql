/*
实验目的：探究4-5级优质视频对轻度、中度、重度福利用户的次日留存率的影响
实验组：推荐4-5级优质视频
对照组：大盘推荐视频
*/

select 	imp_date,
		expid,
		level,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 福利用户
		select 	imp_date,
		    	qimei,
		        case
		            when retain_award_days_last_28_days <=3 then '1'
		            when retain_award_days_last_28_days <=10 then '2'
		            when retain_award_days_last_28_days >=11 then '3'
		            else 'other'
		        end as level
		from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
		where 	imp_date =20200606
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
							when (instr(recommend_id_map['wesee_abv2_801'],"153089") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"147054") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200606
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200606
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200607
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid, level;

-- 所有福利用户
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
		where 	imp_date =20200606
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
							when (instr(recommend_id_map['wesee_abv2_801'],"153089") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"147054") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200606
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200606
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200607
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有非福利用户
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
		where 	imp_date =20200606
		        and active_days_last_1_days = 1
		        and retain_award_days_last_28_days =0
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
							when (instr(recommend_id_map['wesee_abv2_801'],"153089") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"147054") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200606
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) b
	on a.qimei = b.qimei
	join
	(	
		-- 当日日活
		select 	qimei 
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200606
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200607
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有用户次留
select 	imp_date,
		expid,
		count(distinct a.qimei) dau,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1) dau2,
		(count(distinct if(d.qimei2 is not null,a.qimei,'')) - 1)/count(distinct a.qimei) retention
from
	(
		-- 实验组/对照组
		select 	qimei,
				expid
		from
			(
				select 	*,
						case 
							when (instr(recommend_id_map['wesee_abv2_801'],"153089") > 0) then 1
							when (instr(recommend_id_map['wesee_abv2_801'],"147054") > 0) then 0 
						end as expid
				from 	wesee::fact_event_action_mix_day
				where 	dt = 20200606
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) a
	join
	(	
		-- 当日日活
		select 	qimei, imp_date
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200606
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200607
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;
