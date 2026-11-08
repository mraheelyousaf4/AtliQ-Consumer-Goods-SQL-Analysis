/* Request 4 | Top 5 markets by net sales in FY2021
   Output : market, net_sales_mln                                 */

SELECT
    market,
    ROUND(SUM(net_sales) / 1000000, 2) AS net_sales_mln
FROM net_sales
WHERE fiscal_year = 2021
GROUP BY market
ORDER BY net_sales_mln DESC
LIMIT 5;
