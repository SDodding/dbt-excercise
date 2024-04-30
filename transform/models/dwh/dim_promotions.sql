{{ config(
    schema="dwh",
    materialized="table"
) }}

WITH promotion_codes AS (
  SELECT
    -- An unpleasant case for SQL as we need to return a dynamic number of rows per value
    -- Note: this is not particularly portable sql.
    -- gen_series, starting from 1 using outmost dimension of array (default)
    split_part(a.promotion_ids, ',', generate_series(
                1, array_length(
                        string_to_array(
                            a.promotion_ids, ','
                        ), 1
                   )
                )
              ) AS promotion_code
  FROM
    {{ ref("amazon_sale_report") }} AS a
)

SELECT DISTINCT 
    {{ dbt_utils.generate_surrogate_key(['p."promotion_code"']) }}  AS promotion_id
    ,p."promotion_code"
FROM
    promotion_codes AS p

