/* Request 5 | Top 5 customers by net sales in FY2021
   Output : customer, net_sales_mln
   Note   : grouped by customer NAME, so a customer operating in several
            markets (e.g. Amazon) is combined into one line.        */

SELECT
    c.customer,
    ROUND(SUM(n.net_sales) / 1000000, 2) AS net_sales_mln
FROM net_sales n
JOIN dim_customer c
    ON c.customer_code = n.customer_code
WHERE n.fiscal_year = 2021
GROUP BY c.customer
ORDER BY net_sales_mln DESC
LIMIT 5;
