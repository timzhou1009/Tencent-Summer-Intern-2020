--12级视频留存 实验组 7日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_id
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,7) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;

--12级视频留存 实验组 3日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_id
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,3) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;

--12级视频留存 实验组 2日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_id
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,2) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;

-------------------------------------------------------------------------------------------------------------------------
--12级视频留存 对照组 7日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_balance
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,7) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;

--12级视频留存 对照组 3日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_balance
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,3) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;

--12级视频留存 对照组 2日
select  expid,
        talent_month_level,
        (count(distinct if(c.personid_rp is not null,b.personid,'')) - 1)/count(distinct b.personid) person_repost_within
from 
    (
        select  
                distinct wesee_person_id, 
                talent_month_level 
        from pcg_wesee_content_analysis::t_weishi_talent_info_merge
        where   
                talent_month_level in (1,2)
                and imp_date = 20200606
    ) a 
    join
    (
        select 
                personid,
                feedid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_balance
        where 
                dh between 2020060600 and 2020060623
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200606,2) and video_createtime >= to_date(date_add(20200606,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level;