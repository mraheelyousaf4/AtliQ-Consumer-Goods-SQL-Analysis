/* Request 3 | Monthly gross sales report for Croma
   Output : date, total_gross_price                               */

-- Ad hoc query
SELECT
    s.date,
    ROUND(SUM(g.gross_price * s.sold_quantity), 2) AS total_gross_price
FROM fact_sales_monthly s
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
    AND g.fiscal_year  = s.fiscal_year
WHERE s.customer_code = 90002002
GROUP BY s.date
ORDER BY s.date ASC;

-- Reusable version: stored procedure (accepts one or many customer codes)
CALL get_monthly_gross_sales_for_customer('90002002');
