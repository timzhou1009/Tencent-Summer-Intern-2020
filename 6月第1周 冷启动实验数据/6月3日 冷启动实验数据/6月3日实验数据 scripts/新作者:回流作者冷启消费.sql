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
            where dh between 2020060300 and 2020060323
                and priority in (0,3)
        ) b
        left join
        (
            select distinct account_id
            from pcg_weishi_application::weishi_user_30d_roll_active_mix_topic_daily
            where imp_date=20200603 and last_time>date_sub(20200603,14)
        ) e
        on b.personid=e.account_id
        left join
        (
            select distinct feedid 
            from wesee::dim_video_info_day
            where dt=20200603 and is_first_pub=1
        ) f
        on f.feedid=b.feedid
        where e.account_id is not null or f.feedid is not null
    ) c
    left join
    (
        select dt, account_id as personid, video_id as feedid, case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) else video_play_time end as video_play_time, video_total_time, play_vv, play_vv_end, like_num, comment_num, share_num, focus_num, unlike_num
        FROM wesee::fact_event_action_mix_day
        where dt=20200603 and is_recommend=1 and recommend_id_map['sourceid']='459'
    ) a
    on a.feedid=c.feedid and a.dt=c.ftime
    group by channel, ftime
    order by ftime, channel
    limit 1000;
