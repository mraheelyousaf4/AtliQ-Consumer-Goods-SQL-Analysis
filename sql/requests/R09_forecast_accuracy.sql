/* Request 9 | Forecast accuracy report for the Supply Chain team

   Forecast accuracy = 100 - Absolute Error %      (floored at 0)
   Absolute Error %  = SUM(|forecast - sold|) * 100 / SUM(forecast)
   Net Error %       = SUM(forecast - sold)   * 100 / SUM(forecast)
                       (positive = over-forecasting)               */

-- Part A: customer-level forecast accuracy report for FY2021
WITH forecast_error AS (
    SELECT
        s.customer_code,
        c.customer,
        c.market,
        SUM(s.sold_quantity)     AS sold_quantity,
        SUM(s.forecast_quantity) AS forecast_quantity,
        SUM(s.forecast_quantity - s.sold_quantity) AS net_err,
        SUM(s.forecast_quantity - s.sold_quantity) * 100
            / NULLIF(SUM(s.forecast_quantity), 0)  AS net_err_pct,
        SUM(ABS(s.forecast_quantity - s.sold_quantity)) AS abs_err,
        SUM(ABS(s.forecast_quantity - s.sold_quantity)) * 100
            / NULLIF(SUM(s.forecast_quantity), 0)  AS abs_err_pct
    FROM fact_act_est s
    JOIN dim_customer c
        ON c.customer_code = s.customer_code
    WHERE s.fiscal_year = 2021
    GROUP BY s.customer_code, c.customer, c.market
)
SELECT
    *,
    GREATEST(0, 100 - abs_err_pct) AS forecast_accuracy
FROM forecast_error
ORDER BY forecast_accuracy DESC;


-- Part B: customers whose forecast accuracy DROPPED from FY2020 to FY2021
--   Output: customer_code, customer_name, market,
--           forecast_accuracy_2020, forecast_accuracy_2021
WITH forecast_error AS (
    SELECT
        s.fiscal_year,
        s.customer_code,
        c.customer AS customer_name,
        c.market,
        SUM(ABS(s.forecast_quantity - s.sold_quantity)) * 100.0
            / NULLIF(SUM(s.forecast_quantity), 0) AS abs_err_pct
    FROM fact_act_est s
    JOIN dim_customer c
        ON c.customer_code = s.customer_code
    WHERE s.fiscal_year IN (2020, 2021)
    GROUP BY s.fiscal_year, s.customer_code, c.customer, c.market
),
forecast_accuracy AS (
    SELECT *, GREATEST(0, 100 - abs_err_pct) AS forecast_accuracy
    FROM forecast_error
)
SELECT
    fa20.customer_code,
    fa20.customer_name,
    fa20.market,
    ROUND(fa20.forecast_accuracy, 2) AS forecast_accuracy_2020,
    ROUND(fa21.forecast_accuracy, 2) AS forecast_accuracy_2021
FROM forecast_accuracy fa20
JOIN forecast_accuracy fa21
    ON  fa20.customer_code = fa21.customer_code
    AND fa20.fiscal_year   = 2020
    AND fa21.fiscal_year   = 2021
WHERE fa21.forecast_accuracy < fa20.forecast_accuracy
ORDER BY forecast_accuracy_2020 DESC;
