{{ config(
    schema="dwh",
    materialized="table"
) }}

WITH amazon_sales_data AS (
  SELECT
    a.*
  FROM
    {{ ref('Amazon Sale Report') }} AS a
)

SELECT
   {{ dbt_utils.generate_surrogate_key(['a."ASIN"', 'a."SKU"']) }}  AS product_id
   ,a."Order ID"                                                    AS order_id
   ,a."Fulfilment"                                                  AS fulfilment
   ,a."Qty"                                                         AS quantity
   ,a."Amount"                                                      AS amount
   ,a."currency"                                                    AS currency
FROM
    amazon_sales_data a
    
