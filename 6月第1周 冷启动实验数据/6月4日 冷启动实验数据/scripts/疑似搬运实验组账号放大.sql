--疑似搬运实验组账号 视频放大
select  expid,
        count(distinct d.feedid) feed_num,
        (count(distinct if(c.vv >= 1000, d.feedid,'0')) - 1)/count(distinct d.feedid) vv_level_1000,
        (count(distinct if(c.vv >= 10000, d.feedid,'0')) - 1)/count(distinct d.feedid) vv_level_10000,
        sum(vv)/count(distinct d.feedid) as recmd_vv
from 
    (
        select  feedid,
                expid
        from

            (
                select  
                        distinct wesee_person_id
                from pcg_wesee_content_analysis::t_weishi_talent_info_merge
                where   
                        imp_date = 20200604
                        and indite_type = "5"
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
                        dh between 2020060400 and 2020060423
            ) b 
            on a.wesee_person_id = b.personid
        group by feedid, expid
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
group by expid