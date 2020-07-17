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
        where   dh between 2020061700 and 2020070723
                and cate1 = "时尚"
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
        where   dt between 20200617 and 20200707
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
        where   dh between 2020061700 and 2020070723
                and cate2 = "时尚-拍摄/修图技巧"
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
        where   dt between 20200617 and 20200707
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid;

-- 粉丝画像
select  *
from 
    (
        select  distinct oppersonid
        from    pcg_weishi_application::dim_weishi_accountid_relation_df
        where   ownerpersonid = 1556421612785689
    ) a
join 
    (
        select  *
        from    pcg_weishi_application::dwd_weishi_user_unionid_profile_di
        where   imp_date between 20200617 and 20200707
    ) b
on a.oppersonid = b.account_id;

--粉丝活跃度
select  count(distinct account_id)
from
    (
        select  account_id
        from    wesee::fact_event_action_mix_day a 
        where   dt between 20200617 and 20200707
                and play_vv != 0
                and EXISTS( select  oppersonid
                            from    pcg_weishi_application::dim_weishi_accountid_relation_df b
                            where   ownerpersonid = 1556421612785689
                                    and a.account_id = b.oppersonid)
    ) 

-- 时尚兴趣用户对该视频的消费表现
select  sum(play_vv) as play_vv,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct account_id
        from    pcg_weishi_application::dwd_weishi_user_unionid_profile_di
        where   imp_date between 20200617 and 20200707
                and tag_one_1 = "时尚"
    ) a
    join 
    (
        select  account_id,
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
        where   dt between 20200617 and 20200707
                and is_recommend = 1 
                and video_id = "77XFRSmBb1JLnTULr"
    ) b
    on a.account_id = b.account_id;


-- 时尚拍摄/修图技巧 兴趣用户对该视频的消费表现
select  sum(play_vv) as play_vv,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct account_id
        from    pcg_weishi_application::dwd_weishi_user_unionid_profile_di
        where   imp_date between 20200617 and 20200707
                and tag_two_1 = "时尚-拍摄/修图技巧"
    ) a
    join 
    (
        select  account_id,
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
        where   dt between 20200617 and 20200707
                and is_recommend = 1 
                and video_id = "77XFRSmBb1JLnTULr"
    ) b
    on a.account_id = b.account_id;


