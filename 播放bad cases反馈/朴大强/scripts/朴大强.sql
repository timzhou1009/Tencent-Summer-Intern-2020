-- 一级类目
select  sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020060900 and 2020062823
                and cate1 = "搞笑"
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
                case when (video_play_time>1*video_total_time) then cast(1*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt between 20200609 and 20200628
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid;

-- 二级类目
select  sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020060900 and 2020062823
                and cate2 = "剧情段子"
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
                case when (video_play_time>1*video_total_time) then cast(1*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt between 20200609 and 20200628
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid;

-- 二级类目 >60s
select  sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020060900 and 2020062823
                and cate2 = "剧情段子"
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
                case when (video_play_time>1*video_total_time) then cast(1*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt between 20200609 and 20200628
                and is_recommend = 1 
                and video_total_time >= 60000
    ) b
    on a.feedid = b.feedid;

-- 粉丝画像
select  *
from 
    (
        select  oppersonid
        from    pcg_weishi_application::dim_weishi_accountid_relation_df
        where   ownerpersonid = 1542698649717510
    ) a
join 
    (
        select  *
        from    pcg_weishi_application::dwd_weishi_user_unionid_profile_di
        where   imp_date between 20200609 and 20200628
    ) b
on a.oppersonid = b.account_id;

--粉丝活跃度
select  play_or_not,
        count(account_id) over(partition by play_or_not)
from
    (
        select  account_id,
                case when total_vv >=1 then 1
                when total_vv =0 then 0 end as play_or_not
        from
            (
                select  distinct oppersonid
                from    pcg_weishi_application::dim_weishi_accountid_relation_df
                where   ownerpersonid = 1542698649717510
            ) a
            join
            (
                select  account_id,
                        sum(play_vv) as total_vv
                from    wesee::fact_event_action_mix_day
                where   dt between 20200609 and 20200628
                group by account_id
            ) b
            on a.oppersonid = b.account_id
    )







