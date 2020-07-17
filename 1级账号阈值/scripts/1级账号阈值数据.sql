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
		        select  owner_id,
		        		video_id,
		                sum(play_vv) as vv
		        from    wesee::fact_event_action_mix_day
		        where   dt between 20200614 and 20200713 
		                and is_recommend = 1 
		                and play_vv != 0
		        group by video_id, owner_id
		    ) a
		    join
		    (
    			select distinct wesee_person_id
				from 	pcg_wesee_content_analysis::t_weishi_talent_info_merge 
						partition(p_20200713)p
    			where 	talent_month_level = 1

		    ) b
		    on b.wesee_person_id = a.owner_id
	)
group by level


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
		        select  owner_id,
		        		video_id,
		                sum(play_vv) as vv
		        from    wesee::fact_event_action_mix_day
		        where   dt between 20200614 and 20200713 
		                and is_recommend = 1 
		                and play_vv != 0
		                and exists
		                			(
		                						    join
		    (
    			select distinct wesee_person_id
				from 	pcg_wesee_content_analysis::t_weishi_talent_info_merge 
						partition(p_20200713)p
    			where 	talent_month_level = 1

		    ) b
		    on b.wesee_person_id = a.owner_id
		                			)
		        group by video_id, owner_id
		    ) 
	)
group by level