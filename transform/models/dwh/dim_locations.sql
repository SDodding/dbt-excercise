{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a.ship_country','a."ship_postal_code"']) }}  AS location_id
    ,a."ship_city"
    ,a."ship_state"
    ,a."ship_postal_code"
    ,a."ship_country"
FROM
  {{ ref("amazon_sale_report") }} AS a
