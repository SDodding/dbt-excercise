{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a."fulfilled_by"','a."ship_service_level"','a."courier_status"']) }}  AS shipping_id
    ,a."fulfilled_by"
    ,a."ship_service_level"
    ,a."courier_status"
FROM
  {{ ref("amazon_sale_report") }} AS a
