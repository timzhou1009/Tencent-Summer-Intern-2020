--12级视频对照组放大
select  expid,
        talent_month_level,
        count(distinct d.feedid) feed_num,
        (count(distinct if(c.vv >= 1000, d.feedid,'0')) - 1)/count(distinct d.feedid) vv_level_1000,
        (count(distinct if(c.vv >= 10000, d.feedid,'0')) - 1)/count(distinct d.feedid) vv_level_10000,
        sum(vv)/count(distinct d.feedid) as recmd_vv
from 
    (
        select  feedid,
                expid,
                talent_month_level 
        from

            (
                select  
                        distinct wesee_person_id, 
                        talent_month_level 
                from pcg_wesee_content_analysis::t_weishi_talent_info_merge
                where   
                        talent_month_level in (1,2)
                        and imp_date = 20200604
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
                        dh between 2020060400 and 2020060423
                        and priority in (1,2)
            ) b 
            on a.wesee_person_id = b.personid
        group by feedid, expid, talent_month_level 
    ) d
    left join
    (
        select
                video_id,
                sum(play_vv) as vv
        from wesee::fact_event_action_mix_day
        where dt = date_add(20200604,7)
              and is_recommend=1 
              and recommend_id_map['sourceid']='0'
        group by video_id
    ) c
    on d.feedid = c.video_id
group by expid, talent_month_level