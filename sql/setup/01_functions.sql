/* =====================================================================
   01 | USER-DEFINED FUNCTIONS
   AtliQ's fiscal year starts in September (calendar date + 4 months).
   e.g. 2020-09-01 -> FY2021 | 2021-08-31 -> FY2021
   ===================================================================== */
USE gdb0041;

DROP FUNCTION IF EXISTS get_fiscal_year;
DROP FUNCTION IF EXISTS get_fiscal_quarter;

DELIMITER $$

CREATE FUNCTION get_fiscal_year(calendar_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(DATE_ADD(calendar_date, INTERVAL 4 MONTH));
END$$

CREATE FUNCTION get_fiscal_quarter(calendar_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN QUARTER(DATE_ADD(calendar_date, INTERVAL 4 MONTH));
END$$

DELIMITER ;

-- Quick test
SELECT get_fiscal_year('2020-09-01')    AS fy,   -- 2021
       get_fiscal_quarter('2020-09-01') AS fq;   -- 1
