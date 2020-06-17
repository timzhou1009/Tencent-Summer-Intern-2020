select 
        video_id,
        manual_category,
        manual_category_l2,
        ai_dang_wei
from
    (
        select
                *,
                row_number() over(partition by manual_category order by video_id) as RN
        from
            (
                select   
                        video_id,    
                        video_createtime,
                        manual_category,
                        manual_category_l2,
                        ai_dang_wei                     
                from
                        pcg_weishi_application::weishi_public_video_info_dim_daily
                where 
                        video_createtime between 1588348800 and 1591113600
                        and manual_tags like '%质量_不清晰%' 
                group by video_id, video_createtime, manual_category, manual_category_l2, ai_dang_wei
            )
    )
where RN between 1 and 500