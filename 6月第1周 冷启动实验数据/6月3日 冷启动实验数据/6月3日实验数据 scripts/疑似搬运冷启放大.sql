-- 疑似搬运冷启放大
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
            from wesee::dim_video_rec_pool_hour
            where dh=2020060323 and createtime >= unix_timestamp(to_date(date_sub(20200603,1), "yyyyMMdd"))
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200603 and indite_type = "5"
        ) e
        on b.personid=e.wesee_person_id
        left join
        (
            select personid
            from wesee::wesee_ccs_balance
            where dh between 2020060300 and 2020060323
        ) a
        on a.personid=b.personid
        where a.personid is null
    ) c
    left join
    (
        select feedid, vv
        from wesee::r_statistics_index_source_h_accumulative
        where ftime=concat(date_add(20200603,7),"23") and source_id='0'
    ) a
    on a.feedid=c.feedid
    group by channel, ftime;

