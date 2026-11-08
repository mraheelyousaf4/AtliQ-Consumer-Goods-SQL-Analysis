/* Request 1 | Yearly gross sales report for Croma India
   Output : fiscal_year, total_gross_sales                        */

-- Step 1: find Croma's customer code (-> 90002002)
SELECT * FROM dim_customer WHERE customer LIKE '%Croma%';

-- Version A: using the fiscal-year function (works on any table)
SELECT
    get_fiscal_year(s.date)                        AS fiscal_year,
    ROUND(SUM(g.gross_price * s.sold_quantity), 2) AS total_gross_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
    AND g.fiscal_year  = get_fiscal_year(s.date)
WHERE s.customer_code = 90002002
GROUP BY fiscal_year
ORDER BY fiscal_year;

-- Version B: optimised, using the generated fiscal_year column
SELECT
    s.fiscal_year,
    ROUND(SUM(g.gross_price * s.sold_quantity), 2) AS total_gross_sales
FROM fact_sales_monthly s
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
    AND g.fiscal_year  = s.fiscal_year
WHERE s.customer_code = 90002002
GROUP BY s.fiscal_year
ORDER BY s.fiscal_year;
