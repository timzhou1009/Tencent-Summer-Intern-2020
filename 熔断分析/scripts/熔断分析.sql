-- 熔断分析账号信息
select 
    a.id,
    targetvv,
    expose,
    play,
    start_time,
    end_time,
    a.feedid
from
    (
        select  id,
                from_unixtime(start_time, 'yyyyMMddHH') as start_time, 
                from_unixtime(end_time, 'yyyyMMddHH') as end_time, 
                recommend_content_id as feedid, 
                targetvv 
        from ods_t_ws_feed_exposure_recommend_hf 
        partition(p_2020071313)p
        where create_time between '2020-07-06 00:00:00' and '2020-07-13 00:00:00'
    )a 
join 
    (
        select  id, 
                sum(expose) as expose, 
                sum(play) as play 
        from    pcg_weishi_application::t_ws_feed_exposure_recommend_task_statbyday
        where   partition_time between 20200706 and 20200712
        group by id
    )b
on a.id=b.id

-- 熔断分析账号数据
select  a.id,
        a.feedid,
        start_time,
        end_time,
        targetvv,
        expose,
        play_vv,
        video_time,
        play_rate,
        finish_rate,
        interact_rate,
        skip_rate_5s,
        skip_rate_1s,
        fan_rate,
        cate1,
        cate2
from
    (
        select  id,
                from_unixtime(start_time, 'yyyyMMddHH') as start_time, 
                from_unixtime(end_time, 'yyyyMMddHH') as end_time, 
                recommend_content_id as feedid, 
                targetvv 
        from pcg_weishi_application::ods_t_ws_feed_exposure_recommend_hf 
        partition(p_2020071313)p
        where create_time between '2020-07-06 00:00:00' and '2020-07-13 00:00:00'
    )a 
join 
    (
        select
            id,
            sum(expose) as expose,
            sum(play) as play_vv,
            avg(vv_duration) as video_time,
            avg(played_deg)/1000 as play_rate,
            sum(played)/sum(play_vv_end) as finish_rate,
            --sum(case when play_vv_end>0 and played_duration>=video_duration then 1 else 0 end)/sum(play) as finish_rate,
            sum(like1+comment1+share+focus)/sum(play) as interact_rate,
            sum(skiped)/sum(play) as skip_rate_5s,
            sum(case when play_vv_end>0 and played_duration<1000 then 1 else 0 end)/sum(play) as skip_rate_1s,
            sum(fan_trans)/sum(play) as fan_rate
        from    pcg_weishi_application::t_ws_feed_exposure_recommend_task_statbyday
        where   partition_time between 20200706 and 20200712
        group by id
    )b
on a.id = b.id
join
    (
        select  feedid,
                cate1,
                cate2
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020070600 and 2020071223
    ) c
on a.feedid = c.feedid
group by    a.id,
            a.feedid,
            start_time,
            end_time,
            targetvv,
            expose,
            play_vv,
            video_time,
            play_rate,
            finish_rate,
            interact_rate,
            skip_rate_5s,
            skip_rate_1s,
            fan_rate,
            cate1,
            cate2


-- 大盘数据
select  cate1,
        cate2,
        sum(play_vv) as play_vv_2,
        count(distinct b.feedid) as video_num_2,
        sum(play_vv)/count(distinct b.feedid) avg_vv_2,
        avg(video_total_time) as avg_video_duration_2,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv_2,
        if(video_play_time>video_total_time,video_total_time,video_play_time) / video_total_time as play_rate_2,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate_2,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate_2,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate_2
from 
    (
        select  distinct feedid,
                cate1,
                cate2
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020070600 and 2020071223
    ) a 
    join 
    (
        select  video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>1*video_total_time) then cast(1*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt between 20200706 and 20200712
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid;


-- 汇总
select  a.id,
        a.feedid,
        start_time,
        end_time,
        targetvv,
        expose,
        play_vv,
        video_time,
        play_rate,
        finish_rate,
        interact_rate,
        skip_rate_5s,
        skip_rate_1s,
        fan_rate,
        c.cate1,
        c.cate2,
        play_vv_2,
        video_num_2,
        avg_vv_2,
        avg_video_duration_2,
        avg_video_play_time_per_vv_2,
        play_rate_2,
        finish_rate_2,
        interact_rate_2,
        skip_rate_2
from
    (
        select  id,
                from_unixtime(start_time, 'yyyyMMddHH') as start_time, 
                from_unixtime(end_time, 'yyyyMMddHH') as end_time, 
                recommend_content_id as feedid, 
                targetvv 
        from pcg_weishi_application::ods_t_ws_feed_exposure_recommend_hf 
        partition(p_2020071313)p
        where create_time between '2020-07-06 00:00:00' and '2020-07-13 00:00:00'
    )a 
join 
    (
        select
            id,
            sum(expose) as expose,
            sum(play) as play_vv,
            avg(vv_duration) as video_time,
            avg(played_deg)/1000 as play_rate,
            sum(played)/sum(play_vv_end) as finish_rate,
            --sum(case when play_vv_end>0 and played_duration>=video_duration then 1 else 0 end)/sum(play) as finish_rate,
            sum(like1+comment1+share+focus)/sum(play) as interact_rate,
            sum(skiped)/sum(play) as skip_rate_5s,
            sum(case when play_vv_end>0 and played_duration<1000 then 1 else 0 end)/sum(play) as skip_rate_1s,
            sum(fan_trans)/sum(play) as fan_rate
        from    pcg_weishi_application::t_ws_feed_exposure_recommend_task_statbyday
        where   partition_time between 20200706 and 20200712
        group by id
    )b
on a.id = b.id
join
    (
        select  feedid,
                cate1,
                cate2
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020070600 and 2020071223
    ) c
on a.feedid = c.feedid
full outer join
    (
        select  cate1,
                cate2,
                sum(play_vv) as play_vv_2,
                count(distinct b.feedid) as video_num_2,
                sum(play_vv)/count(distinct b.feedid) avg_vv_2,
                avg(video_total_time) as avg_video_duration_2,
                sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv_2,
                if(video_play_time>video_total_time,video_total_time,video_play_time) / video_total_time as play_rate_2,
                sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate_2,
                sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate_2,
                sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate_2
        from 
            (
                select  distinct feedid,
                        cate1,
                        cate2
                from    wesee::dim_video_rec_pool_hour
                where   dh between 2020070600 and 2020071223
            ) a 
            join 
            (
                select  video_id as feedid,
                        video_total_time, 
                        play_vv, 
                        play_vv_end, 
                        like_num, 
                        comment_num, 
                        share_num, 
                        focus_num,
                        case when (video_play_time>1*video_total_time) then cast(1*video_total_time as bigint) 
                        else video_play_time end as video_play_time
                from    wesee::fact_event_action_mix_day
                where   dt between 20200706 and 20200712
                        and is_recommend = 1 
            ) b
            on a.feedid = b.feedid
        group by cate1, cate2
    ) d
on c.cate1 = d.cate1 and c.cate2 = d.cate2
group by    a.id,
            a.feedid,
            start_time,
            end_time,
            targetvv,
            expose,
            play_vv,
            video_time,
            play_rate,
            finish_rate,
            interact_rate,
            skip_rate_5s,
            skip_rate_1s,
            fan_rate,
            c.cate1,
            c.cate2,
            play_vv_2,
            video_num_2,
            avg_vv_2,
            avg_video_duration_2,
            avg_video_play_time_per_vv_2,
            play_rate_2,
            finish_rate_2,
            interact_rate_2,
            skip_rate_2