select talent_month_level,
       manual_category,
       manual_category_l2,
       count(distinct video_id) as num
from
	(
		select	video_id,
				owner_id,
		       	manual_category,
		       	manual_category_l2
		from	pcg_weishi_application::weishi_public_video_info_dim_daily
		where	video_createtime between 1592582400 and 1595088000
		       	and manual_tags like '%质量_不清晰%'
		       	and audit_stage = 7
		       	and audit_result = 4
		       	and manual_expiretime > 1595215345
	) a
join
	(
		select	distinct wesee_person_id,
				talent_month_level
		from	pcg_wesee_content_analysis::t_weishi_talent_info_merge
		where	imp_date between 20200620 and 20200719
	) b
on a.owner_id = b.wesee_person_id
group by	talent_month_level,
            manual_category,
            manual_category_l2