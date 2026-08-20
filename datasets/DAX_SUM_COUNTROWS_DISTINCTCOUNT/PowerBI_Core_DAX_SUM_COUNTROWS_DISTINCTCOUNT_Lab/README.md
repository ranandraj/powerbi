# DAX Fundamentals
## SUM, COUNTROWS and DISTINCTCOUNT

### Goal

This lab introduces DAX and gives a practical way to create and test the three core aggregation functions:

- `SUM`
- `COUNTROWS`
- `DISTINCTCOUNT`

The exercises use a sales dataset where the same customer appears in multiple orders. This makes the difference between **rows/orders** and **unique customers** easy to observe.

No advanced DAX is required.

---

# 1. What is DAX?

DAX stands for **Data Analysis Expressions**.

It is the formula language used in Power BI for creating calculations from model data.

DAX is used for calculations such as:

- Total sales
- Number of records
- Number of unique customers
- Percentages
- Year-to-date values
- Comparisons between periods
- Conditional calculations

DAX is written as an expression.

Example:

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

The left side is the name of the calculation:

`Total Sales`

The right side is the DAX expression:

```DAX
SUM(Sales[SalesAmount])
```

---

# 2. DAX is not the same as Power Query

This distinction is important.

### Power Query

Used mainly for:

- Importing data
- Cleaning data
- Removing duplicates
- Changing data types
- Splitting columns
- Merging data
- Appending data
- Reshaping data

### DAX

Used mainly for:

- Calculations
- Measures
- Calculated columns
- Calculated tables
- Business logic
- Analytical calculations

A useful workflow is:

```text
Raw Data
   ↓
Power Query
   ↓
Clean Data
   ↓
Data Model
   ↓
DAX Calculations
   ↓
Reports
```

---

# 3. Main DAX calculation types in Power BI

For this training, learn these three first:

## A. Measure

A measure is a calculation evaluated when a visual needs it.

Example:

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

The result changes according to the visual's filters.

If a report is filtered to:

`South`

the measure calculates sales for South.

If the report is filtered to:

`Online`

it calculates sales for Online.

Measures are normally the preferred way to create report KPIs.

---

## B. Calculated Column

A calculated column creates a value for each row.

Example:

```DAX
Sales After Discount =
Sales[Quantity] * Sales[UnitPrice] * (1 - Sales[Discount])
```

Each row gets its own calculated result.

Use calculated columns when you need a value stored at row level for use in categories, filtering or relationships.

---

## C. Calculated Table

A calculated table creates a new table using DAX.

Example:

```DAX
HighValueOrders =
FILTER(
    Sales,
    Sales[SalesAmount] > 100000
)
```

This creates a separate table containing matching rows.

Calculated tables are useful in selected modelling scenarios, but they are not required for today's three core aggregation exercises.

---

# 4. Important distinction

### Measure

```text
One calculation
evaluated according to
the current report context
```

### Calculated Column

```text
One calculated value
for every row
```

### Calculated Table

```text
A new table
created from model data
```

For this lab, most KPI calculations should be created as **measures**.

---

# PART A: LOAD THE DATA

## Step 1: Open Power BI Desktop

Create a new blank report.

---

## Step 2: Import Sales.csv

Go to:

**Home → Get Data → Text/CSV**

Select:

`Sales.csv`

Choose:

**Transform Data**

---

## Step 3: Check data types

Verify:

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

Select:

**Close & Apply**

---

# PART B: UNDERSTAND THE DATA

The Sales table contains 150 orders.

There are only 20 customer IDs.

Therefore:

```text
150 orders
20 unique customers
```

This is deliberate.

It allows you to see why:

```DAX
COUNTROWS(Sales)
```

and:

```DAX
DISTINCTCOUNT(Sales[CustomerID])
```

produce different results.

---

# PART C: CREATE YOUR FIRST DAX MEASURE

## Step 4: Select the Sales table

In the Fields/Data pane, right-click:

`Sales`

Select:

**New measure**

A formula bar appears.

---

## Step 5: Enter SUM

Type:

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

Press:

**Enter**

You have created your first DAX measure.

---

# PART D: USE THE MEASURE

## Step 6: Create a Card

Insert a:

**Card**

Add:

`Total Sales`

The card displays total sales for the current report context.

---

## Step 7: Add a Region chart

Create a column chart.

Add:

**X-axis:**

`Sales[Region]`

**Y-axis:**

`[Total Sales]`

You should now see sales separately for:

- North
- South
- East
- West

The same measure is being evaluated separately for each region.

---

# PART E: UNDERSTAND SUM

`SUM` adds numeric values.

Example:

| SalesAmount |
|---:|
| 10000 |
| 20000 |
| 15000 |

Then:

```DAX
SUM(Sales[SalesAmount])
```

returns:

```text
45000
```

Syntax:

```DAX
SUM(Table[NumericColumn])
```

Example:

```DAX
Total Quantity =
SUM(Sales[Quantity])
```

---

# PART F: CREATE COUNTROWS

## Step 8: Create another measure

Right-click:

`Sales`

Select:

**New measure**

Enter:

```DAX
Total Orders =
COUNTROWS(Sales)
```

Press Enter.

---

# PART G: USE COUNTROWS

Create a Card.

Add:

`Total Orders`

You should get:

```text
150
```

because the Sales table contains 150 rows.

In this dataset:

```text
1 row = 1 order
```

Therefore:

```text
Number of rows = Number of orders
```

---

# PART H: COUNTROWS WITH FILTERING

Create a table or chart:

**Region**

and:

**Total Orders**

You will see the number of orders in each region.

The same measure:

```DAX
Total Orders =
COUNTROWS(Sales)
```

is evaluated separately for each region.

You do not need a separate formula for North, South, East or West.

---

# PART I: CREATE DISTINCTCOUNT

## Step 9: Create a unique customer measure

Right-click:

`Sales`

Select:

**New measure**

Enter:

```DAX
Unique Customers =
DISTINCTCOUNT(Sales[CustomerID])
```

Press Enter.

---

# PART J: USE DISTINCTCOUNT

Create a Card.

Add:

`Unique Customers`

Expected result:

```text
20
```

The Sales table contains 150 rows but only 20 different CustomerID values.

---

# PART K: UNDERSTAND THE DIFFERENCE

Create a table visual.

Add:

- Region
- Total Orders
- Unique Customers
- Total Sales

You should see something conceptually similar to:

```text
Region    Orders    Customers    Sales
----------------------------------------
East        ...        ...         ...
North       ...        ...         ...
South       ...        ...         ...
West        ...        ...         ...
```

This is where DAX becomes useful.

The calculations respond to the region shown in the visual.

---

# PART L: COUNTROWS VS DISTINCTCOUNT

This is one of the most important concepts in this exercise.

Suppose the data contains:

| OrderID | CustomerID |
|---|---|
| ORD0001 | CUST001 |
| ORD0002 | CUST001 |
| ORD0003 | CUST002 |
| ORD0004 | CUST003 |
| ORD0005 | CUST003 |

Then:

```DAX
COUNTROWS(Sales)
```

returns:

```text
5
```

because there are five rows.

But:

```DAX
DISTINCTCOUNT(Sales[CustomerID])
```

returns:

```text
3
```

because there are three unique customers:

```text
CUST001
CUST002
CUST003
```

---

# PART M: CREATE A KPI PAGE

Create four cards:

### Card 1

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

### Card 2

```DAX
Total Orders =
COUNTROWS(Sales)
```

### Card 3

```DAX
Unique Customers =
DISTINCTCOUNT(Sales[CustomerID])
```

### Card 4

```DAX
Total Quantity =
SUM(Sales[Quantity])
```

Arrange them across the top of the report.

---

# PART N: ADD FILTERS

Add a slicer:

`Region`

Add another slicer:

`Channel`

Now select:

`South`

Observe all cards.

Then select:

`Online`

Observe the cards again.

The measures change according to the active filter context.

This is a fundamental DAX concept.

---

# PART O: PRODUCT ANALYSIS

Create a bar chart.

Category:

`Product`

Value:

`Total Sales`

Create another chart:

Category:

`Product`

Value:

`Total Orders`

Create another:

Category:

`Product`

Value:

`Unique Customers`

Now compare:

```text
Product
   ↓
Total Sales
Total Orders
Unique Customers
```

---

# PART P: CUSTOMER ANALYSIS

Create a table:

| CustomerID | Total Sales | Total Orders |
|---|---:|---:|

Add:

`Sales[CustomerID]`

Then add:

`[Total Sales]`

and:

`[Total Orders]`

Each customer now has its own calculations.

---

# PART Q: OPTIONAL CALCULATED COLUMN DEMONSTRATION

This is only to understand the difference between a measure and a calculated column.

Select:

**Sales → New column**

Enter:

```DAX
Gross Amount =
Sales[Quantity] * Sales[UnitPrice]
```

This creates a value for every row.

You will see:

```text
OrderID    Quantity    UnitPrice    Gross Amount
-------------------------------------------------
ORD0001       2          65000          130000
ORD0002       3          18000           54000
...
```

Notice the difference:

```text
Calculated Column
= one result per row
```

while:

```text
Measure
= calculation evaluated in the report context
```

For the core KPI calculations in this lab, use measures.

---

# PART R: HANDS-ON EXERCISES

## Exercise 1: Total Sales

Create:

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

Display it in a Card.

---

## Exercise 2: Total Quantity

Create:

```DAX
Total Quantity =
SUM(Sales[Quantity])
```

Display it in a Card.

---

## Exercise 3: Total Orders

Create:

```DAX
Total Orders =
COUNTROWS(Sales)
```

Display it in a Card.

---

## Exercise 4: Unique Customers

Create:

```DAX
Unique Customers =
DISTINCTCOUNT(Sales[CustomerID])
```

Display it in a Card.

---

## Exercise 5: Region Analysis

Create a table:

```text
Region
Total Sales
Total Orders
Unique Customers
```

---

## Exercise 6: Channel Analysis

Create a table:

```text
Channel
Total Sales
Total Orders
Unique Customers
```

---

## Exercise 7: Product Analysis

Create:

```text
Product
Total Sales
Total Quantity
Total Orders
Unique Customers
```

---

# PART S: KNOWLEDGE CHECK

### Question 1

What does DAX stand for?

**Data Analysis Expressions**

### Question 2

Which DAX function adds numeric values?

**SUM**

### Question 3

Which function counts rows?

**COUNTROWS**

### Question 4

Which function counts unique values?

**DISTINCTCOUNT**

### Question 5

If Sales contains 150 orders and 20 unique customers, what should these return?

```DAX
COUNTROWS(Sales)
```

Answer:

```text
150
```

```DAX
DISTINCTCOUNT(Sales[CustomerID])
```

Answer:

```text
20
```

### Question 6

Should Total Sales normally be a measure or a calculated column?

**Measure**

---

# FINAL DASHBOARD CHALLENGE

Build a Sales KPI dashboard containing:

## KPI Cards

- Total Sales
- Total Orders
- Unique Customers
- Total Quantity

## Visuals

### 1. Sales by Region

Region + Total Sales

### 2. Orders by Region

Region + Total Orders

### 3. Customers by Region

Region + Unique Customers

### 4. Sales by Product

Product + Total Sales

### 5. Sales by Channel

Channel + Total Sales

### 6. Customer Table

CustomerID + Total Sales + Total Orders

## Slicers

- Region
- Channel
- Category

Test every slicer and observe how the measures change.

---

# FINAL CONCEPT MAP

```text
                    DAX
                     |
        ┌────────────┼────────────┐
        ↓            ↓            ↓
     Measure     Calculated    Calculated
                  Column         Table
        |
        ↓
   Core Aggregations
        |
   ┌────┼─────────────┐
   ↓    ↓             ↓
 SUM  COUNTROWS  DISTINCTCOUNT
   |      |             |
 Sales   Rows       Unique values
```

## Remember

### SUM

Adds values from a numeric column.

```DAX
Total Sales =
SUM(Sales[SalesAmount])
```

### COUNTROWS

Counts rows in a table.

```DAX
Total Orders =
COUNTROWS(Sales)
```

### DISTINCTCOUNT

Counts unique values in a column.

```DAX
Unique Customers =
DISTINCTCOUNT(Sales[CustomerID])
```

The most important distinction for this lab is:

```text
COUNTROWS
= How many rows/orders?

DISTINCTCOUNT
= How many different customers?
```

---

# Suggested classroom sequence

```text
Understand DAX
      ↓
Understand Measure
      ↓
Create SUM
      ↓
Create COUNTROWS
      ↓
Create DISTINCTCOUNT
      ↓
Build KPI cards
      ↓
Add Region slicer
      ↓
Observe filter context
      ↓
Build product/customer analysis
      ↓
Complete Sales dashboard
```

This lab intentionally starts with the three core aggregation functions before introducing more advanced DAX such as CALCULATE and time intelligence.
