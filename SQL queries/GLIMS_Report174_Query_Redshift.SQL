/* Formatted on 2023-08-08 15:21:17 (QP5 v5.381) */
--select b.batchdesc as productid, b.s_batchid,

SELECT b.productid,
       b.s_batchid,
       CASE
           WHEN UPPER (sdi.paramlistid) LIKE '%DISS%' THEN 'Dissolution'
           ELSE sdi.paramlistid
       END       AS paramlistid,
       CASE
           WHEN UPPER (sdi.paramlistid) LIKE '%DISS%' THEN 'Dissolution'
           ELSE sdi.variantid
       END       AS variantid,
          REPLACE (
              REPLACE (REPLACE (REPLACE (paramid, ' L2', ''), ' L3', ''),
                       ' S2',
                       ''),
              ' S3',
              '')
       || CASE
              WHEN paramtype = 'Standard'
              THEN
                  ''
              ELSE
                     ' ('
                  || CASE sdi.paramtype
                         WHEN 'Minimum' THEN 'Min'
                         WHEN 'Maximum' THEN 'Max'
                         WHEN 'Average' THEN 'Avg'
                         ELSE sdi.paramtype
                     END
                  || ')'
          END    AS paramid,
       sdi.displayvalue,
       sdi.usersequence
  FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_S_BATCH  b
       INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_S_SAMPLE s ON b.s_batchid = s.batchid
       INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA sd
           ON sd.sdcid = 'Sample' AND sd.keyid1 = s.s_sampleid
       INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATAITEM sdi
           ON     sdi.sdcid = sd.sdcid
              AND sdi.keyid1 = sd.keyid1
              AND sdi.keyid2 = sd.keyid2
              AND sdi.keyid3 = sd.keyid3
              AND sdi.paramlistid = sd.paramlistid
              AND sdi.paramlistversionid = sd.paramlistversionid
              AND sdi.variantid = sd.variantid
              AND sdi.dataset = sd.dataset
 WHERE                                              --b.productid = '10000312'
           b.batchstatus = 'Released'
       AND b.releaseddt >= DATE '2021-01-01'       -- or '31/12/2021' is null)
       AND b.releaseddt <= DATE '2021-01-31'       -- or b.releaseddt is null)
       -- and (upper(b.u_lotnumber) like '%'||upper($P{Lot})||'%' or $P{Lot} is null)
       AND sdi.displayvalue <> 'N/A'
       --Show Max of L1/L2/L3 or S1/S2/S3 for Dissolution
       AND (   UPPER (sd.paramlistid) NOT LIKE 'DISS%'
            OR (    UPPER (sd.paramlistid) LIKE 'DISS%'
                AND EXISTS
                        (SELECT 'X'
                           FROM (  SELECT keyid1,
                                          paramlistid,
                                          paramlistversionid,
                                          REPLACE (
                                              REPLACE (
                                                  REPLACE (
                                                      REPLACE (variantid,
                                                               ' L2',
                                                               ''),
                                                      ' L3',
                                                      ''),
                                                  ' S2',
                                                  ''),
                                              ' S3',
                                              '')               vrnt,
                                          MAX (usersequence)    max_seq
                                     FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA
                                    WHERE sdcid = 'Sample'
                                 GROUP BY keyid1,
                                          paramlistid,
                                          paramlistversionid,
                                          REPLACE (
                                              REPLACE (
                                                  REPLACE (
                                                      REPLACE (variantid,
                                                               ' L2',
                                                               ''),
                                                      ' L3',
                                                      ''),
                                                  ' S2',
                                                  ''),
                                              ' S3',
                                              '')) x
                          WHERE     sd.keyid1 = x.keyid1
                                AND sd.paramlistid = x.paramlistid
                                AND sd.paramlistversionid =
                                    x.paramlistversionid
                                AND sd.usersequence = x.max_seq)))
UNION
  SELECT DISTINCT
         b.batchdesc            AS productid,
         b.s_batchid,
         CASE
             WHEN UPPER (sdi.paramlistid) LIKE '%DISS%' THEN 'Dissolution'
             ELSE sdi.paramlistid
         END                    AS paramlistid,
         CASE
             WHEN UPPER (sdi.paramlistid) LIKE '%DISS%' THEN 'Dissolution'
             ELSE sdi.variantid
         END                    AS variantid,
         'Dissolution Level'    AS paramid,
         TO_CHAR (
             MAX (
                 CASE
                     WHEN sdi.variantid LIKE '%L3' THEN 3
                     WHEN sdi.variantid LIKE '%S3' THEN 3
                     WHEN sdi.variantid LIKE '%L2' THEN 2
                     WHEN sdi.variantid LIKE '%S2' THEN 2
                     ELSE 1
                 END))          AS displayvalue,
         0                      AS usersequence
    FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_S_BATCH b
         INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_S_SAMPLE s ON b.s_batchid = s.batchid
         INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA sd
             ON sd.sdcid = 'Sample' AND sd.keyid1 = s.s_sampleid
         INNER JOIN BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATAITEM sdi
             ON     sdi.sdcid = sd.sdcid
                AND sdi.keyid1 = sd.keyid1
                AND sdi.keyid2 = sd.keyid2
                AND sdi.keyid3 = sd.keyid3
                AND sdi.paramlistid = sd.paramlistid
                AND sdi.paramlistversionid = sd.paramlistversionid
                AND sdi.variantid = sd.variantid
                AND sdi.dataset = sd.dataset
   WHERE                                           --b.productid =  '10000312'
             b.batchstatus = 'Released'
         AND b.releaseddt >= DATE '2021-01-01'
         AND b.releaseddt <= DATE '2021-01-31'     -- or b.releaseddt is null)
         -- and (upper(b.u_lotnumber) like '%'||upper($P{Lot})||'%' or $P{Lot} is null)
         AND sdi.displayvalue <> 'N/A'
         --Show Max of L1/L2/L3 or S1/S2/S3 for Dissolution
         AND (    UPPER (sd.paramlistid) LIKE 'DISS%'
              AND EXISTS
                      (SELECT 'X'
                         FROM (  SELECT keyid1,
                                        paramlistid,
                                        paramlistversionid,
                                        REPLACE (
                                            REPLACE (
                                                REPLACE (
                                                    REPLACE (variantid,
                                                             ' L2',
                                                             ''),
                                                    ' L3',
                                                    ''),
                                                ' S2',
                                                ''),
                                            ' S3',
                                            '')               vrnt,
                                        MAX (usersequence)    max_seq
                                   FROM BHC_CPV_LAVAL.STG_LVL_GLIMS_SDIDATA
                                  WHERE sdcid = 'Sample'
                               GROUP BY keyid1,
                                        paramlistid,
                                        paramlistversionid,
                                        REPLACE (
                                            REPLACE (
                                                REPLACE (
                                                    REPLACE (variantid,
                                                             ' L2',
                                                             ''),
                                                    ' L3',
                                                    ''),
                                                ' S2',
                                                ''),
                                            ' S3',
                                            '')) x
                        WHERE     sd.keyid1 = x.keyid1
                              AND sd.paramlistid = x.paramlistid
                              AND sd.paramlistversionid = x.paramlistversionid
                              AND sd.usersequence = x.max_seq))
GROUP BY b.batchdesc,
         b.s_batchid,
         CASE
             WHEN UPPER (sdi.paramlistid) LIKE '%DISS%' THEN 'Dissolution'
             ELSE sdi.variantid
         END,
         sdi.paramlistid,
         'Dissolution Level',
         0
--order by b.s_batchid, sdi.paramlistid, sdi.variantid, sdi.usersequence, sdi.paramid
ORDER BY 2, 3                                                     --4, 5, 8, 6
