-- Run after loading the raw tables
SELECT 'sales_raw' table_name,COUNT(*) rows FROM public.sales_raw
UNION ALL SELECT 'hr_raw',COUNT(*) FROM public.hr_raw
UNION ALL SELECT 'iot_raw',COUNT(*) FROM public.iot_raw;

SELECT order_id,COUNT(*) occurrences FROM public.sales_raw GROUP BY order_id HAVING COUNT(*)>1 ORDER BY occurrences DESC;
SELECT employee_id,COUNT(*) occurrences FROM public.hr_raw GROUP BY employee_id HAVING COUNT(*)>1 ORDER BY occurrences DESC;

SELECT region,COUNT(*) FROM public.sales_raw GROUP BY region ORDER BY region;
SELECT department,COUNT(*) FROM public.hr_raw GROUP BY department ORDER BY department;
SELECT status,COUNT(*) FROM public.iot_raw GROUP BY status ORDER BY status;
