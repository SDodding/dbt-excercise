{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['d."date"']) }}  AS date_id
    ,d."date"
FROM
  {{ ref('amazon_sale_report') }} AS d
