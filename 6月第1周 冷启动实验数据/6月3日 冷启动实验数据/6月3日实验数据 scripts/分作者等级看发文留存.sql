--分作者等级看发文留存 7日
select expid, priority, pugc,
    sum(person_num) person_num,
    sum(person_repost_within*person_num)/sum(person_num) person_repost_within,
    sum(person_repost*person_num)/sum(person_num) person_repost
from (
    select *,
        case when (channel in ("1","2","3")) then 0
            when (channel in ("4","5","6")) then 1
            end as expid
    from wesee::ccs_stats_longterm_repost_day7
    where 
    	ftime = 20200603
        --ftime between 20200525 and 20200531
)
group by expid, priority, pugc

--分作者等级看发文留存 3日
select expid, priority, pugc,
    sum(person_num) person_num,
    sum(person_repost_within*person_num)/sum(person_num) person_repost_within,
    sum(person_repost*person_num)/sum(person_num) person_repost
from (
    select *,
        case when (channel in ("1","2","3")) then 0
            when (channel in ("4","5","6")) then 1
            end as expid
    from wesee::ccs_stats_longterm_repost_day3
    where 
    	ftime = 20200603
        --ftime between 20200525 and 20200531
)
group by expid, priority, pugc

--分作者等级看发文留存 2日
select expid, priority, pugc,
    sum(person_num) person_num,
    sum(person_repost_within*person_num)/sum(person_num) person_repost_within,
    sum(person_repost*person_num)/sum(person_num) person_repost
from (
    select *,
        case when (channel in ("1","2","3")) then 0
            when (channel in ("4","5","6")) then 1
            end as expid
    from wesee::ccs_stats_longterm_repost_2moro
    where 
    	ftime = 20200603
        --ftime between 20200525 and 20200531
)
group by expid, priority, pugc