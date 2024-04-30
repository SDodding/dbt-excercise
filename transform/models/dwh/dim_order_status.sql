{{ config(
    schema="dwh",
    materialized="table"
) }}

WITH order_statuses AS (
SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a.status']) }}                AS order_status_id
    ,UPPER(a.status)::TEXT                                              AS order_status
FROM
  {{ ref("amazon_sale_report") }} AS a
)

SELECT 
    a.order_status_id
    ,a.order_status
    ,CASE
        WHEN a.order_status = 'SHIPPED - DELIVERED TO BUYER' THEN TRUE
        WHEN a.order_status = 'SHIPPED - PICKED UP' THEN TRUE
        ELSE FALSE
     END                                                                AS success
    ,CASE
        WHEN a.order_status = 'PENDING' THEN TRUE
        WHEN a.order_status = 'SHIPPED' THEN TRUE
        WHEN a.order_status = 'SHIPPED - OUT FOR DELIVERY' THEN TRUE
        WHEN a.order_status = 'SHIPPING' THEN TRUE
        WHEN a.order_status = 'PENDING - WAITING FOR PICK UP' THEN TRUE
        ELSE FALSE
     END                                                                AS in_progress

FROM
    order_statuses AS a
