{{ config(
    schema="dm",
    materialized="table"
) }}

WITH state_sales AS (
  SELECT
    l.state                    AS state,
    p.category                 AS clothing_category,
    SUM(s.qty)                 AS total_sales_amount,
    SUM(s.amount)              AS total_sales
  FROM
    {{ ref('fct_amazon_sales') }}   AS s
  JOIN {{ ref('dim_products') }}    AS p 
    ON s.product_id = p.product_id 
  JOIN {{ ref('dim_locations') }}   AS l 
    ON s.location_id = l.location_id
  GROUP BY
    l.state, p.category
),
ranked_categories AS (
  SELECT
    state,
    clothing_category,
    total_sales,
    total_sales_amount,
    ROW_NUMBER() OVER (PARTITION BY state ORDER BY total_sales DESC) AS category_rank
  FROM
    state_sales
)

SELECT
    rc.state
    ,rc.clothing_category
    ,rc.category_rank
    ,rc.total_sales                                 AS category_total_sales
    ,rc.total_sales_amount                          AS category_total_sales_amount           
FROM
    ranked_categories rc
ORDER BY
    rc.total_sales DESC
