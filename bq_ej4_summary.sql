CREATE OR REPLACE TABLE
  keepcoding.ivr_summary AS
SELECT
  calls_ivr_id AS ivr_id,
  calls_phone_number AS phone_number,
  calls_ivr_result AS ivr_result,
  CASE
    WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
    WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH'
    WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
  ELSE
  'RESTO'
END
  AS vdn_aggregation,
  calls_start_date AS start_date,
  calls_end_date AS end_date,
  calls_total_duration AS total_duration,
  calls_customer_segment AS customer_segment,
  calls_ivr_language AS ivr_language,
  COUNT(calls_steps_module) AS steps_module,
  ARRAY_AGG(calls_module_aggregation) AS module_aggregation,
  COALESCE(document_type) AS document_type,
  COALESCE(document_identification) AS document_identification,
  COALESCE(customer_phone) AS customer_phone,
  COALESCE(billing_account_id) AS billing_account_id,
  MAX(CASE
        WHEN module_name = 'AVERIA_MASIVA' THEN 1
      ELSE
      0
    END
      ) AS masiva_lg,
  
    CASE
      WHEN module_name = 'CUSTOMERINFOBYPHONE.TX' AND step_description_error = 'UNKNOWN' THEN 1
    ELSE
    0
  END
     AS info_by_phone_lg,
    CASE
      WHEN module_name = 'CUSTOMERINFOBYDNI.TX' AND step_description_error = 'UNKNOWN' THEN 1
    ELSE
    0
  END
     AS info_by_dni_lg,
     CASE WHEN TIMESTAMP_DIFF(calls_start_date, LAG(calls_start_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_start_date), HOUR) <= 24 THEN 1 ELSE 0 END AS repeated_phone_24H,
     CASE WHEN TIMESTAMP_DIFF(calls_start_date, LEAD(calls_start_date) OVER (PARTITION BY calls_phone_number ORDER BY calls_start_date), HOUR) <= 24 THEN 1 ELSE 0 END AS cause_recall_phone_24H
FROM
  `keepcoding.ivr_detail`
GROUP BY
  calls_ivr_id,
  calls_phone_number,
  calls_ivr_result,
  calls_vdn_label,
  calls_start_date,
  calls_end_date,
  calls_total_duration,
  calls_customer_segment,
  calls_ivr_language,
  calls_module_aggregation,
  document_type,
  document_identification,
  customer_phone,
  billing_account_id,
  module_name,
  step_description_error
