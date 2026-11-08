/* Request 7 | Top 2 markets in every region by gross sales in FY2021
   Output : market, region, gross_sales_mln, rank_in_region        */

WITH market_sales AS (
    SELECT
        c.region,
        n.market,
        ROUND(SUM(n.total_gross_price) / 1000000, 2) AS gross_sales_mln,
        DENSE_RANK() OVER (
            PARTITION BY c.region
            ORDER BY SUM(n.total_gross_price) DESC
        ) AS rank_in_region
    FROM net_sales n
    JOIN dim_customer c
        ON c.customer_code = n.customer_code
    WHERE n.fiscal_year = 2021
    GROUP BY c.region, n.market
)
SELECT *
FROM market_sales
WHERE rank_in_region <= 2
ORDER BY region, rank_in_region;
