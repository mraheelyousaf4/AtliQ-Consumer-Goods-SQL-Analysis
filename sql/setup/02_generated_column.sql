/* =====================================================================
   02 | PERFORMANCE OPTIMISATION: GENERATED COLUMN
   Calling get_fiscal_year(date) on every row is slow on a large fact
   table. A generated column computes the fiscal year once, and lets
   queries filter / join on a plain column instead of a function call.
   ===================================================================== */
USE gdb0041;

ALTER TABLE fact_sales_monthly
    ADD COLUMN fiscal_year YEAR
    GENERATED ALWAYS AS (YEAR(DATE_ADD(`date`, INTERVAL 4 MONTH))) STORED
    AFTER `date`;
