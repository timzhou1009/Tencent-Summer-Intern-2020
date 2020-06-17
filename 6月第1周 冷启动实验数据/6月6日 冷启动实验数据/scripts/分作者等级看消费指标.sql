--分作者等级看冷启消费
select expid, priority, pugc,
    avg(vv) vv, 
    avg(video_num) video_num,
    avg(avg_vv) avg_vv,
    avg(play_rate) play_rate,
    avg(finish_rate) finish_rate,
    avg(interact_rate) interact_rate,
    avg(skip_rate) skip_rate
from (
    select expid, ftime, priority, pugc,
        sum(play_vv) vv,
        sum(video_num) video_num,
        sum(play_vv)/sum(video_num) avg_vv,
        sum(total_play_time)/sum(total_video_time) play_rate,
        sum(finish_num)/sum(play_vv) finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) interact_rate,
        sum(skip_num)/sum(play_vv) skip_rate
    from (
        select *,
            case when (channel in ("1","2","3")) then 0
                when (channel in ("4","5","6")) then 1
                end as expid
        from wesee::ccs_stats_shortterm
        partition(p_20200606) t
        where 
            hot_pred is null
    )
    group by expid, ftime, priority, pugc
)
group by expid, priority, pugc