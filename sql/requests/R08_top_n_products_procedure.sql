/* Request 8 | Top N products by net sales for a given fiscal year
   (product name without variant)
   Implemented as stored procedure: sql/setup/04_stored_procedures.sql */

CALL get_top_n_products_by_fy(2021, 5);
