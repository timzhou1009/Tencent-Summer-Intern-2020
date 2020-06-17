-- 12级账号对照组消费
select  
        expid,
        talent_month_level,
        sum(play_vv) as play_vv,
        count(distinct c.feedid) as video_num,
        sum(play_vv)/count(distinct d.feedid) avg_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<5000 then 1 else 0 end)/sum(play_vv) as skip_rate
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
                        and imp_date = 20200603
            ) a 
            join
            (
                select 
                        personid,
                        feedid,
                        substr(dh,1,8) ftime,
                        case when (channel in (1,2,3)) then 0
                        when (channel in (4,5,6)) then 1 end as expid
                from wesee::wesee_ccs_balance
                where 
                        dh between 2020060300 and 2020060323
                        and priority in (1,2)
            ) b 
            on a.wesee_person_id = b.personid
        group by feedid, expid, talent_month_level
    ) d
    left join
    (
        select 
                dt, 
                account_id as personid, 
                video_id as feedid, 
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time, 
                video_total_time, play_vv, play_vv_end, like_num, comment_num, share_num, focus_num
        FROM wesee::fact_event_action_mix_day
        where dt=20200603 and is_recommend=1 and recommend_id_map['sourceid']='459'
    ) c
    on c.feedid=d.feedid
group by expid, talent_month_level
order by expid
limit 1000;
