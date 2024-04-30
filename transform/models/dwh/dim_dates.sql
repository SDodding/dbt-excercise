{{ config(
    schema="dwh",
    materialized="table"
) }}

WITH date_converted AS (
    SELECT
        d.date                              AS date_str
        ,to_date(d."date", 'MM-DD-YY')      AS date
    FROM
        {{ ref('amazon_sale_report') }}     AS d
)

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['d."date_str"']) }}    AS date_id
    ,d."date"                                                   AS date
    ,EXTRACT(year FROM d.date)                                  AS year
    ,EXTRACT(month FROM d.date)                                 AS month
    ,EXTRACT(day FROM d.date)                                   AS day
    ,EXTRACT(dow FROM d.date)                                   AS dow
    ,CASE
      WHEN EXTRACT(month FROM d.date) IN (1, 2, 3) THEN 'Q1'    
      WHEN EXTRACT(month FROM d.date) IN (4, 5, 6) THEN 'Q2'    
      WHEN EXTRACT(month FROM d.date) IN (7, 8, 9) THEN 'Q3'    
      ELSE 'Q4'
    END                                                         AS quarter
FROM
    date_converted                                              AS d
ORDER BY
    d."date" DESC
