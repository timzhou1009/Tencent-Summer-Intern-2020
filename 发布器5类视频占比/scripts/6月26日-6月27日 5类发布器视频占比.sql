-- 6月26日-6月27日 5类发布器视频占比
-- 总
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	)
group by dt, expid

-- 魔法
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				video_id,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	) a
	join
	(
		select 	imp_date,
				video_id
		from 	pcg_weishi_application::weishi_dim_video_upload_daily
		where 	imp_date between 20200626 and 20200627
				and is_magic = "1"
	) b
	on a.video_id = b.video_id
group by dt, expid

-- 模板（大片）
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				video_id,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	) a
	join
	(
		select 	imp_date,
				video_id
		from 	pcg_weishi_application::weishi_dim_video_upload_daily
		where 	imp_date between 20200626 and 20200627
				and mode_id != "0"
				and mode_id != ""
				and mode_id != "1"
	) b
	on a.video_id = b.video_id
group by dt, expid

-- H5素材
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				video_id,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	) a
	join
	(
		select 	imp_date,
				video_id
		from 	pcg_weishi_application::weishi_dim_video_upload_daily
		where 	imp_date between 20200626 and 20200627
				and h5material_id is not null 
				and h5material_id !=''

	) b
	on a.video_id = b.video_id
group by dt, expid

-- 一键出片
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				video_id,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	) a
	join
	(
		select 	imp_date,
				video_id
		from 	pcg_weishi_application::weishi_dim_video_upload_daily
		where 	imp_date between 20200626 and 20200627
				and is_movie = '1' 
	) b
	on a.video_id = b.video_id
group by dt, expid

-- 王者
select 	dt,
		expid,
		sum(play_vv)
from
	(
		select  dt,
				video_id,
				play_vv,
				case when (instr(recommend_id_map['wesee_abv2_801'],"160496") > 0) then 1
				when (instr(recommend_id_map['wesee_abv2_801'],"160495") > 0) then 0 
				end as expid
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200626 and 20200627
				and is_recommend = 1
	) a
	join
	(
		select 	imp_date,
				video_id
		from 	pcg_weishi_application::weishi_dim_video_upload_daily
		where 	imp_date between 20200626 and 20200627
				and video_type in ("23","24")
	) b
	on a.video_id = b.video_id
group by dt, expid