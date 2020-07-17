select  distinct qimei,
        account_id
from    wesee::fact_event_action_mix_day
where   dt between 20200623 and 20200705
        and instr(recommend_id_map['wesee_abv2_801'],"158217") > 0
        and  regexp_extract(url_decode(url_decode(recommend_id, 'utf-8'), 'utf-8'), 'rid=(\\\d+)', 1) = 1070
        and play_vv = 1

select 	a.account_id
from
	(
		select 	account_id
		from pcg_weishi_application::exp158217_ids
	) a
	join
	(
		select	owner_id
		from	pcg_weishi_application::weishi_public_video_info_dim_daily
		where	imp_date between 20200623 and 20200705
	) b
	on a.account_id = b.owner_id



select	owner_id
from	pcg_weishi_application::weishi_public_video_info_dim_daily a
where	imp_date between 20200623 and 20200705
		and exists(
					select 	account_id
					from pcg_weishi_application::exp158217_ids b
					where a.owner_id = b.account_id)
