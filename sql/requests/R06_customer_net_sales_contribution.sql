/* Request 6 | Each customer's share of total net sales (all years)
   Output : customer, net_sales_mln, pct_contribution
   Note   : % is computed from UNROUNDED sales, then rounded for display. */

WITH customer_sales AS (
    SELECT
        c.customer,
        SUM(n.net_sales) AS net_sales
    FROM net_sales n
    JOIN dim_customer c
        ON c.customer_code = n.customer_code
    GROUP BY c.customer
)
SELECT
    customer,
    ROUND(net_sales / 1000000, 2)                  AS net_sales_mln,
    ROUND(net_sales * 100 / SUM(net_sales) OVER (), 2) AS pct_contribution
FROM customer_sales
ORDER BY net_sales DESC;
