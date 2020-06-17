-- 疑似搬运冷启消费
    select
        channel,
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
            select feedid, personid, video_duration, 
                case when (channel in (1,2,3)) then 0
                    when (channel in (4,5,6)) then 1
                    end as channel
            from wesee::wesee_ccs_balance
            where dh between 2020060400 and 2020060423
                and priority not in (4,5)
        ) b
        join
        (
            select distinct wesee_person_id
            from pcg_wesee_content_analysis::t_weishi_talent_info_merge
            where imp_date=20200604 and indite_type = "5"
        ) e
        on b.personid=e.wesee_person_id
    ) c
    left join
    (
        select account_id as personid, video_id as feedid, case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) else video_play_time end as video_play_time, video_total_time, play_vv, play_vv_end, like_num, comment_num, share_num, focus_num, unlike_num
        FROM wesee::fact_event_action_mix_day
        where dt=20200604 and is_recommend=1 and recommend_id_map['sourceid']='459'
    ) a
    on a.feedid=c.feedid 
    group by channel
    order by channel
    limit 1000;
