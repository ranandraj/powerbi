# Power BI Performance Tuning Lab
## Sales CSV: Model Size Reduction and Aggregations

This lab teaches performance tuning directly with `Sales.csv`.

## 1. Introduction

Power BI performance can be affected by the amount of data loaded into the model, the number of columns, data types, cardinality, model design, calculations, and the way summary queries are handled.

This lab focuses on two practical techniques:

1. **Model size reduction**
2. **Aggregations**

The learning flow is:

```text
Sales.csv
   ↓
Inspect
   ↓
Reduce unnecessary data
   ↓
Correct data types
   ↓
Understand cardinality
   ↓
Create aggregation
   ↓
Compare detail and summary
   ↓
Test performance
```

The supplied CSV has 1,000 rows. This is large enough for classroom practice, but small enough to work comfortably on a normal computer. Do not expect a dramatic speed improvement from such a small file. The purpose is to learn techniques that become important when the same model grows to hundreds of thousands or millions of rows.

---

# 2. Dataset Introduction

`Sales.csv` contains 1,000 sales transactions.

Columns:

| Column | Purpose |
|---|---|
| OrderID | Unique order identifier |
| OrderDate | Transaction date |
| CustomerID | Customer identifier |
| ProductID | Product identifier |
| Product | Product name |
| Category | Product category |
| Region | Sales region |
| Channel | Sales channel |
| Quantity | Units sold |
| UnitPrice | Unit price |
| Discount | Discount percentage |
| SalesAmount | Final sales amount |
| TransactionNotes | Deliberately verbose high-cardinality text for the optimization exercise |

`TransactionNotes` is included so students can practice identifying a column that is not required for summary reporting.

---

# 3. Topic: Model Size Reduction

## Introduction

Model size reduction means reducing unnecessary information that Power BI must store and process.

Common techniques include:

- Removing unused columns.
- Removing rows outside the reporting requirement.
- Choosing suitable data types.
- Avoiding unnecessary high-cardinality fields.
- Avoiding repeated descriptive data in fact tables.
- Keeping only useful calculations.

The goal is not to delete useful information. The goal is to keep the model focused on the business questions it must answer.

---

## Step 1: Import Sales.csv

Open Power BI Desktop.

Select:

**Home → Get Data → Text/CSV**

Choose:

`Sales.csv`

Select:

**Transform Data**

Power Query opens.

---

## Step 2: Inspect the columns

You should see:

```text
OrderID
OrderDate
CustomerID
ProductID
Product
Category
Region
Channel
Quantity
UnitPrice
Discount
SalesAmount
TransactionNotes
```

Before removing anything, ask:

> Does the report actually need this column?

---

## Step 3: Remove TransactionNotes

Select:

`TransactionNotes`

Then:

**Home → Remove Columns**

The remaining table contains the fields needed for normal Sales analysis.

Do not automatically remove `OrderID`. It may be needed for transaction detail, drill-through, or auditing.

---

# 4. Topic: Data Types

## Introduction

A data type tells Power BI how a value should be stored and interpreted.

Use the simplest correct type.

Recommended types:

| Column | Type |
|---|---|
| OrderID | Text |
| OrderDate | Date |
| CustomerID | Text |
| ProductID | Text |
| Product | Text |
| Category | Text |
| Region | Text |
| Channel | Text |
| Quantity | Whole Number |
| UnitPrice | Decimal Number |
| Discount | Decimal Number |
| SalesAmount | Decimal Number |

---

## Step 4: Set OrderDate

Select:

`OrderDate`

Choose:

**Transform → Data Type → Date**

---

## Step 5: Set Quantity

Select:

`Quantity`

Choose:

**Transform → Data Type → Whole Number**

Quantity represents whole units.

---

## Step 6: Set numeric columns

Set:

```text
UnitPrice → Decimal Number
Discount → Decimal Number
SalesAmount → Decimal Number
```

Keep:

```text
Region
Channel
Category
Product
```

as Text.

---

# 5. Topic: Cardinality

## Introduction

Cardinality means the number of distinct values in a column.

Using the Sales data:

```text
Region
```

has only:

```text
North
South
East
West
```

So it has low cardinality.

`Channel` also has low cardinality.

`OrderID` is different. Nearly every row has a different value, so it has high cardinality.

`TransactionNotes` is intentionally unique for every row, making it high cardinality.

---

## Step 7: Classify columns

Use this table:

| Column | Cardinality |
|---|---|
| Region | Low |
| Channel | Low |
| Category | Low |
| ProductID | Low/Medium |
| CustomerID | Medium |
| OrderID | High |
| TransactionNotes | High |

Important:

**High cardinality does not automatically mean a column should be deleted.**

Ask whether the column is needed.

For example:

`OrderID` may be essential.

`TransactionNotes` is not required for this summary dashboard, so it is a suitable optimization candidate.

---

# 6. Topic: Reducing Rows

## Introduction

If the business only needs a specific reporting period, do not load unrelated historical rows.

For example, if management requests sales from 2026 onward, filter the source accordingly.

---

## Step 8: Filter OrderDate

Select:

`OrderDate`

Choose:

**Date Filters → After**

Set an appropriate business date, for example:

`01-Jan-2026`

The flow becomes:

```text
All Sales
   ↓
Date Filter
   ↓
Required Reporting Period
```

Only apply such a filter when the business requirement allows it.

---

# 7. Topic: Star Schema and Repeated Data

## Introduction

Large fact tables can contain repeated descriptive information.

For example, customer information does not need to be repeated in every transaction.

A better design is:

```text
DimCustomer
     |
     | 1
     |
     | *
  FactSales
     *
     |
     | 1
     |
DimProduct
```

The fact table keeps identifiers such as:

```text
CustomerID
ProductID
```

while descriptive information is kept in dimension tables.

This reduces duplication and makes the model easier to manage.

---

# 8. Topic: Aggregations

## Introduction

An aggregation is a summarized version of detailed data.

Imagine:

```text
10,000,000 Sales transactions
```

but the dashboard usually asks:

```text
Monthly Sales
by Region
by Category
by Channel
```

A summary table can store these combinations instead of repeatedly scanning all transaction rows for every summary request.

Example:

### Detailed data

```text
OrderDate
Region
Category
Channel
SalesAmount
```

### Aggregated data

```text
Year
Month
Region
Category
Channel
Total Sales
Total Quantity
```

---

# 9. Step-by-Step: Create Sales_Monthly_Agg

In Power Query:

Right-click:

`Sales`

Select:

**Reference**

Rename:

`Sales_Monthly_Agg`

Use **Reference** so the aggregation is based on the cleaned Sales query.

---

## Step 10: Keep required columns

Keep:

```text
OrderDate
Category
Region
Channel
Quantity
SalesAmount
```

Remove columns that are not required for this aggregation.

---

## Step 11: Create Year

Select:

`OrderDate`

Choose:

**Add Column → Date → Year → Year**

---

## Step 12: Create Month

Select:

`OrderDate`

Choose:

**Add Column → Date → Month → Month**

You now have:

```text
Year
Month
Region
Category
Channel
Quantity
SalesAmount
```

---

# 10. Step-by-Step: Group the Sales Data

Select:

**Home → Group By**

Choose:

**Advanced**

Group by:

```text
Year
Month
Region
Category
Channel
```

Create:

### Total Sales

```text
New column name: Total Sales
Operation: Sum
Column: SalesAmount
```

Add another aggregation:

### Total Quantity

```text
New column name: Total Quantity
Operation: Sum
Column: Quantity
```

Click:

**OK**

---

# 11. Result

The aggregation should contain:

```text
Year
Month
Region
Category
Channel
Total Sales
Total Quantity
```

Conceptually:

```text
Detailed Sales
      ↓
Group By
      ↓
Year + Month + Region + Category + Channel
      ↓
Total Sales + Total Quantity
```

---

# 12. Compare Detailed vs Aggregated Data

Record the row counts.

```text
Detailed Sales rows: __________

Aggregation rows: __________

Rows reduced: __________
```

The aggregation should normally contain fewer rows because many transactions are combined into summary groups.

---

# 13. Topic: Why Aggregations Help

Suppose a production Sales table contains:

```text
10 million transactions
```

and the summary table contains:

```text
20,000 groups
```

A summary-level analysis can work with far fewer rows when the query can be answered from the aggregated information.

The detailed table remains available for transaction-level analysis.

Architecture:

```text
                    Sales Model
                        |
            ┌───────────┴───────────┐
            ↓                       ↓
   Sales_Monthly_Agg             Sales
            ↓                       ↓
    Summary reporting        Transaction detail
            ↓                       ↓
       Dashboard              Drill-through
```

---

# 14. Important Classroom Point

This training dataset has only 1,000 rows.

Therefore:

```text
1,000 rows
→ Usually little visible performance difference
```

But:

```text
1 million rows
→ Performance becomes more relevant

10 million rows
→ Model design becomes much more important
```

Students should learn the technique rather than expect a dramatic speed increase from the classroom CSV.

---

# 15. Topic: Performance Analyzer

## Introduction

Performance should be measured rather than guessed.

Power BI Desktop provides **Performance Analyzer** to investigate visual rendering and query times.

---

## Step 13: Open Performance Analyzer

Go to:

**View → Performance Analyzer**

Select:

**Start recording**

Interact with the report.

For example:

- Select South.
- Select Online.
- Change Category.
- Change Year.

Observe the timings.

Select:

**Stop**

---

# 16. Create the Test Report

Create a page called:

**Sales Performance Test**

Add:

### Card

`Total Sales`

### Chart

Monthly Sales

### Chart

Sales by Region

### Chart

Sales by Category

### Chart

Sales by Channel

### Slicers

```text
Year
Region
Category
Channel
```

Use Performance Analyzer while interacting with these visuals.

---

# 17. Performance Experiment

Record:

| Visual | Time |
|---|---:|
| Monthly Sales | ____ |
| Sales by Region | ____ |
| Sales by Category | ____ |
| Sales by Channel | ____ |

Remember that these timings are mainly for learning with this small dataset.

---

# 18. Hands-On Challenge

## Scenario

Your company currently has:

```text
1,000 Sales rows
```

but expects:

```text
10 million rows
```

Management normally analyzes:

- Monthly Sales
- Region
- Category
- Channel

Sales managers sometimes need:

- OrderID
- CustomerID
- Product
- Transaction-level Sales

## Task

Design a solution.

### Step 1

Identify fields needed for transaction detail.

### Step 2

Identify fields unnecessary for summary reporting.

### Step 3

Remove `TransactionNotes`.

### Step 4

Correct the data types.

### Step 5

Identify high-cardinality fields.

### Step 6

Create `Sales_Monthly_Agg`.

### Step 7

Group by:

```text
Year
Month
Region
Category
Channel
```

### Step 8

Calculate:

```text
Total Sales
Total Quantity
```

### Step 9

Build summary visuals.

### Step 10

Use Performance Analyzer.

---

# 19. Final Dashboard

Create:

**Sales Performance - Optimized Model**

## KPI Cards

- Total Sales
- Total Quantity

## Charts

- Monthly Sales
- Sales by Region
- Sales by Category
- Sales by Channel

## Slicers

- Year
- Region
- Category
- Channel

---

# 20. Validation Checklist

```text
☐ Sales.csv imported
☐ OrderDate is Date
☐ Quantity is Whole Number
☐ SalesAmount is Decimal Number
☐ TransactionNotes removed
☐ Cardinality identified
☐ Row filtering understood
☐ Sales_Monthly_Agg created
☐ Year created
☐ Month created
☐ Group By completed
☐ Total Sales calculated
☐ Total Quantity calculated
☐ Row counts compared
☐ Dashboard created
☐ Performance Analyzer tested
```

---

# 21. Final Practical Flow

```text
Sales.csv
   ↓
Power Query
   ↓
Inspect columns
   ↓
Remove unnecessary columns
   ↓
Correct data types
   ↓
Check cardinality
   ↓
Filter unnecessary rows when appropriate
   ↓
Clean Sales table
   ↓
Create Sales_Monthly_Agg
   ↓
Group By
   ↓
Calculate Total Sales / Total Quantity
   ↓
Build dashboard
   ↓
Performance Analyzer
```

---

# 22. Key Takeaways

### Model Size Reduction

Remove data that the report genuinely does not need.

### Data Types

Use the simplest correct type for each column.

### Cardinality

Investigate columns with many distinct values. Do not remove them automatically.

### Star Schema

Keep transaction measures in fact tables and descriptive information in dimensions.

### Aggregations

Summarize large detailed datasets when the report repeatedly needs summary-level analysis.

### Performance Analyzer

Measure actual report behavior instead of assuming an optimization worked.

---

# Student Deliverable

Submit:

1. Original Sales query screenshot.
2. Data type screenshot.
3. Screenshot showing `TransactionNotes` removed.
4. Cardinality classification.
5. `Sales_Monthly_Agg` screenshot.
6. Before/after row counts.
7. Final dashboard screenshot.
8. Performance Analyzer screenshot.
9. Short explanation of when aggregations become useful.

