CREATE OR REPLACE FUNCTION `keepcoding.clean_integer`(int_to_clean INT64) AS (
IFNULL(int_to_clean, -999999)
);
