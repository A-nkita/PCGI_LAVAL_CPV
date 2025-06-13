INSERT INTO comm_ops.cntl_etl_sql 
(sql_id, tbl_nm, sql_type, sql_txt, actv_flg, inrt_dt, inrt_by, modf_dt, modf_by, cmt) 
VALUES
(560038, 'BHC_CPV_LAVAL.L2_LVL_GLIMS', 'L2_INSERT',
'
INSERT INTO BHC_CPV_LAVAL.L2_LVL_GLIMS (
    MATERIAL_ID,
    Lot_Number,
    MATERIAL_DESC,
    Source,
    Data1,
    User_Sequence,
    CYCL_TIME_ID,
    SCEN_ID,
    INRT_BY,
    INRT_DT
)
SELECT 
    productid AS MATERIAL_ID,
    slx_lotnumber AS Lot_Number,
    material_desc AS MATERIAL_DESC,
    paramlistid AS Source,
    cast(displayvalue as VARCHAR(45)) AS Data1,
    usersequence AS User_Sequence,
    $cycl_time_id$ AS CYCL_TIME_ID,
    $scen_id$ AS SCEN_ID,
    inrt_by AS INRT_BY,
    inrt_dt AS INRT_DT
FROM
(
    SELECT 
        GL.productid,
        GL.s_batchid,
        GL.slx_lotnumber,
        GL.material_desc,
        GL.paramlistid,
        GL.variantid,
        GL.paramid,
        GL.displayvalue,
        GL.usersequence,
        b.inrt_by,
        b.inrt_dt,
        ROW_NUMBER() OVER () AS RowNum
    FROM
    (
        SELECT 
            b.productid,
            b.s_batchid,
            b.slx_lotnumber,
            s.slx_materialtype AS material_desc,
            CASE
                WHEN UPPER(sdi.paramlistid) LIKE ''%DISS%'' THEN ''Dissolution''
                ELSE sdi.paramlistid
            END AS paramlistid,
            CASE
                WHEN UPPER(sdi.paramlistid) LIKE ''%DISS%'' THEN ''Dissolution''
                ELSE sdi.variantid
            END AS variantid,
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(paramid, '' L2'', ''''),
                        '' L3'',
                        ''''
                    ),
                    '' S2'',
                    ''''
                ),
                '' S3'',
                ''''
            )
            || CASE
                WHEN paramtype = ''Standard'' THEN ''''
                ELSE '' (''
                    || CASE sdi.paramtype
                        WHEN ''Minimum'' THEN ''Min''
                        WHEN ''Maximum'' THEN ''Max''
                        WHEN ''Average'' THEN ''Avg''
                        ELSE sdi.paramtype
                    END
                    || '')''
            END AS paramid,
            cast(sdi.displayvalue as VARCHAR(45)) AS displayvalue,
            cast(sdi.usersequence as VARCHAR(45)) AS usersequence
        FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_S_BATCH b
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_S_SAMPLE s ON b.s_batchid = s.batchid
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA sd
                ON sd.sdcid = ''Sample'' AND sd.keyid1 = s.s_sampleid
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATAITEM sdi
                ON sdi.sdcid = sd.sdcid
                    AND sdi.keyid1 = sd.keyid1
                    AND sdi.keyid2 = sd.keyid2
                    AND sdi.keyid3 = sd.keyid3
                    AND sdi.paramlistid = sd.paramlistid
                    AND sdi.paramlistversionid = sd.paramlistversionid
                    AND sdi.variantid = sd.variantid
                    AND sdi.dataset = sd.dataset
        WHERE
            b.batchstatus = ''Released''
            AND sdi.displayvalue <> ''N/A''
            AND (
                UPPER(sd.paramlistid) NOT LIKE ''DISS%''
                OR (
                    UPPER(sd.paramlistid) LIKE ''DISS%''
                    AND EXISTS (
                        SELECT ''X''
                        FROM (
                            SELECT
                                keyid1,
                                paramlistid,
                                paramlistversionid,
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(variantid, '' L2'', ''''),
                                            '' L3'',
                                            ''''
                                        ),
                                        '' S2'',
                                        ''''
                                    ),
                                    '' S3'',
                                    ''''
                                ) vrnt,
                                MAX(usersequence) max_seq
                            FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA
                            WHERE sdcid = ''Sample''
                            GROUP BY
                                keyid1,
                                paramlistid,
                                paramlistversionid,
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(variantid, '' L2'', ''''),
                                            '' L3'',
                                            ''''
                                        ),
                                        '' S2'',
                                        ''''
                                    ),
                                    '' S3'',
                                    ''''
                                )
                        ) x
                        WHERE
                            sd.keyid1 = x.keyid1
                            AND sd.paramlistid = x.paramlistid
                            AND sd.paramlistversionid = x.paramlistversionid
                            AND sd.usersequence = x.max_seq
                    )
                )
            )
        UNION
        SELECT
            DISTINCT
            b.batchdesc AS productid,
            b.s_batchid,
            b.slx_lotnumber,
            s.slx_materialtype AS material_desc,
            CASE
                WHEN UPPER(sdi.paramlistid) LIKE ''%DISS%'' THEN ''Dissolution''
                ELSE sdi.paramlistid
            END AS paramlistid,
            CASE
                WHEN UPPER(sdi.paramlistid) LIKE ''%DISS%'' THEN ''Dissolution''
                ELSE sdi.variantid
            END AS variantid,
            ''Dissolution Level'' AS paramid,
            CAST(
                MAX(
                    CASE
                        WHEN sdi.variantid LIKE ''%L3'' THEN 3
                        WHEN sdi.variantid LIKE ''%S3'' THEN 3
                        WHEN sdi.variantid LIKE ''%L2'' THEN 2
                        WHEN sdi.variantid LIKE ''%S2'' THEN 2
                        ELSE 1
                    END
                ) as VARCHAR(45)
            ) AS displayvalue,
            cast(''0'' as VARCHAR(45)) AS usersequence
        FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_S_BATCH b
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_S_SAMPLE s ON b.s_batchid = s.batchid
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA sd
                ON sd.sdcid = ''Sample'' AND sd.keyid1 = s.s_sampleid
            INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATAITEM sdi
                ON sdi.sdcid = sd.sdcid
                    AND sdi.keyid1 = sd.keyid1
                    AND sdi.keyid2 = sd.keyid2
                    AND sdi.keyid3 = sd.keyid3
                    AND sdi.paramlistid = sd.paramlistid
                    AND sdi.paramlistversionid = sd.paramlistversionid
                    AND sdi.variantid = sd.variantid
                    AND sdi.dataset = sd.dataset
        WHERE
            b.batchstatus = ''Released''
            AND sdi.displayvalue <> ''N/A''
            AND (
                UPPER(sd.paramlistid) LIKE ''DISS%''
                AND EXISTS (
                    SELECT ''X''
                    FROM (
                        SELECT
                            keyid1,
                            paramlistid,
                            paramlistversionid,
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(variantid, '' L2'', ''''),
                                        '' L3'',
                                        ''''
                                    ),
                                    '' S2'',
                                    ''''
                                ),
                                '' S3'',
                                ''''
                            ) vrnt,
                            MAX(usersequence) max_seq
                        FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA
                        WHERE sdcid = ''Sample''
                        GROUP BY
                            keyid1,
                            paramlistid,
                            paramlistversionid,
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(variantid, '' L2'', ''''),
                                        '' L3'',
                                        ''''
                                    ),
                                    '' S2'',
                                    ''''
                                ),
                                '' S3'',
                                ''''
                            )
                    ) x
                    WHERE
                        sd.keyid1 = x.keyid1
                        AND sd.paramlistid = x.paramlistid
                        AND sd.paramlistversionid = x.paramlistversionid
                        AND sd.usersequence = x.max_seq
                )
            )
        GROUP BY
            b.batchdesc,
            b.s_batchid,
            sdi.paramlistid,
            sdi.variantid,
            b.slx_lotnumber,
            s.slx_materialtype
    ) GLM
    LEFT JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_S_BATCH b ON (
            b.productid = GLM.productid
            AND b.s_batchid = GLM.s_batchid
            AND b.slx_lotnumber = GLM.slx_lotnumber
        )
)
', 1, NULL, 'etluser', NULL, 'etluser', '');
