{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a.status']) }}                AS order_status_id
    ,UPPER(a.status)::TEXT                                              AS order_status
FROM
  {{ ref("amazon_sale_report") }} AS a
