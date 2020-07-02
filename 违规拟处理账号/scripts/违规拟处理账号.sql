-- 写法1
select 	level,
		count(distinct video_id) as video_num,
        sum(vv) as vv_num,
        sum(vv)/count(distinct video_id) avg_vv
from
	(
		select 	case when vv>=100000 then "10w+"
		        when vv>=50000 then "5w+"
		        when vv>=20000 then "2w+"
		        when vv>=10000 then "1w+"
		        when vv>=8000 then "8k+"
		        when vv>=5000 then "5k+"
		        when vv>=2000 then "2k+"
		        when vv>=1000 then "1k+"
		        else "0~1k"
		        end as level,
		        video_id,
		        vv
		from
		    (
		        select  --owner_id,
		                video_id,
		                sum(play_vv) as vv
		        from    wesee::fact_event_action_mix_day b
		        where   dt between 20200521 and 20200629 
		                and is_recommend = 1 
		                and play_vv != 0
		                and exists(select pid from wesee::20200630_pid a where a.pid = b.owner_id)
		        group by video_id
		    )
	)
group by level

-- 写法2
select 	level,
		count(distinct video_id) as video_num,
        sum(vv) as vv_num,
        sum(vv)/count(distinct video_id) avg_vv
from
	(
		select pid from wesee::20200630_pid
	) a
	join
	(
		select 	*,
				case when vv>=100000 then "10w+"
		        when vv>=50000 then "5w+"
		        when vv>=20000 then "2w+"
		        when vv>=10000 then "1w+"
		        when vv>=8000 then "8k+"
		        when vv>=5000 then "5k+"
		        when vv>=2000 then "2k+"
		        when vv>=1000 then "1k+"
		        else "0~1k"
		        end as level
		from
		    (
		        select  owner_id,
		                video_id,
		                sum(play_vv) as vv
		        from    wesee::fact_event_action_mix_day
		        where   dt between 20200521 and 20200629 
		                and is_recommend = 1 
		        group by owner_id, video_id
		    )
	) b
	on a.pid = b.owner_id
group by level;

-- 5月31日-6月29日 违规账号每天推荐总VV
select 	dt,
		count(distinct video_id) as video_num,
        sum(vv) as vv_num,
        sum(vv)/count(distinct video_id) avg_vv
from
	(
		select pid from wesee::20200630_pid
	) a
	join
	(
        select  dt,
        		owner_id,
                video_id,
                sum(play_vv) as vv
        from    wesee::fact_event_action_mix_day
        where   dt between 20200531 and 20200629 
                and is_recommend = 1 
        group by dt, owner_id, video_id
		    
	) b
	on a.pid = b.owner_id
group by dt;

-- 5月31日-6月29日 大盘每天推荐总VV
select 	dt,
		count(distinct video_id),
		sum(play_vv) 
from 	wesee::fact_event_action_mix_day
where 	dt between 20200531 and 20200629 
		and is_recommend = 1 
		and play_vv != 0
group by dt