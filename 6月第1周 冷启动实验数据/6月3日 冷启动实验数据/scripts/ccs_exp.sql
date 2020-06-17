select priority, expid, avg(total_wesee_fans), percentile(total_wesee_fans, array(0.25,0.5,0.75,0.9))
from (
    select distinct personid, priority,
        case when (channel in (1,2,3)) then 0
            when (channel in (4,5,6)) then 1
            end as expid
    from wesee::wesee_ccs_id
    where dh between 2020060600 and 2020060623
        and priority in (4,5)
) a
left join
(
    select wesee_person_id, total_wesee_fans
    from pcg_wesee_content_analysis::t_weishi_talent_info_merge
    partition(p_20200606) t
) b
on a.personid=b.wesee_person_id
group by priority, expid


--个性化程度
select expid, 
    pugc, 
    priority, 
    sum(vv) total,
    sum(if(ccspersonal=0,vv,0)) p0,
    sum(if(ccspersonal=2,vv,0)) p2,
    sum(if(ccspersonal=3,vv,0)) p3,
    sum(if(ccspersonal=4,vv,0)) p4
from (
    select *, 
        case when (channel in ("1","2","3")) then 0
            when (channel in ("4","5","6")) then 1
            end as expid
    from ccs_personalization 
    partition(p_20200531) t
)
group by expid, pugc, priority

--分作者等级看冷启消费
select expid, priority,
    avg(vv) vv, 
    avg(video_num) video_num,
    avg(avg_vv) avg_vv,
    avg(play_rate) play_rate,
    avg(finish_rate) finish_rate,
    avg(interact_rate) interact_rate,
    avg(skip_rate) skip_rate
from (
    select expid, ftime, priority,
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
        where 
            ftime between 20200525 and 20200531
            -- ftime = 20200531
            and priority in (4,5)
            and hot_pred is null
            and pugc=0
            -- and pugc is null
    )
    group by expid, ftime, priority
)
group by expid, priority



--分作者等级看放大效果
select expid, priority,
    avg(vv) vv, 
    avg(feed_num) feed_num,
    avg(vv_level_1000) vv_level_1000,
    avg(vv_level_10000) vv_level_10000,
    avg(recmd_vv) recmd_vv
from (
    select expid, ftime, priority,
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
        from wesee::ccs_stats_longterm_vvafter_day3
        where 
            ftime between 20200525 and 20200531
            -- ftime = 20200515
            -- and priority is null
            and priority in (4,5)
            and hot_pred is null
            and pugc=0
    )
    group by expid, ftime, priority
)
group by expid, priority;


--分作者等级看发文留存
select expid, priority,
    avg(person_num) person_num, 
    avg(person_repost_within) person_repost_within,
    avg(person_repost) person_repost
from (
    select expid, ftime, priority,
        sum(person_num) person_num,
        sum(person_repost_within*person_num)/sum(person_num) person_repost_within,
        sum(person_repost*person_num)/sum(person_num) person_repost
    from (
        select *,
            case when (channel in ("1","2","3")) then 0
                when (channel in ("4","5","6")) then 1
                end as expid
        from wesee::ccs_stats_longterm_repost_day7
        where 
            ftime between 20200525 and 20200531
            -- and priority is null
            and priority in (4,5)
            and pugc=0
    )
    group by expid, ftime, priority
)
group by expid, priority;








-- 新作者/回流作者冷启消费
    select
        channel,
        ftime,
        count(distinct c.personid) person_num,
        sum(play_vv) as play_vv,
        count(distinct c.feedid) as video_num,
        sum(play_vv)/count(distinct a.feedid) avg_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
    from (
        select distinct b.ftime, b.feedid, b.personid, b.channel
        -- select if(e.account_id is not null or f.feedid is not null,1,0) tuser, priority, count(distinct b.personid), count(distinct b.feedid)
        from (
            select substr(dh,1,8) ftime, feedid, personid, priority,
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_balance
            where dh between 2020051100 and 2020051123
                and priority in (0,3)
        ) b
        left join
        (
            select distinct account_id
            from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
            where imp_date=20200511 and last_time>date_sub(20200511,14)
        ) e
        on b.personid=e.account_id
        left join
        (
            select distinct feedid 
            from wesee::dim_video_info_day
            where dt=20200511 and is_first_pub=1
        ) f
        on f.feedid=b.feedid
        where e.account_id is not null or f.feedid is not null
    ) c
    left join
    (
        select dt, account_id as personid, video_id as feedid, case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) else video_play_time end as video_play_time, video_total_time, play_vv, play_vv_end, like_num, comment_num, share_num, focus_num, unlike_num
        FROM wesee::fact_event_action_mix_day
        where dt=20200511 and is_recommend=1 and recommend_id_map['sourceid']='459'
    ) a
    on a.feedid=c.feedid and a.dt=c.ftime
    group by channel, ftime
    order by ftime, channel
    limit 1000;


-- 新作者/回流作者留存
    select
        b.channel, b.ftime,
        count(distinct b.personid) person_num,
        -- (count(distinct if(c.personid_rp is not null and c.createday=20200511,b.personid,'')) - 1)/count(distinct b.personid) person_repost,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
    from (
        select substr(dh,1,8) ftime, feedid, personid, level, priority, hot_pred, video_duration,
            case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1
                end as channel
        from wesee::wesee_ccs_balance
        where dh between 2020051100 and 2020051123
    ) b
    left join
    (
        select distinct account_id
        from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
        where imp_date=20200511 and last_time>date_sub(20200511,14)
    ) e
    on b.personid=e.account_id
    left join
    (
        select distinct feedid 
        from wesee::dim_video_info_day
        where dt=20200511 and is_first_pub=1
    ) f
    on f.feedid=b.feedid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200511,1) and video_createtime >= to_date(date_add(20200511,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    where e.account_id is not null or f.feedid is not null
    group by channel, ftime;



-- 新作者/回流作者放大
    select 
        c.channel, c.ftime, 
        count(distinct c.personid) person_num,
        count(distinct c.feedid) feed_num,
        -- (count(distinct if(vv is null,feedid,'0')) - 1)/count(distinct feedid) vv_level_0, 
        -- (count(distinct if(vv >= 100,feedid,'0')) - 1)/count(distinct feedid) vv_level_100, 
        (count(distinct if(a.vv >= 1000,c.feedid,'0')) - 1)/count(distinct c.feedid) vv_level_1000,
        (count(distinct if(a.vv >= 10000,c.feedid,'0')) - 1)/count(distinct c.feedid) vv_level_10000,
        sum(vv)/count(distinct c.feedid) as recmd_vv,
        percentile(cast(a.vv*1000 as bigint), 0.5)/1000 as recmd_vv_median
    from
    (
        select b.*
        from (
            select substr(dh,1,8) ftime, feedid, personid, priority,
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_balance
            where dh between 2020051100 and 2020051123
        ) b
        left join
        (
            select distinct account_id
            from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
            where imp_date=20200511 and last_time>date_sub(20200511,14)
        ) e
        on b.personid=e.account_id
        left join
        (
            select distinct feedid 
            from wesee::dim_video_info_day
            where dt=20200511 and is_first_pub=1
        ) f
        on f.feedid=b.feedid
        where e.account_id is not null or f.feedid is not null
    ) c
    left join
    (
        select feedid, vv
        from wesee::r_statistics_index_source_h_accumulative
        where ftime=concat(date_add(20200511,7),"23") and source_id='0'
    ) a
    on a.feedid=c.feedid
    group by channel, ftime;




-- 疑似搬运冷启消费
    select
        channel,
        ftime,
        count(distinct c.personid) person_num,
        sum(play_vv) as play_vv,
        count(distinct c.feedid) as video_num,
        sum(play_vv)/count(distinct a.feedid) avg_vv,
        avg(video_duration) as video_time,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
    from (
        select b.*
        from 
        -- (
        --     select *
        --     from dim_video_info_day
        --     where dt=20200508 and video_createtime >= to_date(date_sub(20200508,1), "yyyyMMdd")
        -- ) b
        (
            select substr(dh,1,8) ftime, feedid, personid, level, priority, hot_pred, video_duration,
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_balance
            where dh between 2020050800 and 2020050823
                and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200508 and indite_type = "5"
        ) e
        on b.personid=e.wesee_person_id
    ) c
    left join
    (
        select dt, account_id as personid, video_id as feedid, case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) else video_play_time end as video_play_time, video_total_time, play_vv, play_vv_end, like_num, comment_num, share_num, focus_num, unlike_num
        FROM wesee::fact_event_action_mix_day
        where dt=20200508 and is_recommend=1 and recommend_id_map['sourceid']='459'
    ) a
    on a.feedid=c.feedid and a.dt=c.ftime
    group by channel, ftime
    order by ftime, channel
    limit 1000;



-- 疑似搬运放大
    select 
        c.channel, c.ftime, 
        count(distinct c.personid) person_num,
        count(distinct c.feedid) feed_num,
        -- (count(distinct if(vv is null,feedid,'0')) - 1)/count(distinct feedid) vv_level_0, 
        -- (count(distinct if(vv >= 100,feedid,'0')) - 1)/count(distinct feedid) vv_level_100, 
        (count(distinct if(a.vv >= 1000,c.feedid,'0')) - 1)/count(distinct c.feedid) vv_level_1000,
        (count(distinct if(a.vv >= 10000,c.feedid,'0')) - 1)/count(distinct c.feedid) vv_level_10000,
        sum(vv)/count(distinct c.feedid) as recmd_vv,
        percentile(cast(a.vv*1000 as bigint), 0.5)/1000 as recmd_vv_median
    from
    (
        select b.*, 1 as channel
        from 
        (
            select substr(dh,1,8) ftime, personid, feedid, talent_final_level as priority
            from dim_video_rec_pool_hour
            where dh=2020051523 and createtime >= unix_timestamp(to_date(date_sub(20200515,1), "yyyyMMdd"))
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200515 and indite_type = "5"
        ) e
        on b.personid=e.wesee_person_id
        left join
        (
            select personid
            from wesee::wesee_ccs_balance
            where dh between 2020051500 and 2020051523
        ) a
        on a.personid=b.personid
        where a.personid is null
    ) c
    left join
    (
        select feedid, vv
        from wesee::r_statistics_index_source_h_accumulative
        where ftime=concat(date_add(20200515,7),"23") and source_id='0'
    ) a
    on a.feedid=c.feedid
    group by channel, ftime;



-- 疑似搬运发文留存
    select
        b.channel, b.ftime,
        count(distinct b.personid) person_num,
        -- (count(distinct if(c.personid_rp is not null and c.createday=20200515,b.personid,'')) - 1)/count(distinct b.personid) person_repost,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
    from (
        select b.*
            -- , 1 as channel
        from 
        -- (
        --     select substr(dh,1,8) ftime, personid, feedid, talent_final_level as priority
        --     from dim_video_rec_pool_hour
        --     where dh=2020051523 and createtime >= unix_timestamp(to_date(date_sub(20200515,1), "yyyyMMdd"))
        -- ) b
        (
            select substr(dh,1,8) ftime, feedid, personid, level, priority, hot_pred, video_duration,
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_balance
            where dh between 2020051500 and 2020051523
                and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200515 and indite_type = "5"
        ) e
        on b.personid=e.wesee_person_id
        -- left join
        -- (
        --     select personid
        --     from wesee::wesee_ccs_balance
        --     where dh between 2020051500 and 2020051523
        -- ) a
        -- on a.personid=b.personid
        -- where a.personid is null
    ) b
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200515,7) and video_createtime >= to_date(date_add(20200515,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    group by channel, ftime;



