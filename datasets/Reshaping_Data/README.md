# Power BI Day 2 - Sales Reshaping & Power Query Complete Lab

## Purpose

This package is designed for the Day 2 Power BI workshop section on:

1. Split Columns
2. Group By and aggregation
3. Pivot Columns
4. Unpivot Columns
5. Merge Queries
6. Append Queries
7. Validation after transformations

The datasets are intentionally simple and clean so that learners can focus on understanding the Power Query operations and the change in data shape.

---

# 1. Files in this package

| File | Purpose |
|---|---|
| `01_sales_main.csv` | Main transaction table. Used for Split Column and Group By |
| `02_sales_for_pivot.csv` | Normalized sales table for Pivot Column |
| `03_sales_wide_for_unpivot.csv` | Wide-format table for Unpivot Columns |
| `04_customer_master_for_merge.csv` | Customer lookup/master table for Merge |
| `05_product_master_for_merge.csv` | Product lookup/master table for Merge |
| `06_sales_february_for_append.csv` | Second sales table for Append |
| `07_sales_february_reordered_columns.csv` | Additional Append practice showing column-order differences |
| `08_reference_regional_groupby_result.csv` | Expected regional Group By result for checking |
| `09_reference_product_groupby_result.csv` | Expected product Group By result for checking |

---

# 2. Recommended Power BI setup

## Step 1: Create a new Power BI file

Open Power BI Desktop.

Choose:

**Home > Get Data > Text/CSV**

Import each CSV file.

For every file, select:

**Transform Data**

Do not immediately click Load.

The Power Query Editor is the working area for this lab.

---

# 3. Understand the main Sales dataset

File:

`01_sales_main.csv`

Important columns:

| Column | Meaning |
|---|---|
| OrderID | Unique sales order |
| OrderDate | Date of order |
| CustomerID | Customer key |
| Product | Product sold |
| Category | Product category |
| Region | Sales region |
| Channel | Sales channel |
| Salesperson | Person responsible for sale |
| Quantity | Number of units |
| UnitPrice | Price per unit |
| SalesAmount | Quantity x UnitPrice |
| CustomerRegion | Combined CustomerID and Region |

Example:

`CUST001 | South`

This combined column is deliberately included so learners can practice Split Column.

---

# 4. Exercise 1 - Split Column

## Objective

Split:

`CustomerRegion`

into separate fields.

Example:

`CUST001 | South`

should become:

`CUST001`

and

`South`

## Steps

1. Select query `01_sales_main`.
2. Select the `CustomerRegion` column.
3. Go to **Transform > Split Column > By Delimiter**.
4. Choose **Custom** delimiter.
5. Enter:

   `|`

6. Select **Split at Each occurrence of the delimiter**.
7. Click **OK**.
8. Rename the resulting columns:

   `CustomerID_FromText`

   `Region_FromText`

9. Select `Region_FromText`.
10. Go to **Transform > Format > Trim**.

## Why Trim?

The original text contains:

`CUST001 | South`

The second part may contain a leading space.

Trim converts:

`" South"`

to:

`"South"`

## Validation

Check that:

- Customer IDs look like `CUST001`
- Regions contain only `South`, `North`, `East`, or `West`
- No unexpected spaces remain

---

# 5. Exercise 2 - Group By

## Objective

Create a regional sales summary.

Source:

`01_sales_main.csv`

## Steps

1. Select `01_sales_main`.
2. Go to **Home > Group By**.
3. Select **Advanced**.
4. Group by:

   `Region`

5. Add aggregation:

   New column: `Total Sales`

   Operation: `Sum`

   Column: `SalesAmount`

6. Add aggregation:

   New column: `Total Quantity`

   Operation: `Sum`

   Column: `Quantity`

7. Add aggregation:

   New column: `Order Count`

   Operation: `Count Rows`

8. Click **OK**.

## Expected result

You should have one row per region:

`South`

`North`

`East`

`West`

The original 20 transaction rows become 4 summary rows.

## Concept

Group By changes the granularity of the data.

Transaction level:

`One row = one order`

Summary level:

`One row = one region`

## Validation

Compare your result with:

`08_reference_regional_groupby_result.csv`

---

# 6. Exercise 3 - Group By Product

Create a duplicate of the main query.

Right-click:

`01_sales_main`

Choose:

**Duplicate**

Rename it:

`Sales_GroupBy_Product`

Go to:

**Home > Group By > Advanced**

Group by:

`Product`

Create:

- Total Sales = Sum of SalesAmount
- Total Quantity = Sum of Quantity
- Order Count = Count Rows

## Expected products

- Laptop
- Monitor
- Keyboard
- Mouse
- Printer

Compare with:

`09_reference_product_groupby_result.csv`

---

# 7. Exercise 4 - Pivot Columns

File:

`02_sales_for_pivot.csv`

Columns:

- Region
- Month
- SalesAmount

Example:

| Region | Month | SalesAmount |
|---|---|---:|
| South | Jan | 130000 |
| North | Jan | 54000 |
| East | Jan | 8800 |

## Objective

Turn Month values into columns.

## Steps

1. Select `02_sales_for_pivot`.
2. Select `Month`.
3. Go to **Transform > Pivot Column**.
4. Set **Values Column** to:

   `SalesAmount`

5. Open **Advanced options**.
6. Set aggregation to:

   `Sum`

7. Click **OK**.

## Result

Instead of:

`Region | Month | SalesAmount`

you get:

`Region | Jan | Feb | Mar ...`

## Concept

Pivot converts distinct values from a column into separate columns.

---

# 8. Exercise 5 - Unpivot Columns

File:

`03_sales_wide_for_unpivot.csv`

This file contains:

- Jan_Sales
- Feb_Sales
- Mar_Sales
- Apr_Sales
- May_Sales

## Objective

Convert those columns into rows.

## Steps

1. Select `03_sales_wide_for_unpivot`.
2. Select:

   `Jan_Sales`

   `Feb_Sales`

   `Mar_Sales`

   `Apr_Sales`

   `May_Sales`

3. Go to **Transform > Unpivot Columns**.
4. Choose **Unpivot Columns**.
5. Rename `Attribute` to:

   `Month`

6. Rename `Value` to:

   `SalesAmount`

## Result

Wide:

`Jan_Sales | Feb_Sales | Mar_Sales`

becomes:

`Month | SalesAmount`

## Important concept

Unpivot is particularly useful when a source system stores periods as separate columns but analysis requires a row-based structure.

---

# 9. Exercise 6 - Merge Queries with Customer Master

Files:

`01_sales_main.csv`

and

`04_customer_master_for_merge.csv`

## Objective

Add customer information to every sales transaction.

Sales contains:

`CustomerID`

Customer master also contains:

`CustomerID`

Therefore `CustomerID` is the matching key.

## Steps

1. Select `01_sales_main`.
2. Go to:

   **Home > Merge Queries > Merge Queries as New**

3. Select:

   `04_customer_master_for_merge`

4. Select `CustomerID` in the first table.
5. Select `CustomerID` in the second table.
6. Set Join Kind:

   **Left Outer**

7. Click **OK**.

A new column containing the matching table will appear.

## Expand

Click the expand icon.

Select:

- CustomerType
- City
- State

Turn off:

**Use original column name as prefix**

Click **OK**.

## Result

The Sales table now contains customer attributes.

Example:

`CUST001`

can bring:

`Retail`

`Chennai`

`Tamil Nadu`

---

# 10. Why Left Outer Join?

A Left Outer Join means:

**Keep every row from the Sales table.**

If matching customer information exists, bring it into the result.

Conceptually:

Sales:

`20 rows`

Customer Master:

`20 rows`

Result:

`20 sales rows`

with additional customer columns.

The number of sales rows should normally remain unchanged.

---

# 11. Exercise 7 - Merge with Product Master

Files:

`01_sales_main.csv`

and:

`05_product_master_for_merge.csv`

## Matching key

Use:

`Product`

## Steps

1. Select the Sales query.
2. Go to:

   **Home > Merge Queries as New**

3. Select Product Master.
4. Select `Product` in both tables.
5. Choose:

   **Left Outer**

6. Click **OK**.
7. Expand:

   `ProductSegment`

## Result

You will get:

| Product | ProductSegment |
|---|---|
| Laptop | High Value |
| Monitor | Medium Value |
| Keyboard | Low Value |
| Mouse | Low Value |
| Printer | Medium Value |

---

# 12. Exercise 8 - Append Queries

Files:

`01_sales_main.csv`

and:

`06_sales_february_for_append.csv`

Both represent sales transactions and have the same logical structure.

## Objective

Combine the two datasets vertically.

## Steps

1. Go to:

   **Home > Append Queries > Append Queries as New**

2. Choose:

   **Two tables**

3. First table:

   `01_sales_main`

4. Second table:

   `06_sales_february_for_append`

5. Click **OK**.

Rename the new query:

`Sales_All_Months`

## Expected row count

Main Sales:

`20 rows`

February:

`20 rows`

Expected result:

`40 rows`

## Key concept

Append adds rows.

It does not add attributes to existing rows.

---

# 13. Exercise 9 - Append with reordered columns

Use:

`07_sales_february_reordered_columns.csv`

This exercise demonstrates an important Power Query concept.

Column order in the source files does not have to be identical for an Append operation to work correctly when the column names match.

Try appending:

`01_sales_main`

with:

`07_sales_february_reordered_columns`

Then inspect the result.

Check that values remain associated with their correct column names.

---

# 14. Merge vs Append

Students should remember this distinction.

## Merge

Used when you want to add information from another table.

Example:

Sales:

`CustomerID`

+

Customer Master:

`CustomerID, City, State`

Result:

`Sales + City + State`

Therefore:

**Merge generally adds columns.**

---

## Append

Used when you have similar datasets that need to be stacked.

Example:

January Sales

+

February Sales

Result:

All Sales

Therefore:

**Append generally adds rows.**

---

# 15. Pivot vs Unpivot

## Pivot

Input:

`Region | Month | Sales`

Output:

`Region | Jan | Feb | Mar`

Use Pivot when values should become columns.

## Unpivot

Input:

`Region | Jan | Feb | Mar`

Output:

`Region | Month | Sales`

Use Unpivot when repeated period/category columns should become rows.

---

# 16. Complete transformation challenge

Create a new query structure using the supplied datasets.

The target is an analysis-ready Sales dataset.

## Stage 1 - Start

Use:

`01_sales_main.csv`

## Stage 2 - Split

Split:

`CustomerRegion`

into:

`CustomerID_FromText`

and

`Region_FromText`

Trim the Region result.

## Stage 3 - Customer enrichment

Merge with:

`04_customer_master_for_merge.csv`

Key:

`CustomerID`

Join:

**Left Outer**

Expand:

- CustomerType
- City
- State

## Stage 4 - Product enrichment

Merge with:

`05_product_master_for_merge.csv`

Key:

`Product`

Expand:

`ProductSegment`

## Stage 5 - Append

Combine:

`01_sales_main`

and:

`06_sales_february_for_append`

into:

`Sales_All_Months`

## Stage 6 - Summary

Create a regional Group By:

- Total Sales
- Total Quantity
- Order Count

## Stage 7 - Reshape

Use the Pivot and Unpivot datasets separately to demonstrate both operations.

---

# 17. Validation checklist

After each transformation, students should check the following.

### Row count

Did the operation unexpectedly add or remove rows?

### Column count

Did the operation create the expected columns?

### Data types

Recommended types:

| Column | Type |
|---|---|
| OrderID | Text |
| OrderDate | Date |
| CustomerID | Text |
| Product | Text |
| Category | Text |
| Region | Text |
| Channel | Text |
| Salesperson | Text |
| Quantity | Whole Number |
| UnitPrice | Decimal Number |
| SalesAmount | Decimal Number |

### Null values

Check whether the transformation introduced unexpected nulls.

### Key integrity

Check:

`OrderID`

and:

`CustomerID`

### Sales total

Check that SalesAmount totals are consistent before and after transformations where the operation should preserve transaction values.

---

# 18. Applied Steps

Power Query records every transformation under:

**Query Settings > Applied Steps**

For example:

`Source`

↓

`Changed Type`

↓

`Split Column by Delimiter`

↓

`Trimmed Text`

↓

`Merged Queries`

↓

`Expanded Customer Master`

↓

`Merged Queries1`

↓

`Expanded Product Master`

Each step can be clicked to see the data at that stage.

## Teaching exercise

Ask students to click each Applied Step and answer:

1. What changed?
2. Did the row count change?
3. Did the column count change?
4. Which columns were affected?
5. Can this step be removed safely?

---

# 19. Best practice for this lab

Do not perform every operation directly on the original query.

For demonstrations, use:

**Right-click query > Duplicate**

or:

**Merge Queries as New**

or:

**Append Queries as New**

This lets students preserve the original source and compare different transformation approaches.

Recommended query naming:

- `Sales_Raw`
- `Sales_Split`
- `Sales_With_Customer`
- `Sales_With_Product`
- `Sales_All_Months`
- `Sales_Regional_Summary`
- `Sales_Product_Summary`
- `Sales_Pivot`
- `Sales_Unpivot`

Clear query names make the Power Query project much easier to maintain.

---

# 20. Final learner challenge

Without following the instructor's clicks, complete this task:

> **Prepare a Sales dataset for reporting by combining transaction data with customer and product information, then create regional and product summaries and demonstrate both wide-to-long and long-to-wide transformations.**

Learners should independently decide when to use:

`Split`

↓

`Merge`

↓

`Append`

↓

`Group By`

↓

`Pivot`

↓

`Unpivot`

Then validate the result.

---

# 21. Expected learning outcome

After completing this package, the learner should be able to explain and perform:

| Operation | Learner should be able to |
|---|---|
| Split | Break one field into multiple fields |
| Group By | Create aggregated summaries |
| Pivot | Turn row values into columns |
| Unpivot | Turn columns into rows |
| Merge | Combine related tables using a key |
| Append | Stack similar tables vertically |
| Expand | Extract fields from a merged table |
| Trim | Remove unwanted spaces |
| Validate | Check rows, columns, types and totals |

---

# 22. Suggested 90-minute classroom schedule

### 0-10 min
Load datasets and understand the Sales structure.

### 10-20 min
Split Column.

### 20-35 min
Group By and aggregation.

### 35-50 min
Pivot and Unpivot.

### 50-70 min
Merge Customer and Product tables.

### 70-80 min
Append January and February.

### 80-90 min
Complete challenge and validation.

---

# Important distinction for Day 2

The learner should understand the difference between **profiling**, **cleaning**, and **transformation**.

### Profiling

Find out:

`What is wrong with the data?`

### Cleaning

Fix:

`nulls, errors, duplicates, spaces, invalid values`

### Transformation

Change the structure or shape:

`Split, Merge, Append, Group By, Pivot, Unpivot`

This package focuses primarily on **data transformation and reshaping**, so the source data is intentionally clean enough for learners to concentrate on these operations.
