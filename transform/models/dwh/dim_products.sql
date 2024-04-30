{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a."asin"', 'a."sku"']) }}  AS product_id
    ,a."style"
    ,a."sku"
    ,a."category"
    ,a."size"
    ,a."asin"
FROM
  {{ ref("amazon_sale_report") }} AS a
