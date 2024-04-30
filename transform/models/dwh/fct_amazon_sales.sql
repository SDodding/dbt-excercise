{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
     {{ dbt_utils.generate_surrogate_key(['a."asin"', 'a."sku"']) }}                    AS product_id
    ,{{ dbt_utils.generate_surrogate_key(['a."fulfilled_by"','a."ship_service_level"','a."courier_status"']) }}  AS shipping_id
    ,{{ dbt_utils.generate_surrogate_key(['a.ship_country','a."ship_postal_code"']) }}  AS location_id
    ,{{ dbt_utils.generate_surrogate_key(['a."date"']) }}                               AS date_id
    ,{{ dbt_utils.generate_surrogate_key(['a.status']) }}                               AS order_status_id
    ,a."order_id"::TEXT
    ,a."fulfilment"::TEXT
    ,a."b2b"::TEXT
    ,a."sales_channel"::TEXT
    ,a."qty"::NUMERIC::INTEGER
    ,a."amount"::NUMERIC
    ,a."currency"::TEXT
FROM
    {{ ref("amazon_sale_report") }} AS a
