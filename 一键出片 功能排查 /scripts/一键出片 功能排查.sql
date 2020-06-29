---
select 	a.dt,
		a.account_id,
		a.video_id,
		b.movie_id,
		a.recommend_id
from
	(
		select 	dt,
				account_id,
				video_id,
				recommend_id
		from 	wesee::fact_event_action_mix_day
		where 	dt between 20200615 and 20200623
                and (account_id = 1516162396793610 
				or account_id = 1551255002175079
				or account_id = 1523360494234370)
	) a
	left join
	(
		select	imp_date,
				video_id,
				movie_id
		from	pcg_weishi_application::weishi_dim_video_upload_daily
		where	imp_date between 20200615 and 20200623
	) b
	on a.dt=b.imp_date and a.video_id=b.video_id