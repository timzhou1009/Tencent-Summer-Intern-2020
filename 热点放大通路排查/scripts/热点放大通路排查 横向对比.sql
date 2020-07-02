-- 同时间大盘所有推荐视频的 消费指标
select  dt,
        sum(play_vv) as play_vv,
        count(distinct feedid) as video_num,
        sum(play_vv)/count(distinct feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<1000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  dt, 
                video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   (dt = 20200623 or dt = 20200619 or dt = 20200620)
                and is_recommend = 1 
    ) 
group by dt;

-- 同时间大盘所有一级类目为二次元的视频的消费指标
select  b.dt,
        sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<1000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   (dh between 2020062300 and 2020062323
                or dh between 2020061900 and 2020061923
                or dh between 2020062000 and 2020062023)
                --and tags like "%二次元%"
                and instr(cate1, "二次元") > 0
    ) a 
    join 
    (
        select  dt, 
                video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   (dt = 20200623 or dt = 20200619 or dt = 20200620)
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid
group by b.dt;
