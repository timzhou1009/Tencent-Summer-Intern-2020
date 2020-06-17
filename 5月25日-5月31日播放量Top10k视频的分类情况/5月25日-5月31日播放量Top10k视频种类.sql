-- 5月25日-5月31日推荐播放量top 1w的视频一级、二级种类（方法一）
select  a.video_id,
        a.owner_id,
        manual_category,
		manual_category_l2
from 
	(
		select	video_id,
            	owner_id,
            	manual_category,
				manual_category_l2
		from pcg_weishi_application::weishi_public_video_info_dim_daily
		where imp_date between 20200525 and 20200531
	) a
join (
		select * from 
		(
    		select *,
    	   		  row_number() over(order by total_vv desc) as RN
    		from 
   			(
        		select 	video_id,
            			owner_id,
            			count(case when play_vv = 0 then play_vv end) as total_vv              
        		from wesee::fact_event_action_mix_day
        		where dt between 20200525 and 20200531
                		and video_play_time>0 
                		and is_recommend=1 
        		group by video_id, owner_id
    		)
		)
		where RN < 10001
	) b
on a.video_id=b.video_id and a.owner_id=b.owner_id



-- 5月25日-5月31日推荐播放量top 1w的视频（方法二）
select  distinct a.video_id,
        a.owner_id,
        manual_category,
        manual_category_l2,
        total_vv,
        RN
from 
    (
        select  video_id,
                owner_id,
                manual_category,
                manual_category_l2
        from pcg_weishi_application::weishi_public_video_info_dim_daily
        where imp_date between 20200525 and 20200531
    ) a
join (
        select * from 
        (
            select  *,
                    row_number() over(order by total_vv desc) as RN
            from 
            (
                select  video_id,
                        owner_id,
                        sum(play_vv) as total_vv
                from wesee::fact_event_action_mix_day
                where dt between 20200525 and 20200531
                        and is_recommend=1 
                group by video_id, owner_id
            )
        )
    ) b
on a.video_id=b.video_id and a.owner_id=b.owner_id
where RN < 15000
group by video_id, owner_id






