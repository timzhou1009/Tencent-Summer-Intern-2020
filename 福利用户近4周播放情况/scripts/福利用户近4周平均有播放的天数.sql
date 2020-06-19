-- 福利用户近4周平均有播放的天数 6.15
select 	level,
		avg(days)
from
	(
		select 	qimei,
				level,
				count(dt) as days
			from
			(
				select 	dt,
						level,
						a.qimei
				from
					(
						-- 福利用户
						select 	distinct qimei,
								imp_date,
						        case
						            when retain_award_days_last_28_days<=3 then '1'
						            when retain_award_days_last_28_days <=10 then '2'
						            when retain_award_days_last_28_days>=11 then '3'
						            else 'other'
						        end as level
						from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
						where 	imp_date =20200615
						        and active_days_last_1_days = 1
						        and retain_award_days_last_28_days >= 1
					) a 
					join
				    (
				        select 	dt, 
				        		qimei,
				        		play_vv
				        FROM wesee::fact_event_action_mix_day
				        where 	dt between date_sub(20200615,28) and 20200615
				        		and is_recommend = 1 
				        		and play_vv =1
				    ) b
				    on a.qimei = b.qimei
				group by dt, level, a.qimei
			)
		group by qimei, level
	)
group by level;

-- 福利用户近4周平均有播放的天数 6.16
select 	level,
		avg(days)
from
	(
		select 	qimei,
				level,
				count(dt) as days
			from
			(
				select 	dt,
						level,
						a.qimei
				from
					(
						-- 福利用户
						select 	distinct qimei,
								imp_date,
						        case
						            when retain_award_days_last_28_days<=3 then '1'
						            when retain_award_days_last_28_days <=10 then '2'
						            when retain_award_days_last_28_days>=11 then '3'
						            else 'other'
						        end as level
						from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
						where 	imp_date =20200616
						        and active_days_last_1_days = 1
						        and retain_award_days_last_28_days >= 1
					) a 
					join
				    (
				        select 	dt, 
				        		qimei,
				        		play_vv
				        FROM wesee::fact_event_action_mix_day
				        where 	dt between date_sub(20200616,28) and 20200616
				        		and is_recommend = 1 
				        		and play_vv =1
				    ) b
				    on a.qimei = b.qimei
				group by dt, level, a.qimei
			)
		group by qimei, level
	)
group by level;

-- 福利用户近4周平均有播放的天数 6.17
select 	level,
		avg(days)
from
	(
		select 	qimei,
				level,
				count(dt) as days
			from
			(
				select 	dt,
						level,
						a.qimei
				from
					(
						-- 福利用户
						select 	distinct qimei,
								imp_date,
						        case
						            when retain_award_days_last_28_days<=3 then '1'
						            when retain_award_days_last_28_days <=10 then '2'
						            when retain_award_days_last_28_days>=11 then '3'
						            else 'other'
						        end as level
						from 	pcg_weishi_application::dim_weishi_task_qimei_long_cycle_di
						where 	imp_date =20200617
						        and active_days_last_1_days = 1
						        and retain_award_days_last_28_days >= 1
					) a 
					join
				    (
				        select 	dt, 
				        		qimei,
				        		play_vv
				        FROM wesee::fact_event_action_mix_day
				        where 	dt between date_sub(20200617,28) and 20200617
				        		and is_recommend = 1 
				        		and play_vv =1
				    ) b
				    on a.qimei = b.qimei
				group by dt, level, a.qimei
			)
		group by qimei, level
	)
group by level;