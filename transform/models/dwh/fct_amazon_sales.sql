{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
     {{ dbt_utils.generate_surrogate_key(['a."asin"', 'a."sku"']) }}                    AS product_id
    ,{{ dbt_utils.generate_surrogate_key(['a."fulfilled_by"','a."ship_service_level"','a."courier_status"']) }}  AS shipping_id
    ,{{ dbt_utils.generate_surrogate_key(['a.ship_country','a."ship_postal_code"']) }}  AS location_id
    ,{{ dbt_utils.generate_surrogate_key(['a."date"']) }}                               AS date_id
    ,a."order_id"
    ,a."fulfilment"
    ,a."qty"
    ,a."amount"
    ,a."currency"
FROM
    {{ ref("amazon_sale_report") }} AS a
