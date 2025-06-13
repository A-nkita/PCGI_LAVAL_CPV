SELECT COUNT(*) 
FROM 
( SELECT cstl.BATCH_ID,
       cstl.TEST_TYPE,
       cstl.INDIV_SAMP_PROMPT,
       cstl.TRACKING_ID,
       cstl.VALUE,
       cstl.STAGE_ID,
       pbs.BATCH_PROD_DESC,
       pbs.BATCH_PROD_ID  FROM PROD.PM_BATCH_ST pbs
       INNER JOIN PROD.CO_SAMPLE_TEST_LG cstl
           ON     (pbs.ORDER_ID = cstl.ORDER_ID)
              AND (pbs.BATCH_ID = cstl.BATCH_ID)
)MARXP