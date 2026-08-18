-- ============================================================
-- POWER BI DATA PROFILING LAB
-- SALES RAW DATASET
-- 100+ rows with intentional data-quality anomalies
--
-- Purpose:
--   Data Profiling
--   Data Cleaning
--   Data Transformation
--   Query Folding
--   Power BI / Power Query
--
-- IMPORTANT:
-- All columns are TEXT intentionally.
-- This allows students to discover and correct data problems
-- in Power Query instead of PostgreSQL rejecting bad records.
-- ============================================================


DROP TABLE IF EXISTS sales_raw;

CREATE TABLE sales_raw (
    order_id        TEXT,
    order_date      TEXT,
    customer_id     TEXT,
    product         TEXT,
    category        TEXT,
    region          TEXT,
    quantity        TEXT,
    unit_price      TEXT,
    sales_amount    TEXT,
    channel         TEXT,
    salesperson     TEXT,
    customer_type   TEXT
);


INSERT INTO sales_raw (
    order_id,
    order_date,
    customer_id,
    product,
    category,
    region,
    quantity,
    unit_price,
    sales_amount,
    channel,
    salesperson,
    customer_type
)
VALUES

-- ============================================================
-- NORMAL RECORDS
-- ============================================================

('ORD0001','2026-01-01','CUST001','Laptop','Electronics','South','2','65000','130000','Retail','Arun','Corporate'),
('ORD0002','2026-01-02','CUST002','Monitor','Electronics','North','3','18000','54000','Partner','Priya','Individual'),
('ORD0003','2026-01-03','CUST003','Keyboard','Accessories','East','4','2200','8800','Online','Rahul','Individual'),
('ORD0004','2026-01-04','CUST004','Mouse','Accessories','West','5','900','4500','Retail','Meena','Corporate'),
('ORD0005','2026-01-05','CUST005','Printer','Electronics','South','6','12500','75000','Partner','Arun','Corporate'),

('ORD0006','2026-01-06','CUST006','Laptop','Electronics','North','1','65000','65000','Online','Priya','Individual'),
('ORD0007','2026-01-07','CUST007','Monitor','Electronics','East','2','18000','36000','Retail','Rahul','Individual'),
('ORD0008','2026-01-08','CUST008','Keyboard','Accessories','West','3','2200','6600','Partner','Meena','Corporate'),
('ORD0009','2026-01-09','CUST009','Mouse','Accessories','South','4','900','3600','Online','Arun','Individual'),
('ORD0010','2026-01-10','CUST010','Printer','Electronics','North','2','12500','25000','Retail','Priya','Corporate'),

('ORD0011','2026-01-11','CUST011','Laptop','Electronics','East','3','65000','195000','Online','Rahul','Corporate'),
('ORD0012','2026-01-12','CUST012','Monitor','Electronics','West','4','18000','72000','Partner','Meena','Individual'),
('ORD0013','2026-01-13','CUST013','Keyboard','Accessories','South','5','2200','11000','Retail','Arun','Individual'),
('ORD0014','2026-01-14','CUST014','Mouse','Accessories','North','6','900','5400','Online','Priya','Corporate'),
('ORD0015','2026-01-15','CUST015','Printer','Electronics','East','1','12500','12500','Partner','Rahul','Individual'),

-- ============================================================
-- MISSING VALUES
-- ============================================================

('ORD0016','2026-01-16','CUST016',NULL,'Electronics','South','2','65000','130000','Retail','Arun','Corporate'),
('ORD0017','2026-01-17','CUST017','Monitor','Electronics',NULL,'3','18000','54000','Online','Priya','Individual'),
('ORD0018','2026-01-18',NULL,'Keyboard','Accessories','East','4','2200','8800','Partner','Rahul','Corporate'),
('ORD0019','2026-01-19','CUST019','Mouse','Accessories','West',NULL,'900','2700','Retail','Meena','Individual'),
('ORD0020','2026-01-20','CUST020','Printer','Electronics','South','4',NULL,'50000','Online','Arun','Corporate'),

('ORD0021','2026-01-21','CUST021','Laptop','Electronics','North','2','65000',NULL,'Partner','Priya','Individual'),
('ORD0022',NULL,'CUST022','Monitor','Electronics','East','3','18000','54000','Retail','Rahul','Corporate'),
('ORD0023','2026-01-23','CUST023','Keyboard','Accessories','West','5','2200','11000',NULL,'Meena','Individual'),
('ORD0024','2026-01-24','CUST024','Mouse','Accessories','South','3','900','2700','Online',NULL,'Corporate'),
('ORD0025','2026-01-25','CUST025','Printer','Electronics','North','2','12500','25000','Retail','Priya',NULL),

-- ============================================================
-- TEXT / NUMERIC TYPE ANOMALIES
-- ============================================================

('ORD0026','2026-01-26','CUST026','Laptop','Electronics','East','two','65000','130000','Online','Rahul','Corporate'),
('ORD0027','2026-01-27','CUST027','Monitor','Electronics','West','3','18000 INR','54000','Retail','Meena','Individual'),
('ORD0028','2026-01-28','CUST028','Keyboard','Accessories','South','4','2200','8,800','Partner','Arun','Corporate'),
('ORD0029','2026-01-29','CUST029','Mouse','Accessories','North','five','900','4500','Online','Priya','Individual'),
('ORD0030','2026-01-30','CUST030','Printer','Electronics','East','2','₹12500','25000','Retail','Rahul','Corporate'),

('ORD0031','2026-01-31','CUST031','Laptop','Electronics','West','3','65000','195000','Online','Meena','Individual'),
('ORD0032','2026-02-01','CUST032','Monitor','Electronics','South','4','18000','72000','Partner','Arun','Corporate'),
('ORD0033','2026-02-02','CUST033','Keyboard','Accessories','North','3','2200','6600','Retail','Priya','Individual'),
('ORD0034','2026-02-03','CUST034','Mouse','Accessories','East','6','900','5400','Online','Rahul','Corporate'),
('ORD0035','2026-02-04','CUST035','Printer','Electronics','West','2','12500','25000','Partner','Meena','Individual'),

-- ============================================================
-- INVALID DATE FORMATS
-- ============================================================

('ORD0036','04-02-2026','CUST036','Laptop','Electronics','South','2','65000','130000','Retail','Arun','Corporate'),
('ORD0037','2026/02/05','CUST037','Monitor','Electronics','North','3','18000','54000','Online','Priya','Individual'),
('ORD0038','Feb-06-2026','CUST038','Keyboard','Accessories','East','4','2200','8800','Partner','Rahul','Corporate'),
('ORD0039','06-02-26','CUST039','Mouse','Accessories','West','5','900','4500','Retail','Meena','Individual'),
('ORD0040','not-a-date','CUST040','Printer','Electronics','South','2','12500','25000','Online','Arun','Corporate'),

-- ============================================================
-- INCONSISTENT CATEGORIES
-- ============================================================

('ORD0041','2026-02-08','CUST041','Laptop','electronics','South','2','65000','130000','online','Arun','Corporate'),
('ORD0042','2026-02-09','CUST042','Monitor','Electronics','south','3','18000','54000','Online','Priya','Individual'),
('ORD0043','2026-02-10','CUST043','Keyboard','ACCESSORIES','EAST','4','2200','8800','RETAIL','Rahul','Corporate'),
('ORD0044','2026-02-11','CUST044','Mouse','Accessories',' West ','5','900','4500','partner','Meena','Individual'),
('ORD0045','2026-02-12','CUST045','Printer','Electronics','NORTH','2','12500','25000','Retail','Arun','Corporate'),

-- ============================================================
-- LEADING / TRAILING SPACES
-- ============================================================

('ORD0046','2026-02-13',' CUST046 ','Laptop','Electronics','South','2','65000','130000','Retail','Arun','Corporate'),
('ORD0047','2026-02-14','CUST047',' Monitor ','Electronics','North','3','18000','54000','Online','Priya','Individual'),
('ORD0048','2026-02-15','CUST048','Keyboard',' Accessories ','East','4','2200','8800','Partner','Rahul','Corporate'),
('ORD0049','2026-02-16','CUST049','Mouse','Accessories','West','5','900','4500',' Retail ','Meena','Individual'),
('ORD0050','2026-02-17','CUST050','Printer','Electronics','South','2','12500','25000','Online',' Arun ','Corporate'),

-- ============================================================
-- NEGATIVE / ZERO / IMPOSSIBLE VALUES
-- ============================================================

('ORD0051','2026-02-18','CUST051','Laptop','Electronics','North','-2','65000','-130000','Retail','Priya','Individual'),
('ORD0052','2026-02-19','CUST052','Monitor','Electronics','East','0','18000','0','Online','Rahul','Corporate'),
('ORD0053','2026-02-20','CUST053','Keyboard','Accessories','West','4','-2200','-8800','Partner','Meena','Individual'),
('ORD0054','2026-02-21','CUST054','Mouse','Accessories','South','5','900','-4500','Retail','Arun','Corporate'),
('ORD0055','2026-02-22','CUST055','Printer','Electronics','North','999','12500','12375000','Online','Priya','Individual'),

-- ============================================================
-- SALES AMOUNT CALCULATION ERRORS
-- ============================================================

('ORD0056','2026-02-23','CUST056','Laptop','Electronics','East','2','65000','100000','Retail','Rahul','Corporate'),
('ORD0057','2026-02-24','CUST057','Monitor','Electronics','West','3','18000','60000','Online','Meena','Individual'),
('ORD0058','2026-02-25','CUST058','Keyboard','Accessories','South','4','2200','9999','Partner','Arun','Corporate'),
('ORD0059','2026-02-26','CUST059','Mouse','Accessories','North','5','900','1000','Retail','Priya','Individual'),
('ORD0060','2026-02-27','CUST060','Printer','Electronics','East','2','12500','125000','Online','Rahul','Corporate'),

-- ============================================================
-- DUPLICATE ORDER IDS
-- ============================================================

('ORD0061','2026-02-28','CUST061','Laptop','Electronics','West','2','65000','130000','Retail','Meena','Corporate'),
('ORD0061','2026-02-28','CUST061','Laptop','Electronics','West','2','65000','130000','Retail','Meena','Corporate'),

('ORD0062','2026-03-01','CUST062','Monitor','Electronics','South','3','18000','54000','Online','Arun','Individual'),
('ORD0062','2026-03-01','CUST062','Monitor','Electronics','South','3','18000','54000','Online','Arun','Individual'),

-- ============================================================
-- DUPLICATE ROWS WITH SLIGHT DIFFERENCES
-- ============================================================

('ORD0063','2026-03-02','CUST063','Keyboard','Accessories','North','4','2200','8800','Retail','Priya','Corporate'),
('ORD0063','2026-03-02','CUST063','Keyboard','Accessories','North','4','2200','8800','Retail','Priya','Corporate'),

('ORD0064','2026-03-03','CUST064','Mouse','Accessories','East','5','900','4500','Partner','Rahul','Individual'),
('ORD0064','2026-03-03','CUST064','Mouse','Accessories','East','5','900','4500','Partner','Rahul','Individual'),

-- ============================================================
-- INVALID / UNKNOWN CATEGORIES
-- ============================================================

('ORD0065','2026-03-04','CUST065','Tablet','Electronics','South','2','30000','60000','Retail','Arun','Corporate'),
('ORD0066','2026-03-05','CUST066','Laptop','Electronic','North','2','65000','130000','Online','Priya','Individual'),
('ORD0067','2026-03-06','CUST067','Monitor','Electronics','Central','3','18000','54000','Online','Rahul','Corporate'),
('ORD0068','2026-03-07','CUST068','Keyboard','Accessories','Unknown','4','2200','8800','Retail','Meena','Individual'),
('ORD0069','2026-03-08','CUST069','Mouse','Accessories','South','5','900','4500','WhatsApp','Arun','Corporate'),

-- ============================================================
-- NULL-LIKE TEXT VALUES
-- ============================================================

('ORD0070','2026-03-09','CUST070','Printer','Electronics','North','2','12500','25000','Retail','Priya','Individual'),
('ORD0071','2026-03-10','CUST071','Laptop','Electronics','East','NULL','65000','130000','Online','Rahul','Corporate'),
('ORD0072','2026-03-11','CUST072','Monitor','Electronics','West','3','NULL','54000','Partner','Meena','Individual'),
('ORD0073','2026-03-12','CUST073','Keyboard','Accessories','South','4','2200','NULL','Retail','Arun','Corporate'),
('ORD0074','2026-03-13','CUST074','Mouse','Accessories','North','5','900','4500','N/A','Priya','Individual'),

-- ============================================================
-- EXTREME VALUES / OUTLIERS
-- ============================================================

('ORD0075','2026-03-14','CUST075','Laptop','Electronics','East','1000','65000','65000000','Online','Rahul','Corporate'),
('ORD0076','2026-03-15','CUST076','Monitor','Electronics','West','3','999999','2999997','Retail','Meena','Individual'),
('ORD0077','2026-03-16','CUST077','Keyboard','Accessories','South','4','1','4','Partner','Arun','Corporate'),
('ORD0078','2026-03-17','CUST078','Mouse','Accessories','North','9999','900','8999100','Online','Priya','Individual'),
('ORD0079','2026-03-18','CUST079','Printer','Electronics','East','2','0','0','Retail','Rahul','Corporate'),

-- ============================================================
-- EMAIL / CUSTOMER ID FORMAT ANOMALIES
-- ============================================================

('ORD0080','2026-03-19','CUSTOMER80','Laptop','Electronics','West','2','65000','130000','Online','Meena','Individual'),
('ORD0081','2026-03-20','cust081','Monitor','Electronics','South','3','18000','54000','Retail','Arun','Corporate'),
('ORD0082','2026-03-21','','Keyboard','Accessories','North','4','2200','8800','Partner','Priya','Individual'),
('ORD0083','2026-03-22','CUST-083','Mouse','Accessories','East','5','900','4500','Online','Rahul','Corporate'),
('ORD0084','2026-03-23','CUST084','Printer','Electronics','West','2','12500','25000','Retail','Meena','Individual'),

-- ============================================================
-- MORE NORMAL DATA
-- ============================================================

('ORD0085','2026-03-24','CUST085','Laptop','Electronics','South','2','65000','130000','Online','Arun','Corporate'),
('ORD0086','2026-03-25','CUST086','Monitor','Electronics','North','3','18000','54000','Retail','Priya','Individual'),
('ORD0087','2026-03-26','CUST087','Keyboard','Accessories','East','4','2200','8800','Partner','Rahul','Corporate'),
('ORD0088','2026-03-27','CUST088','Mouse','Accessories','West','5','900','4500','Online','Meena','Individual'),
('ORD0089','2026-03-28','CUST089','Printer','Electronics','South','2','12500','25000','Retail','Arun','Corporate'),
('ORD0090','2026-03-29','CUST090','Laptop','Electronics','North','1','65000','65000','Online','Priya','Individual'),

('ORD0091','2026-03-30','CUST091','Monitor','Electronics','East','2','18000','36000','Partner','Rahul','Corporate'),
('ORD0092','2026-03-31','CUST092','Keyboard','Accessories','West','3','2200','6600','Retail','Meena','Individual'),
('ORD0093','2026-04-01','CUST093','Mouse','Accessories','South','4','900','3600','Online','Arun','Corporate'),
('ORD0094','2026-04-02','CUST094','Printer','Electronics','North','2','12500','25000','Partner','Priya','Individual'),
('ORD0095','2026-04-03','CUST095','Laptop','Electronics','East','3','65000','195000','Retail','Rahul','Corporate'),

('ORD0096','2026-04-04','CUST096','Monitor','Electronics','West','4','18000','72000','Online','Meena','Individual'),
('ORD0097','2026-04-05','CUST097','Keyboard','Accessories','South','5','2200','11000','Partner','Arun','Corporate'),
('ORD0098','2026-04-06','CUST098','Mouse','Accessories','North','6','900','5400','Retail','Priya','Individual'),
('ORD0099','2026-04-07','CUST099','Printer','Electronics','East','1','12500','12500','Online','Rahul','Corporate'),
('ORD0100','2026-04-08','CUST100','Laptop','Electronics','West','2','65000','130000','Retail','Meena','Individual'),

-- ============================================================
-- FINAL ANOMALOUS RECORDS
-- ============================================================

('ORD0101','2026-04-09','CUST101','Laptop','Electronics','South','-5','65000','-325000','Online','Arun','Corporate'),
('ORD0102','2026-04-10','CUST102','Monitor','Electronics','North','3.5','18000','63000','Retail','Priya','Individual'),
('ORD0103','2026-04-11','CUST103','Keyboard','Accessories','East','4','2,200.50','8802','Partner','Rahul','Corporate'),
('ORD0104','2026-04-12','CUST104','Mouse','Accessories','West','five','900','4500','Online','Meena','Individual'),
('ORD0105','2026-04-13','CUST105','Printer','Electronics','South','2','12.5K','25000','Retail','Arun','Corporate');
