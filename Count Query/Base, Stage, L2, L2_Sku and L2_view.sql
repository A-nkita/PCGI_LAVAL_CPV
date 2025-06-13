SELECT 'bs_lvl_marsxp_co_sample_test_lg' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_marsxp_co_sample_test_lg
UNION ALL
SELECT 'stg_lvl_marsxp_co_sample_test_lg' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_marsxp_co_sample_test_lg
UNION ALL
SELECT 'bs_lvl_marsxp_mm_material_plant_sp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_marsxp_mm_material_plant_sp
UNION ALL
SELECT 'stg_lvl_marsxp_mm_material_plant_sp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_marsxp_mm_material_plant_sp
UNION ALL
SELECT 'bs_lvl_marsxp_pm_batch_st' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_marsxp_pm_batch_st
UNION ALL
SELECT 'stg_lvl_marsxp_pm_batch_st' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_marsxp_pm_batch_st
UNION ALL
SELECT 'bs_lvl_csp_csp_actions' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_csp_csp_actions
UNION ALL
SELECT 'stg_lvl_csp_csp_actions' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_csp_csp_actions
UNION ALL
SELECT 'bs_lvl_csp_csp_lien_produits_lots' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_csp_csp_lien_produits_lots
UNION ALL
SELECT 'stg_lvl_csp_csp_lien_produits_lots' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_csp_csp_lien_produits_lots
UNION ALL
SELECT 'bs_lvl_csp_csp_valeurs' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_csp_csp_valeurs
UNION ALL
SELECT 'stg_lvl_csp_csp_valeurs' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_csp_csp_valeurs
UNION ALL
SELECT 'bs_lvl_csp_csp_type_caracteristiques' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_csp_csp_type_caracteristiques
UNION ALL
SELECT 'stg_lvl_csp_csp_type_caracteristiques' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_csp_csp_type_caracteristiques
UNION ALL
SELECT 'bs_lvl_glims_s_batch' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_glims_s_batch
UNION ALL
SELECT 'stg_lvl_glims_s_batch' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_glims_s_batch
UNION ALL
SELECT 'bs_lvl_glims_s_sample' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_glims_s_sample
UNION ALL
SELECT 'stg_lvl_glims_s_sample' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_glims_s_sample
UNION ALL
SELECT 'bs_lvl_glims_sdidata' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_glims_sdidata
UNION ALL
SELECT 'stg_lvl_glims_sdidata' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_glims_sdidata
UNION ALL
SELECT 'bs_lvl_glims_sdidataitem' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.bs_lvl_glims_sdidataitem
UNION ALL
SELECT 'stg_lvl_glims_sdidataitem' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.stg_lvl_glims_sdidataitem
UNION ALL
SELECT 'l2_lvl_marsxp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_marsxp
UNION ALL
SELECT 'l2_lvl_csp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_csp
UNION ALL
SELECT 'l2_lvl_glims' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_glims
UNION all
SELECT 'l2_lvl_marsxp_sku' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_marsxp_sku llms 
UNION ALL
SELECT 'l2_lvl_csp_sku' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_csp_sku llcs 
UNION ALL
SELECT 'l2_lvl_glims_sku' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.l2_lvl_glims_sku llgs 
UNION ALL 
SELECT 'View_l2_lvl_marsxp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.v_l2_lvl_marsxp_sku vllms 
UNION ALL
SELECT 'View_l2_lvl_csp' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.v_l2_lvl_csp_sku vllcs 
UNION ALL
SELECT 'View_l2_lvl_glims' AS table_name, count(*) AS row_count FROM bhc_cpv_laval.v_l2_lvl_glims_sku vllgs ;