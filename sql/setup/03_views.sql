/* =====================================================================
   03 | REUSABLE VIEWS  (gross -> net invoice -> net sales)

   fact_sales_monthly + dim_product + fact_gross_price
        + fact_pre_invoice_deductions   -> sales_pre_inv_discount
   sales_pre_inv_discount
        + fact_post_invoice_deductions  -> sales_pos_inv_discount
   sales_pos_inv_discount               -> net_sales
   ===================================================================== */
USE gdb0041;

-- 1) Gross price + pre-invoice discount % --------------------------------
CREATE OR REPLACE VIEW sales_pre_inv_discount AS
SELECT
    s.date,
    s.fiscal_year,
    c.market,
    s.customer_code,
    s.product_code,
    p.product,
    p.variant,
    s.sold_quantity,
    g.gross_price                          AS gross_price_per_item,
    ROUND(g.gross_price * s.sold_quantity, 2) AS total_gross_price,
    pre.pre_invoice_discount_pct
FROM fact_sales_monthly s
JOIN dim_customer c
    ON c.customer_code = s.customer_code
JOIN dim_product p
    ON p.product_code = s.product_code
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
    AND g.fiscal_year  = s.fiscal_year
JOIN fact_pre_invoice_deductions pre
    ON  pre.customer_code = s.customer_code
    AND pre.fiscal_year   = s.fiscal_year;


-- 2) Net invoice sales + post-invoice deductions % -----------------------
CREATE OR REPLACE VIEW sales_pos_inv_discount AS
SELECT
    pr.date,
    pr.fiscal_year,
    pr.customer_code,
    pr.market,
    pr.product_code,
    pr.product,
    pr.variant,
    pr.sold_quantity,
    pr.gross_price_per_item,
    pr.total_gross_price,
    pr.pre_invoice_discount_pct,
    (1 - pr.pre_invoice_discount_pct) * pr.total_gross_price AS net_invoice_sales,
    (po.discounts_pct + po.other_deductions_pct)             AS post_invoice_discounts_pct
FROM sales_pre_inv_discount pr
JOIN fact_post_invoice_deductions po
    ON  po.date          = pr.date
    AND po.product_code  = pr.product_code
    AND po.customer_code = pr.customer_code;


-- 3) Final net sales -----------------------------------------------------
CREATE OR REPLACE VIEW net_sales AS
SELECT
    *,
    (1 - post_invoice_discounts_pct) * net_invoice_sales AS net_sales
FROM sales_pos_inv_discount;
