-- 新作者/回流作者留存 7日
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
        where dh between 2020060400 and 2020060423
    ) b
    left join
    (
        select distinct account_id
        from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
        where imp_date=20200604 and last_time>date_sub(20200604,14)
    ) e
    on b.personid=e.account_id
    left join
    (
        select distinct feedid 
        from wesee::dim_video_info_day
        where dt=20200604 and is_first_pub=1
    ) f
    on f.feedid=b.feedid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200604,7) and video_createtime >= to_date(date_add(20200604,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    where e.account_id is not null or f.feedid is not null
    group by channel, ftime;

-- 新作者/回流作者留存 3日
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
        where dh between 2020060400 and 2020060423
    ) b
    left join
    (
        select distinct account_id
        from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
        where imp_date=20200604 and last_time>date_sub(20200604,14)
    ) e
    on b.personid=e.account_id
    left join
    (
        select distinct feedid 
        from wesee::dim_video_info_day
        where dt=20200604 and is_first_pub=1
    ) f
    on f.feedid=b.feedid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200604,3) and video_createtime >= to_date(date_add(20200604,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    where e.account_id is not null or f.feedid is not null
    group by channel, ftime;

-- 新作者/回流作者留存 2日
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
        where dh between 2020060400 and 2020060423
    ) b
    left join
    (
        select distinct account_id
        from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
        where imp_date=20200604 and last_time>date_sub(20200604,14)
    ) e
    on b.personid=e.account_id
    left join
    (
        select distinct feedid 
        from wesee::dim_video_info_day
        where dt=20200604 and is_first_pub=1
    ) f
    on f.feedid=b.feedid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200604,2) and video_createtime >= to_date(date_add(20200604,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    where e.account_id is not null or f.feedid is not null
    group by channel, ftime;

