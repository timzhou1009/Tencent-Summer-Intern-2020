-- 5月25日-5月31日推荐播放量top 1w的视频（方法一）

--因为limit数字过大而没法使用
select video_id,
		owner_id,
		count(play_vv) as total_vv
from wesee::fact_event_action_mix_day
where dt between 20200525 and 20200531
	and video_play_time>0 
	and is_recommend=1
group by video_id, owner_id
order by total_vv desc
limit 10000

-- 错误版本
select video_id,
                owner_id,
                count(play_vv) as total_vv,
                row() number_over(partition by video_id,owner_id order by total_vv desc) as RN
from wesee::fact_event_action_mix_day
where dt between 20200525 and 20200531
        and video_play_time>0 
        and is_recommend=1
        and RN < 10001
group by video_id, owner_id

--正确版本
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

-- 用rank比用row_numer慢7倍，但是也可以实现
select * from 
		(
    		select *,
    	   		rank() over(order by total_vv desc) as RN
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


-- 5月25日-5月31日推荐播放量top 1w的视频一级、二级种类
select  manual_category,
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
select * from 
(
    select *,
        row_number() over(order by total_vv desc) as RN
    from 
    (
        select 	video_id,
            	owner_id,
            	sum(play_vv) as total_vv                       
        from wesee::fact_event_action_mix_day
        where dt between 20200525 and 20200531
                and is_recommend=1 
        group by video_id, owner_id
    )
)
where RN < 10001