/*
需求背景：
热点事件运营发现某些热点视频经调权后，推荐链路覆盖视频数、推荐链路总
UV、推荐链路总VV占大盘覆盖视频数、大盘总UV、大盘总VV比重仍不乐观。

排查原因：
1） 没有PK过推荐页其他视频
2） 没有PK过推荐页同期生效的其他热点视频
3） 没有PK过推荐页同期且同级生效的其他热点视频

1） 热点对应所有视频的推荐页完播率、完整度、互动率、快划率
2） 热点同期生效所有热点的推荐页完播率、完整度、互动率、快划率
3） 热点同期生效且同级别热点推荐页完播率、完整度、互动率、快划率
*/

-- test
select * from wesee::dim_video_rec_pool_hour
where 	dh between 2020062300 and 2020062323
		and feedid in 	('7gkGoI7yo1JNBOby6','74yQ97Owr1HZjhdxo','7gkDYz1gh1JNB2mPr',
						'6YwfdtDRw1HPuw32S','7gkDYz1gh1JNB1G6s','7gkFuKJCE1JNB6fYp','7gkG4KmVf1JNB8AoN',
						'7gkFuKJCE1JNB68I1','7fKb3nOK01JvafZ9v','7gkFTMh4J1JNBKVE4','7gkH5giUA1JNBWT6j')
		or topicid = "493726426021117bd1fa1b6d7f758ed7"
		or instr("燃向",tags) > 0


-- 排查热点对应所有视频的推荐页完播率、完整度、互动率、快划率
-- 乘风破浪的二次元姐姐【二次元宅舞向】
select  b.dt,
        sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<1000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020062300 and 2020062323
                and (feedid in  ('7gkGoI7yo1JNBOby6','74yQ97Owr1HZjhdxo','7gkDYz1gh1JNB2mPr',
                                '6YwfdtDRw1HPuw32S','7gkDYz1gh1JNB1G6s','7gkFuKJCE1JNB6fYp','7gkG4KmVf1JNB8AoN',
                                '7gkFuKJCE1JNB68I1','7fKb3nOK01JvafZ9v','7gkFTMh4J1JNBKVE4','7gkH5giUA1JNBWT6j')
                or collection_id = "493726426021117bd1fa1b6d7f758ed7"
                or tags like "%燃向动漫%")
                --or instr(tags, "燃向") > 0)
    ) a 
    join 
    (
        select  dt, 
                video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt = 20200623 
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid
group by b.dt;

-- 蝙蝠侠导演乔舒马赫去世
select  b.dt,
        sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<1000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   dh between 2020062300 and 2020062323
                and (feedid in ("7gkGYgQlI1JNBVLBh","7gkGYgQlI1JNBVSD8","7gkI0JBw41JNBbgw7",
                            "7gkGBhJSL1JNARamg","7gkGBhJSL1JNARgNE","7gkGBhJSL1JNBpYys",
                            "7gkDYz1gh1JNC4B3s","763lEwp591JqafHSF","7g3Z85aTK1JoFxnpk","7gkH5giUA1JNC6ubA")
                or collection_id = "b466dced4bd323f9bade2ece43127b03"
                or tags like "%乔舒马赫%")
                --or instr(tags, "乔舒马赫") > 0)
    ) a 
    join 
    (
        select  dt, 
                video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   dt = 20200623 
                and is_recommend = 1 
    ) b
    on a.feedid = b.feedid
group by b.dt;

-- 狐妖小红娘金晨曦篇开播【二次元内容】
select  b.dt,
        sum(play_vv) as play_vv,
        count(distinct b.feedid) as video_num,
        sum(play_vv)/count(distinct b.feedid) avg_vv,
        avg(video_total_time) as avg_video_duration,
        sum(video_play_time)/sum(play_vv) as avg_video_play_time_per_vv,
        avg(case when play_vv_end>0 then 1.0*video_play_time/video_total_time else null end) as play_rate,
        sum(case when play_vv_end>0 and video_play_time>=video_total_time then 1 else 0 end)/sum(play_vv) as finish_rate,
        sum(like_num+comment_num+share_num+focus_num)/sum(play_vv) as interact_rate,
        sum(case when play_vv_end>0 and video_play_time<1000 then 1 else 0 end)/sum(play_vv) as skip_rate
from 
    (
        select  distinct feedid,
                substr(dh,1,8) as dt
        from    wesee::dim_video_rec_pool_hour
        where   (dh between 2020061900 and 2020061923 or dh between 2020062000 and 2020062023)
                and (feedid in ("7bCgwIBTT1JMdNhSz","6ZUU8W7Vs1JyItWkM","6ZUU8W7Vs1JI8ITR1",
                                "6ZUU8W7Vs1JC89aTF","6WNtpfNLY1IqkinGR","7dTMxjhkz1JiL7fcO",
                                "6ZUU8W7Vs1JK6WIN5","7dPafW2lx1JcDm5Zh","7dPafW2lx1JcDiB5q",
                                "72uDIU3Jd1JcMTSWp","75ZtMt3uU1JyrE3Mx","72we1LsJx1JJyQ5ZN")
                or tags like "%狐妖小红娘%")
                --or instr(tags, "狐妖小红娘") > 0)
    ) a 
    join 
    (
        select  dt, 
                video_id as feedid,
                video_total_time, 
                play_vv, 
                play_vv_end, 
                like_num, 
                comment_num, 
                share_num, 
                focus_num,
                case when (video_play_time>3*video_total_time) then cast(3*video_total_time as bigint) 
                else video_play_time end as video_play_time
        from    wesee::fact_event_action_mix_day
        where   (dt = 20200619 or dt = 20200620)
                and is_recommend = 1
    ) b
    on a.dt = b.dt and a.feedid = b.feedid
group by b.dt;