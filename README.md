<h1 align="center">📊 AtliQ Hardware · Consumer Goods Sales Analytics</h1>

<p align="center">
  <b>From raw sales tables to boardroom answers: an end-to-end MySQL project covering sales, net revenue, customers, markets and demand forecasting.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white" alt="MySQL"/>
  <img src="https://img.shields.io/badge/Excel-Charts-217346?style=for-the-badge\&logo=microsoftexcel\&logoColor=white" alt="Excel"/>
  <img src="https://img.shields.io/badge/Domain-Consumer\_Goods-F28C28?style=for-the-badge" alt="Domain"/>
  <img src="https://img.shields.io/badge/Codebasics-Data\_Analytics\_Bootcamp-1F6FEB?style=for-the-badge" alt="Codebasics"/>
</p>

<p align="center">
  <a href="#-the-project-journey">Journey</a> ·
  <a href="#-key-insights">Insights</a> ·
  <a href="#-business-requests">Requests</a> ·
  <a href="#-data-model">Data Model</a> ·
  <a href="#-how-to-run">Run It</a> ·
  <a href="docs/query\_walkthrough.md">Full Walkthrough</a>
</p>

\---

## ⚡ Project at a Glance

|9|3|2|2|1|31|
|:-:|:-:|:-:|:-:|:-:|:-:|
|**Business requests**|**Layered views**|**Custom functions**|**Stored procedures**|**Generated column**|**Annotated screenshots**|

\---

## 🏢 Business Context

**AtliQ Hardware** sells PCs, peripherals and storage worldwide through retailers, e-commerce platforms and its own direct channels (**Atliq Exclusive** and **Atliq e Store**).

Sales, finance, key-account and supply-chain teams all depend on the same data, and each asks different questions:

* *Which markets and customers drive revenue?*
* *How much of gross sales survives discounts?*
* *How accurate are our demand forecasts?*

This project plays the role of the data analyst. It builds a **reusable SQL layer** (functions, views, stored procedures) and uses it to answer **9 real business requests**, each with the query, the output screenshot and the answer.

> 📌 AtliQ's \*\*fiscal year starts in September\*\*. FY2021 = Sep 2020 to Aug 2021.

\---

## 🧭 The Project Journey

The project was built in phases. Each phase fixed a problem found in the previous one.

|Phase|What happened|The "why"|
|:-:|-|-|
|**0**|Explored the 11 tables of `gdb0041`|Understand dimensions vs facts|
|**1**|**Fresh start:** first Croma request, customer lookup|Sales are by calendar month, prices by fiscal year|
|**2**|Built `get\_fiscal\_year()` and `get\_fiscal\_quarter()`|Fiscal logic written once, reused everywhere|
|**3**|**Change:** generated `fiscal\_year` column|Faster than calling a function on every row|
|**4**|Monthly report became a **stored procedure**|One-off query turned into a self-service tool|
|**5**|Three layered views: v1, improved v2, post-invoice, net sales|Net-sales logic written once, no repeated joins|
|**6**|Top markets, customers, share %, regional ranking, top products|Leadership questions on top of `net\_sales`|
|**7**|Forecast accuracy: temp tables replaced by CTEs|Cleaner, safer, no copy-paste|
|**8**|Inventory of every object built|A complete, auditable analytics layer|

👉 Every phase, with before/after screenshots, is in the [**Query Walkthrough**](docs/query_walkthrough.md).

\---

## 💡 Key Insights

|#|Finding|Number|
|:-:|-|-|
|1|**Croma India is scaling fast.** Gross sales rose FY2020 → FY2021 → FY2022|$6.50M → **$23.22M** (+257%) → **$44.64M** (+92%)|
|2|**India is the #1 market** by net sales in FY2021, about 1.6× the USA|**$210.67M** vs $132.05M|
|3|**About half of gross sales never reaches net sales** after pre- and post-invoice deductions|India keeps \~**46%**, USA \~**50%**|
|4|**Revenue is concentrated.** Amazon leads FY2021, and the top 9 customers hold nearly half of all net sales|Amazon **$109.03M**; top 9 ≈ **48.9%**|
|5|**AtliQ's own channels outweigh Amazon.** Atliq Exclusive plus Atliq e Store|**\~18.2%** vs Amazon 13.76%|
|6|**Best-selling products, FY2021:** AQ BZ Allin1, AQ Qwerty, AQ Trigger|**$33.75M**, $27.84M, $26.95M|
|7|**Forecasting has headroom.** Best customers reach only \~47% accuracy, and all show over-forecasting (13 to 31%)|Excess-inventory risk|

\---

## 🎯 Business Requests

|#|Business request|Stakeholder|Key technique|Answer in|
|:-:|-|-|-|:-:|
|1|Croma India yearly gross sales|Sales|Joins, UDF|[R1](docs/query_walkthrough.md#r1)|
|2|Croma transactions, fiscal Q1 FY2021|Sales|Fiscal quarter function|[R2](docs/query_walkthrough.md#r2)|
|3|Monthly gross sales for any customers|Sales / Finance|**Stored procedure**|[R3](docs/query_walkthrough.md#r3)|
|4|Top 5 markets by net sales, FY2021|Leadership|Layered views|[R4](docs/query_walkthrough.md#r4)|
|5|Top 5 customers by net sales, FY2021|Key Accounts|Views + joins|[R5](docs/query_walkthrough.md#r5)|
|6|Each customer's % of net sales|Finance|**CTE + `SUM() OVER()`**|[R6](docs/query_walkthrough.md#r6)|
|7|Top 2 markets in every region|Regional Heads|**`DENSE\_RANK()` + `PARTITION BY`**|[R7](docs/query_walkthrough.md#r7)|
|8|Top N products for any year|Product Team|**Parameterised procedure**|[R8](docs/query_walkthrough.md#r8)|
|9|Customers whose forecast accuracy dropped|Supply Chain|CTEs + self-join|[R9](docs/query_walkthrough.md#r9)|

SQL for each request is in [`sql/requests/`](sql/requests).

\---

## 🗂 Data Model

Database **`gdb0041`** (provided by Codebasics for the AtliQ case study; not redistributed here): **3 dimension tables** and **8 fact tables**.

<p align="center">
  <a href="images/27\_db\_tables.png"><img src="images/27\_db\_tables.png" width="300" alt="Database tables"></a>
</p>

### How the analytics layer is built

```mermaid
flowchart LR
    A\[fact\_sales\_monthly] --> V1
    B\[dim\_product / dim\_customer] --> V1
    C\[fact\_gross\_price] --> V1
    D\[fact\_pre\_invoice\_deductions] --> V1
    V1(\["sales\_pre\_inv\_discount"]) --> V2
    E\[fact\_post\_invoice\_deductions] --> V2
    V2(\["sales\_pos\_inv\_discount"]) --> V3
    V3(\["net\_sales"]) --> R\["Requests R4 to R8"]
    F\[fact\_act\_est] --> R9\["Forecast accuracy R9"]
```

```
Gross Sales        = gross\_price × sold\_quantity
Net Invoice Sales  = Gross Sales × (1 − pre\_invoice\_discount\_pct)
Net Sales          = Net Invoice Sales × (1 − post\_invoice\_discounts\_pct)
```

\---

## 🛠 SQL Skills Demonstrated

|Area|What was used|
|-|-|
|**Joins and aggregation**|Multi-table joins, `SUM`, `ROUND`, `GROUP BY`|
|**CTEs**|Layered, readable logic replacing temp tables|
|**Window functions**|`DENSE\_RANK() OVER (PARTITION BY ...)`, `SUM() OVER ()`|
|**Views**|Three-layer view stack for net sales|
|**Stored procedures**|Parameterised reports (`IN` params, `FIND\_IN\_SET`)|
|**User-defined functions**|`get\_fiscal\_year()`, `get\_fiscal\_quarter()`|
|**Performance tuning**|Generated column instead of per-row function calls|
|**Data quality**|`NULLIF` guards against divide-by-zero|
|**Visualisation**|Excel bar chart of customer contribution|

\---

## 🖼 Project Gallery

*Click any image to open it full size.*

<table>
  <tr>
    <td align="center" width="50%"><b>Top 5 markets, FY2021</b><br><br><a href="images/17\_top5\_markets\_fy2021.jpeg"><img src="images/17\_top5\_markets\_fy2021.jpeg" width="400" alt="Top 5 markets, FY2021"></a></td>
    <td align="center" width="50%"><b>Top 5 customers, FY2021</b><br><br><a href="images/18\_top5\_customers\_fy2021.jpeg"><img src="images/18\_top5\_customers\_fy2021.jpeg" width="400" alt="Top 5 customers, FY2021"></a></td>
  </tr>
  <tr>
    <td align="center" width="50%"><b>Top 2 markets per region</b><br><br><a href="images/21\_top2\_markets\_per\_region.jpeg"><img src="images/21\_top2\_markets\_per\_region.jpeg" width="400" alt="Top 2 markets per region"></a></td>
    <td align="center" width="50%"><b>Top 5 products (stored procedure)</b><br><br><a href="images/24\_top\_n\_products\_result.jpeg"><img src="images/24\_top\_n\_products\_result.jpeg" width="400" alt="Top 5 products (stored procedure)"></a></td>
  </tr>
  <tr>
    <td align="center" width="50%"><b>Customer contribution (Excel)</b><br><br><a href="images/20\_customer\_share\_excel\_chart.jpeg"><img src="images/20\_customer\_share\_excel\_chart.jpeg" width="400" alt="Customer contribution (Excel)"></a></td>
    <td align="center" width="50%"><b>Forecast accuracy report</b><br><br><a href="images/26\_forecast\_accuracy\_result.jpeg"><img src="images/26\_forecast\_accuracy\_result.jpeg" width="400" alt="Forecast accuracy report"></a></td>
  </tr>
</table>

\---

## 📁 Repository Structure

```
AtliQ-Consumer-Goods-SQL-Analysis/
├── README.md
├── .gitignore
├── docs/
│   └── query\_walkthrough.md        # Journey: question, SQL, screenshot, answer for every request
├── sql/
│   ├── setup/                      # Run first, in order
│   │   ├── 01\_functions.sql
│   │   ├── 02\_generated\_column.sql
│   │   ├── 03\_views.sql
│   │   └── 04\_stored\_procedures.sql
│   └── requests/                   # One file per request (R01 to R09)
└── images/                         # 31 screenshots, numbered in project order
```

\---

## ▶️ How to Run

1. Import the **`gdb0041`** dataset from Codebasics into **MySQL 8.0+** (CTEs and window functions need 8.0).
2. Run the setup scripts **in order**:

```sql
   SOURCE sql/setup/01\_functions.sql;
   SOURCE sql/setup/02\_generated\_column.sql;
   SOURCE sql/setup/03\_views.sql;
   SOURCE sql/setup/04\_stored\_procedures.sql;
   ```

3. Run any file in `sql/requests/`, or follow the [walkthrough](docs/query_walkthrough.md).

\---

## 👤 About the Author

**Muhammad Raheel Yousaf** · Aspiring Data Analyst · SQL · Excel · Power BI

[!\[LinkedIn](https://www.linkedin.com/in/muhammad-raheel-yousaf-da/)](https://www.linkedin.com/in/YOUR-LINKEDIN/)

🎓 Acknowledgement

Completed as part of the **Codebasics Data Analytics Bootcamp** (SQL, Consumer Goods domain). Dataset and business case by Codebasics.

<p align="center">⭐ If this project helped you, consider giving it a star!</p>

