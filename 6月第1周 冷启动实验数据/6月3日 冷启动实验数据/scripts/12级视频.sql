create table a(
feed_id int not null,
vv int not null
) engine=innodb default charset='utf8';

insert into a values(1, 1123);
insert into a values(2, 11235);
insert into a values(3, 12);
insert into a values(4, 2345);
insert into a values(5, 439);
insert into a values(6, 4325);
insert into a values(7, 342);
insert into a values(8, 29359);
insert into a values(9, 12034);
insert into a values(10, 238);

create table b(
feed_id int not null
) engine=innodb default charset='utf8';
insert into b values(1)
insert into b values(2);
insert into b values(3);
insert into b values(4);
insert into b values(5);
insert into b values(8);
insert into b values(10);
insert into b values(12);
insert into b values(15);
insert into b values(16);

--模拟放大        
select 
        (count(distinct if(a.vv >= 1000, a.feed_id,'0')) - 1)/count(distinct a.feed_id) vv_level_1000,
        (count(distinct if(a.vv >= 10000, a.feed_id,'0')) - 1)/count(distinct a.feed_id) vv_level_10000
from 
    a left join b 
    on a.feed_id=b.feed_id;


select * from a left join b on a.feed_id=b.feed_id order by a.feed_id


--模拟留存
(count(distinct if(b.feed_id is not null,a.feed_id,'')) - 1)/count(distinct a.feed_id) person_repost_within

select 
        (count(distinct if(b.feed_id is not null,a.feed_id,'')) - 1)/count(distinct a.feed_id) person_repost_within
from 
    a left join b on a.feed_id=b.feed_id;

select 
        (count(distinct if(b.feed_id is not null,a.feed_id,'')) - 1) 
from 
    a left join b 
    on a.feed_id=b.feed_id;

select 
        b.feed_id is not null
from 
    a left join b 
    on a.feed_id=b.feed_id;

select 
        distinct if(b.feed_id is not null,b.feed_id,"")
from 
    a left join b on a.feed_id=b.feed_id;

-------------------------------------------------------------------------------------------------------------------------------------
--12级视频放大
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
                        and imp_date = 20200603
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
                        dh between 2020060300 and 2020060323
                        and priority in (1,2)
            ) b 
            on a.wesee_person_id = b.personid
        group by feedid, expid, talent_month_level 
    ) d
    join
    (
        select
                video_id,
                sum(play_vv) as vv
        from wesee::fact_event_action_mix_day
        where dt = date_add(20200603,7)
              and is_recommend=1 
              and recommend_id_map['sourceid']='0'
        group by video_id
    ) c
    on d.feedid = c.video_id
group by expid, talent_month_level


select  expid,
        talent_month_level,
        count(distinct b.feedid) feed_num,
        (count(distinct if(c.vv >= 1000, b.feedid,'0')) - 1)/count(distinct b.feedid) vv_level_1000,
        (count(distinct if(c.vv >= 10000, b.feedid,'0')) - 1)/count(distinct b.feedid) vv_level_10000,
        sum(vv)/count(distinct b.feedid) as recmd_vv
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
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_id
        where 
                dh between 2020060300 and 2020060323
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    join
    (
        select
                video_id,
                sum(play_vv) as vv
        from wesee::fact_event_action_mix_day
        where dt = date_add(20200603,7)
              and is_recommend=1 
              and recommend_id_map['sourceid']='0'
        group by video_id
    ) c
    on b.feedid = c.video_id
group by expid, talent_month_level
-------------------------------------------------------------------------------------------------------------------------------------
--12级视频留存 7日
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
                and imp_date = 20200603
    ) a 
    join
    (
        select 
                personid,
                case when (channel in (1,2,3)) then 0
                when (channel in (4,5,6)) then 1 end as expid
        from wesee::wesee_ccs_id
        where 
                dh between 2020060300 and 2020060323
                and priority in (1,2)
    ) b 
    on a.wesee_person_id = b.personid
    left join
    (
        select distinct personid as personid_rp
            -- , regexp_replace(substr(video_createtime,1,10),"-","") as createtime
        from wesee::dim_video_info_day
        where dt=date_add(20200603,7) and video_createtime >= to_date(date_add(20200603,1), "yyyyMMdd")
    ) c
    on c.personid_rp=b.personid
group by expid, talent_month_level



