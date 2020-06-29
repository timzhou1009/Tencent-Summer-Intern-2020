/*
需求：

统计6.22-6.28，每天在推荐页播放
vv≥1
vv≥2
.......
vv≥50
的人数（count distinct qimei)
*/

-- 分开跑+Excel聚合 写法
select 	count(distinct qimei),
		dt,
		level
from
	(
		select 	dt,
				qimei,
				case 
				when vv >= 50 then 50
                when vv >= 1 then vv
				end as level
		from
			(		
				select 	qimei,
						dt, 
						sum(play_vv) as vv
				from 	wesee::fact_event_action_mix_day
				where 	dt between 20200622 and 20200628
						and is_recommend = 1
                        and play_vv != 0
				group by qimei, dt
			)
	)
group by level, dt


-- running total 写法
select	dt,
		level,
		running_total
from
	(
	    select 	sum(user_count) over(partition by dt order by level desc) as running_total,
	            dt,
	            level
	    from
	        (   
	            select	dt,
	             		level,
	             		count(distinct qimei) as user_count
	            from 
		            (
		                select 	dt,
		                        qimei,
		                        case 
		                        when vv >= 50 then 50
		                        when vv >=1 then vv
		                        end as level
		                from
		                    (		
		                        select 	qimei,
		                                dt, 
		                                sum(play_vv) as vv
		                        from 	wesee::fact_event_action_mix_day
		                        where 	dt between 20200622 and 20200628
		                                and is_recommend = 1
		                                and play_vv != 0
		                        group by qimei, dt
		                    )
		            )
	            group by dt,level
	        )
	)
order by dt,level desc 
limit 1000

-- Mysql running total 写法
select 	dt,
		level,
        sum(user_count) over(order by dt, level desc rows between unbounded preceding and current row) as running_total
from
    (
        select 	count(distinct qimei) as user_count,
                dt,
                level
        from
            (
                select 	dt,
                        qimei,
                        case 
                        when vv >= 50 then 50
                        when vv >= 1 then vv
                        end as level
                from
                    (		
                        select 	qimei,
                                dt, 
                                sum(play_vv) as vv
                        from 	wesee::fact_event_action_mix_day
                        where 	dt between 20200622 and 20200628
                                and is_recommend = 1
                                and play_vv != 0
                        group by qimei, dt
                    )
            )
        group by level, dt
    )