{{ config(
    schema="dwh",
    materialized="table"
) }}

WITH product_data AS (
  SELECT
     a."Style"                                                        AS style
    ,a."SKU"                                                          AS sku
    ,a."Category"                                                     AS category
    ,a."Size"                                                         AS size
    ,a."ASIN"                                                         AS asin
  FROM
    {{ ref('Amazon Sale Report') }} AS a
)

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['p."asin"', 'p."sku"']) }}  AS product_id
    ,p."style"
    ,p."sku"
    ,p."category"
    ,p."size"
    ,p."asin"
FROM
  product_data AS p
