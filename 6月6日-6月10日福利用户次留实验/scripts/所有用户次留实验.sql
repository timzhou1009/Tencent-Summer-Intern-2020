-- 所有用户次留 6月6日
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

-- 所有用户次留 6月7日
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
				where 	dt = 20200607
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) a
	join
	(	
		-- 当日日活
		select 	qimei, imp_date
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200607
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200608
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有用户次留 6月8日
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
				where 	dt = 20200608
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) a
	join
	(	
		-- 当日日活
		select 	qimei, imp_date
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200608
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200609
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有用户次留 6月9日
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
				where 	dt = 20200609
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) a
	join
	(	
		-- 当日日活
		select 	qimei, imp_date
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200609
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200610
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

-- 所有用户次留 6月10日
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
				where 	dt = 20200610
						and recommend_id_map['ugroup'] = 'zuma_34old'
			)
		where expid is not null
	) a
	join
	(	
		-- 当日日活
		select 	qimei, imp_date
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200610
	) c
	on a.qimei = c.qimei 
	left join
	(	
		-- 次日日活
		select 	qimei as qimei2
		from 	pcg_weishi_application::weishi_user_qimei_dau_mix_mid_daily
		where 	imp_date = 20200611
	) d 
	on a.qimei = d.qimei2 
group by imp_date, expid;

