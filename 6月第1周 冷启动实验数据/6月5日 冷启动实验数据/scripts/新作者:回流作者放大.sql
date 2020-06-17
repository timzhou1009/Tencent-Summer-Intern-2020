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
            where dh between 2020060500 and 2020060523
        ) b
        left join
        (
            select distinct account_id
            from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
            where imp_date=20200605 and last_time>date_sub(20200605,14)
        ) e
        on b.personid=e.account_id
        left join
        (
            select distinct feedid 
            from wesee::dim_video_info_day
            where dt=20200605 and is_first_pub=1
        ) f
        on f.feedid=b.feedid
        where e.account_id is not null or f.feedid is not null
    ) c
    left join
    (
        select feedid, vv
        from wesee::r_statistics_index_source_h_accumulative
        where ftime=concat(date_add(20200605,7),"23") and source_id='0'
    ) a
    on a.feedid=c.feedid
    group by channel, ftime;