/* =====================================================================
   04 | STORED PROCEDURES
   ===================================================================== */
USE gdb0041;

DROP PROCEDURE IF EXISTS get_monthly_gross_sales_for_customer;
DROP PROCEDURE IF EXISTS get_top_n_products_by_fy;

DELIMITER $$

/* Monthly gross sales for one OR many customers.
   Usage: CALL get_monthly_gross_sales_for_customer('90002002,90002008'); */
CREATE PROCEDURE get_monthly_gross_sales_for_customer (
    IN in_customer_codes TEXT
)
BEGIN
    SELECT
        s.date,
        ROUND(SUM(g.gross_price * s.sold_quantity), 2) AS total_gross_price
    FROM fact_sales_monthly s
    JOIN fact_gross_price g
        ON  g.product_code = s.product_code
        AND g.fiscal_year  = s.fiscal_year
    WHERE FIND_IN_SET(s.customer_code, in_customer_codes) > 0
    GROUP BY s.date
    ORDER BY s.date ASC;
END$$

/* Top N products (by product name, variants combined) by net sales
   for a given fiscal year.
   Usage: CALL get_top_n_products_by_fy(2021, 5); */
CREATE PROCEDURE get_top_n_products_by_fy (
    IN in_fiscal_year INT,
    IN in_top_n       INT
)
BEGIN
    SELECT
        product,
        ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln
    FROM net_sales
    WHERE fiscal_year = in_fiscal_year
    GROUP BY product
    ORDER BY net_sales_mln DESC
    LIMIT in_top_n;
END$$

DELIMITER ;
