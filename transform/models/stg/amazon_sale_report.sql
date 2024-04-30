{{ config(
    schema="stg",
    materialized="table"
) }}

WITH amazon_sales_distinct AS (
    SELECT DISTINCT
         a."Order ID"                   AS order_id
        ,a."Date"                       AS date
        ,a."Status"                     AS status
        ,a."Fulfilment"                 AS fulfilment
        ,a."Sales Channel "             AS sales_channel
        ,a."ship-service-level"         AS ship_service_level
        ,a."Style"                      AS style
        ,a."SKU"                        AS sku
        ,a."Category"                   AS category
        ,a."Size"                       AS size
        ,a."ASIN"                       AS asin
        ,a."Courier Status"             AS courier_status
        ,a."Qty"                        AS qty
        ,a."currency"                   AS currency
        ,a."Amount"                     AS amount
        ,a."ship-city"                  AS ship_city
        ,a."ship-state"                 AS ship_state
        ,a."ship-postal-code"           AS ship_postal_code
        ,a."ship-country"               AS ship_country
        ,a."promotion-ids"              AS promotion_ids
        ,a."B2B"                        AS b2b
        ,a."fulfilled-by"               AS fulfilled_by
    FROM
        {{ ref('Amazon Sale Report') }} AS a
)

SELECT
    *
FROM
    amazon_sales_distinct
