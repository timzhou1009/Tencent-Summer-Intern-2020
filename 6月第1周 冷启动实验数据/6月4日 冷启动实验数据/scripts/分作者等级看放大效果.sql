--分作者等级看放大效果
select expid, priority, pugc,
    avg(vv) vv, 
    avg(feed_num) feed_num,
    avg(vv_level_1000) vv_level_1000,
    avg(vv_level_10000) vv_level_10000,
    avg(recmd_vv) recmd_vv
from (
    select expid, priority, pugc,
        sum(recmd_vv*feed_num) vv,
        sum(feed_num) feed_num,
        sum(feed_num*vv_level_1000)/sum(feed_num) vv_level_1000,
        sum(feed_num*vv_level_10000)/sum(feed_num) vv_level_10000,
        sum(recmd_vv*feed_num)/sum(feed_num) recmd_vv
    from (
        select *,
            case when (channel in ("1","2","3")) then 0
                when (channel in ("4","5","6")) then 1
                end as expid
        from wesee::ccs_stats_longterm_vvafter_day7
        partition(p_20200604) t
        where 
            hot_pred is null
            -- ftime = 20200515
            -- and priority is null
    )
    group by expid, priority, pugc
)
group by expid, priority, pugc