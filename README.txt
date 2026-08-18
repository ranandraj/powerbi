Power BI Profiling and Transformation Lab - 10,000 rows each.
Sales: CSV + Excel + Neon raw SQL
HR: CSV + Neon raw SQL
IoT: CSV + Neon raw SQL + Python profiler

Neon run order:
01_sales_raw.sql
02_hr_raw.sql
03_iot_raw.sql
04_profile_queries.sql


ADDITIONAL SOURCES
------------------
JSON:
sales_10000.json
hr_10000.json
iot_10000.json

XML:
sales_10000.xml
hr_10000.xml
iot_10000.xml

These preserve the same 10,000 rows and intentional data-quality issues.
