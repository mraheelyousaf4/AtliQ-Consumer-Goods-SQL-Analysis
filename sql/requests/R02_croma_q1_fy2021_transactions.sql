/* Request 2 | Transaction-level sales report for Croma, Q1 of FY2021
   (Fiscal Q1 = September - November)
   Output : date, product_code, product, variant, sold_quantity,
            gross_price_per_item, total_gross_price                */

SELECT
    s.date,
    s.product_code,
    p.product,
    p.variant,
    s.sold_quantity,
    g.gross_price                              AS gross_price_per_item,
    ROUND(g.gross_price * s.sold_quantity, 2)  AS total_gross_price
FROM fact_sales_monthly s
JOIN dim_product p
    ON p.product_code = s.product_code
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
    AND g.fiscal_year  = s.fiscal_year
WHERE s.customer_code = 90002002
  AND s.fiscal_year   = 2021
  AND get_fiscal_quarter(s.date) = 1
ORDER BY s.date DESC;
