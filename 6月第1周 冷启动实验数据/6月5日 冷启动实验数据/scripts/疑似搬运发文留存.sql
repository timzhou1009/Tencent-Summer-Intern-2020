-- 疑似搬运发文留存 7日
    select
        b.channel,
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
            select feedid, personid, 
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_id
            where dh between 2020060500 and 2020060523
                    and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200605 and indite_type = "5"
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
        where dt=date_add(20200605,7) and video_createtime >= to_date(date_add(20200605,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    group by channel;

-- 疑似搬运发文留存 3日
    select
        b.channel,
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
            select feedid, personid, 
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_id
            where dh between 2020060500 and 2020060523
                    and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200605 and indite_type = "5"
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
        where dt=date_add(20200605,3) and video_createtime >= to_date(date_add(20200605,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    group by channel;
    
-- 疑似搬运发文留存 2日
    select
        b.channel,
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
            select feedid, personid, 
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_id
            where dh between 2020060500 and 2020060523
                    and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200605 and indite_type = "5"
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
        where dt=date_add(20200605,2) and video_createtime >= to_date(date_add(20200605,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
    group by channel;