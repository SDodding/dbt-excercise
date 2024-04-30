{{ config(
    schema="dwh",
    materialized="table"
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['a.ship_country','a."ship_postal_code"']) }}  AS location_id
    ,UPPER(a."ship_city")::TEXT                                                        AS city
    ,UPPER(a."ship_state")::TEXT                                                       AS state
    ,a."ship_postal_code"::INTEGER                                                     AS postal_code
    ,UPPER(a."ship_country")::TEXT                                                     AS country
FROM
  {{ ref("amazon_sale_report") }} AS a
