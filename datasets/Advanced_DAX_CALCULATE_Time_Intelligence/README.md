# Advanced DAX
## CALCULATE, YTD, QTD and Rolling Averages

---

# 1. Introduction

This lab builds on the basic DAX functions learned earlier:

- `SUM`
- `COUNTROWS`
- `DISTINCTCOUNT`
- Measures
- Calculated columns

The purpose of this lab is to understand how DAX can answer more analytical questions.

Instead of asking only:

> How much did we sell?

you will learn to answer:

> How much did we sell under a particular filter?

> How much have we sold so far this year?

> How much have we sold so far this quarter?

> What is the recent sales trend based on a moving average?

The four main concepts covered are:

1. **CALCULATE and filter context**
2. **YTD: Year-to-Date**
3. **QTD: Quarter-to-Date**
4. **Rolling averages**

The exercises use the supplied sales model so that every concept can be implemented directly in Power BI Desktop.

---

# 2. Learning sequence

Follow the concepts in this order:

```text
Basic Measure
      ↓
Filter Context
      ↓
CALCULATE
      ↓
Filtered Measures
      ↓
Date Table
      ↓
YTD
      ↓
QTD
      ↓
Rolling Average
      ↓
Interactive Dashboard
```

Do not skip the filter-context exercise before starting time intelligence.

---

# 3. Dataset package

```text
PowerBI_Advanced_DAX_CALCULATE_Time_Intelligence_Lab/
│
├── README.md
│
└── datasets/
    ├── FactSales.csv
    ├── DimDate.csv
    ├── DimCustomer.csv
    └── DimProduct.csv
```

## FactSales.csv

The fact table contains sales transactions for 2025 and 2026.

Important columns:

| Column | Description |
|---|---|
| OrderID | Unique order identifier |
| OrderDate | Date on which the order occurred |
| CustomerID | Customer identifier |
| ProductID | Product identifier |
| Product | Product name |
| Category | Product category |
| Region | Sales region |
| Channel | Online, Retail or Partner |
| Quantity | Units sold |
| UnitPrice | Price before discount |
| Discount | Discount percentage |
| SalesAmount | Final sales value |

Multiple orders can belong to the same customer.

This makes the dataset suitable for continuing the previous `COUNTROWS` and `DISTINCTCOUNT` exercises.

---

# 4. DimDate.csv

The Date table contains a continuous calendar from:

**1 January 2025 to 31 December 2026**

It contains:

- Date
- Year
- Month Number
- Month Name
- Quarter
- Day Name
- Week Number
- Financial Year
- Financial Month Number

This table is important because the time-intelligence calculations need a proper calendar.

---

# 5. DimCustomer.csv

Contains:

- CustomerID
- CustomerName
- CustomerType
- Region

---

# 6. DimProduct.csv

Contains:

- ProductID
- Product
- Category
- StandardPrice

---

# 7. What is DAX?

DAX stands for:

**Data Analysis Expressions**

DAX is the formula language used in Power BI for creating analytical calculations.

For example:

```DAX
Total Sales =
SUM(FactSales[SalesAmount])
```

DAX can be used for:

- Measures
- Calculated columns
- Calculated tables

In this lab, the main calculations will be created as **measures**.

---

# 8. What is a measure?

A measure is a calculation that Power BI evaluates when it is used in a visual.

For example:

```DAX
Total Sales =
SUM(FactSales[SalesAmount])
```

If you put this measure in a card, it shows total sales.

If you put it in a chart grouped by Region, Power BI evaluates the measure separately for each region.

Therefore, the result can change depending on the current report filters.

---

# 9. What is filter context?

Filter context means the conditions under which a DAX calculation is being evaluated.

For example, a report might currently be filtered to:

```text
Year = 2026
Region = South
Channel = Online
```

When Power BI evaluates:

```DAX
[Total Sales]
```

the result is calculated for the records that satisfy those filters.

A useful mental model is:

```text
Report / Visual Filters
        ↓
Current Filter Context
        ↓
DAX Measure
        ↓
Result
```

This concept is essential before learning `CALCULATE`.

---

# 10. What is CALCULATE?

`CALCULATE` evaluates an expression after modifying the filter context.

General syntax:

```DAX
CALCULATE(
    <expression>,
    <filter1>,
    <filter2>
)
```

Example:

```DAX
Online Sales =
CALCULATE(
    SUM(FactSales[SalesAmount],
    FactSales[Channel] = "Online"
)
```

Read this as:

> Calculate Total Sales while applying the Online channel filter.

The basic pattern is:

```text
Existing Context
      ↓
CALCULATE
      ↓
Modify Context
      ↓
Evaluate Expression
```

---

# 11. Why CALCULATE is important

Without `CALCULATE`, you can calculate:

```DAX
Total Sales =
SUM(FactSales[SalesAmount])
```

With `CALCULATE`, you can create calculations such as:

- Online Sales
- South Sales
- Sales for a particular category
- Sales under multiple conditions
- Time-intelligence calculations

It is one of the most important building blocks in advanced DAX.

---

# 12. What is YTD?

YTD means:

**Year-to-Date**

It represents the accumulated value from the beginning of the year through the current date/context.

Suppose monthly sales are:

| Month | Sales |
|---|---:|
| January | 100,000 |
| February | 120,000 |
| March | 80,000 |
| April | 150,000 |

YTD becomes:

| Month | Sales | YTD |
|---|---:|---:|
| January | 100,000 | 100,000 |
| February | 120,000 | 220,000 |
| March | 80,000 | 300,000 |
| April | 150,000 | 450,000 |

YTD resets when a new year begins.

---

# 13. What is QTD?

QTD means:

**Quarter-to-Date**

It represents the accumulated value from the beginning of the current quarter through the current date/context.

For Q1:

```text
January = 100K
February = 120K
March = 80K
```

QTD:

```text
January = 100K
February = 220K
March = 300K
```

When April starts, Q2 starts and QTD resets:

```text
April = 150K
May = 260K
June = ...
```

---

# 14. What is a rolling average?

A rolling average calculates an average over a moving time window.

For a 3-month rolling average:

```text
March:
January + February + March

April:
February + March + April

May:
March + April + May
```

The window moves as the current period changes.

Rolling averages are useful for reducing short-term fluctuations and observing the recent trend.

---

# 15. Why a proper Date table is required

Time-intelligence calculations work best with a dedicated Date table containing a continuous sequence of dates.

The model should contain:

```text
DimDate
   |
   | 1
   |
   | *
   ↓
FactSales
```

Relationship:

```text
DimDate[Date]
       ↓
FactSales[OrderDate]
```

The Date table should cover the complete period being analyzed.

---

# PART A
# IMPORT THE DATA

## Step 1: Open Power BI Desktop

Create a new blank report.

---

## Step 2: Import FactSales

Select:

**Home → Get Data → Text/CSV**

Choose:

`FactSales.csv`

Select:

**Transform Data**

---

## Step 3: Check FactSales data types

Set:

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

## Step 4: Import DimDate

Import:

`DimDate.csv`

Set:

`Date` → Date

`Year` → Whole Number

`MonthNumber` → Whole Number

`MonthName` → Text

`Quarter` → Text

`WeekNumber` → Whole Number

`FinancialYear` → Text

`FinancialMonthNumber` → Whole Number

---

## Step 5: Import DimCustomer

Import:

`DimCustomer.csv`

Ensure:

`CustomerID` = Text

---

## Step 6: Import DimProduct

Import:

`DimProduct.csv`

Ensure:

`ProductID` = Text

---

# PART B
# CREATE THE DATA MODEL

## Step 7: Open Model view

Select the:

**Model view**

You should see four tables:

```text
FactSales
DimDate
DimCustomer
DimProduct
```

---

## Step 8: Create the Date relationship

Drag:

```text
DimDate[Date]
```

onto:

```text
FactSales[OrderDate]
```

Set:

**Cardinality**

`One to many (1:*)`

Set:

**Cross-filter direction**

`Single`

Click:

**OK**

The relationship should appear as:

```text
DimDate  1 ───────── * FactSales
```

---

## Step 9: Create Customer relationship

Connect:

```text
DimCustomer[CustomerID]
```

to:

```text
FactSales[CustomerID]
```

Use:

`One to many (1:*)`

and:

`Single`

---

## Step 10: Create Product relationship

Connect:

```text
DimProduct[ProductID]
```

to:

```text
FactSales[ProductID]
```

Use:

`One to many (1:*)`

and:

`Single`

---

# PART C
# PREPARE THE DATE TABLE

## Step 11: Mark DimDate as a Date table

Select:

`DimDate`

Go to:

**Table tools → Mark as date table**

Choose:

```text
DimDate[Date]
```

Click:

**OK**

---

## Step 12: Sort MonthName

Select:

`DimDate[MonthName]`

Go to:

**Column tools → Sort by column**

Choose:

`MonthNumber`

This ensures the months appear as:

```text
January
February
March
April
...
December
```

instead of alphabetical order.

---

# PART D
# CREATE THE BASE MEASURE

## Step 13: Create Total Sales

Right-click:

`FactSales`

Select:

**New measure**

Enter:

```DAX
Total Sales =
SUM(FactSales[SalesAmount])
```

Press:

**Enter**

---

## Step 14: Test Total Sales

Insert a:

**Card**

Add:

`Total Sales`

Then create a table with:

`DimProduct[Category]`

and:

`[Total Sales]`

The measure will show different values for different categories.

This is your first demonstration of filter context.

---

# PART E
# CALCULATE: FIRST IMPLEMENTATION

## Step 15: Create Online Sales

Right-click:

`FactSales`

Select:

**New measure**

Enter:

```DAX
Online Sales =
CALCULATE(
    SUM(FactSales[SalesAmount]),
    FactSales[Channel] = "Online"
)
```

Press:

**Enter**

---

## Step 16: Create a comparison

Create a Card for:

`Total Sales`

Create another Card for:

`Online Sales`

The second card represents sales where:

```text
Channel = Online
```

---

# PART F
# CALCULATE WITH REGION

## Step 17: Create South Sales

Create:

```DAX
South Sales =
CALCULATE(
    SUM(FactSales[SalesAmount]),
    FactSales[Region] = "South"
)
```

Add it to a Card.

---

# PART G
# CALCULATE WITH MULTIPLE FILTERS

## Step 18: Create South Online Sales

Create:

```DAX
South Online Sales =
CALCULATE(
    SUM(FactSales[SalesAmount]),
    FactSales[Region] = "South",
    FactSales[Channel] = "Online"
)
```

This applies:

```text
Region = South
AND
Channel = Online
```

---

# PART H
# OBSERVE FILTER CONTEXT

## Step 19: Create a filter-context experiment

Add slicers:

- Region
- Channel
- Category
- Year

Add Cards:

- Total Sales
- Online Sales
- South Sales
- South Online Sales

Change the slicer selections.

Observe which calculations change.

Discuss:

> What happens when the report is filtered to South?

> What happens when Online is selected?

> What happens when Category is changed?

This experiment should be completed before moving to time intelligence.

---

# PART I
# CREATE YTD

## Step 20: Create Sales YTD

Create a new measure:

```DAX
Sales YTD = 
TOTALYTD(
    SUM(FactSales[SalesAmount]),
    DimDate[Date]
)
```

Press:

**Enter**

---

# PART J
# BUILD YTD VISUAL

## Step 21: Create a line chart

Insert:

**Line chart**

Add:

### X-axis

```text
DimDate[MonthName]
```

### Y-axis

```text
[Total Sales]
[Sales YTD]
```

Add:

`DimDate[Year]`

as a slicer.

Select 2025.

Then select 2026.

Observe where the YTD accumulation begins again.

---

# PART K
# CREATE QTD

## Step 22: Create Sales QTD

Create:

```DAX
Sales QTD =
TOTALQTD(
    [Total Sales],
    DimDate[Date]
)
```

Press:

**Enter**

---

# PART L
# TEST QTD

## Step 23

Create a line chart.

Axis:

`DimDate[MonthName]`

Value:

`Sales QTD`

Add:

`DimDate[Quarter]`

as a slicer.

Select Q1.

Observe the accumulation.

Then select Q2.

Observe that the accumulation starts again.

---

# PART M
# COMPARE YTD AND QTD

## Step 24

Create a table containing:

```text
Month
Total Sales
Sales YTD
Sales QTD
```

Expected behavior:

```text
January
    YTD starts
    QTD starts

February
    YTD continues
    QTD continues

March
    YTD continues
    QTD continues

April
    YTD continues
    QTD resets
```

This is one of the most important differences between YTD and QTD.

---

# PART N
# CREATE A 3-MONTH ROLLING AVERAGE

## Step 25

Create:

```DAX
3 Month Rolling Average =
AVERAGEX(
    DATESINPERIOD(
        DimDate[Date],
        MAX(DimDate[Date]),
        -3,
        MONTH
    ),
    [Total Sales]
)
```

Press:

**Enter**

---

# PART O
# UNDERSTAND THE ROLLING FORMULA

Break the expression into three parts.

## Part 1: MAX

```DAX
MAX(DimDate[Date])
```

Finds the latest date in the current context.

---

## Part 2: DATESINPERIOD

```DAX
DATESINPERIOD(
    DimDate[Date],
    MAX(DimDate[Date]),
    -3,
    MONTH
)
```

Creates a three-month date window ending at the current date.

---

## Part 3: AVERAGEX

```DAX
AVERAGEX(
    <date window>,
    [Total Sales]
)
```

Evaluates Total Sales over the window and calculates the average.

Overall:

```text
Current Date
     ↓
MAX(Date)
     ↓
DATESINPERIOD
     ↓
3-Month Window
     ↓
Total Sales
     ↓
AVERAGEX
     ↓
3-Month Rolling Average
```

---

# PART P
# BUILD THE ROLLING AVERAGE CHART

## Step 26

Create a Line chart.

Axis:

`DimDate[MonthName]`

Values:

- Total Sales
- 3 Month Rolling Average

Add:

`Year`

as a slicer.

Compare the monthly sales line with the rolling-average line.

---

# PART Q
# CREATE 6-MONTH ROLLING AVERAGE

## Step 27

Create:

```DAX
6 Month Rolling Average =
AVERAGEX(
    DATESINPERIOD(
        DimDate[Date],
        MAX(DimDate[Date]),
        -6,
        MONTH
    ),
    [Total Sales]
)
```

Compare:

- 3 Month Rolling Average
- 6 Month Rolling Average

The 6-month window should generally respond more slowly to short-term changes.

---

# PART R
# FINAL DASHBOARD

Create a report page named:

**Sales Performance & Time Intelligence**

## KPI Cards

### Card 1

`Total Sales`

### Card 2

`Online Sales`

### Card 3

`Sales YTD`

### Card 4

`Sales QTD`

---

## Chart 1: Monthly Sales

Axis:

`MonthName`

Value:

`Total Sales`

---

## Chart 2: YTD Trend

Axis:

`MonthName`

Values:

- Total Sales
- Sales YTD

---

## Chart 3: QTD Trend

Axis:

`MonthName`

Value:

`Sales QTD`

---

## Chart 4: Rolling Trend

Axis:

`MonthName`

Values:

- Total Sales
- 3 Month Rolling Average
- 6 Month Rolling Average

---

## Slicers

Add:

- Year
- Quarter
- Region
- Channel
- Category

---

# PART S
# HANDS-ON CHALLENGES

## Challenge 1: Regional Online Sales

Create:

```DAX
Regional Online Sales =
CALCULATE(
    [Total Sales],
    FactSales[Channel] = "Online"
)
```

Display it by Region.

---

## Challenge 2: YTD by Region

Create a table:

```text
Region
Total Sales
Sales YTD
```

Check whether YTD changes correctly when Region is selected.

---

## Challenge 3: QTD by Channel

Create:

```text
Channel
Total Sales
Sales QTD
```

Use Quarter as a slicer.

---

## Challenge 4: Product Rolling Average

Create a chart using:

```text
Month
Product
Total Sales
3 Month Rolling Average
```

Use Product as a slicer.

---

## Challenge 5: Compare Rolling Windows

Display:

```text
Total Sales
3 Month Rolling Average
6 Month Rolling Average
```

Explain why the two averages can differ.

---

# PART T
# COMMON ERRORS

## Error 1: Month names appear alphabetically

Problem:

```text
April
August
December
February
...
```

Solution:

Select:

`DimDate[MonthName]`

Then:

**Column tools → Sort by column → MonthNumber**

---

## Error 2: Date relationship is missing

If:

```text
DimDate[Date]
```

is not related to:

```text
FactSales[OrderDate]
```

time-intelligence results may not behave correctly.

Create:

```text
DimDate 1 → * FactSales
```

---

## Error 3: Wrong Date column

Use:

```text
DimDate[Date]
```

for the time-intelligence calculation.

Do not use a text MonthName column as the Date argument.

---

## Error 4: Date column is Text

Check the data type.

`DimDate[Date]` must be:

**Date**

---

## Error 5: Duplicate Date values in Date table

A proper Date dimension should contain one row per date.

The supplied `DimDate.csv` is already prepared this way.

---

## Error 6: YTD does not reset

Check:

- Year field
- Date table
- Date relationship
- Date table marking
- Date column data type

---

# PART U
# QUICK KNOWLEDGE CHECK

### 1. What does CALCULATE do?

It evaluates an expression after modifying filter context.

### 2. What is filter context?

The set of filters currently affecting a DAX calculation.

### 3. What does YTD mean?

Year-to-Date.

### 4. What does QTD mean?

Quarter-to-Date.

### 5. Why is a Date table important?

It provides a continuous calendar for time-based analysis.

### 6. What does DATESINPERIOD do?

It returns a date range around a specified date using a selected interval.

### 7. What does AVERAGEX do?

It evaluates an expression over a table and returns its average.

### 8. What is the difference between YTD and QTD?

YTD accumulates from the start of the year.

QTD accumulates from the start of the current quarter.

### 9. What is a rolling average?

An average calculated over a moving time window.

---

# PART V
# DAX REFERENCE

## Base measure

```DAX
Total Sales =
SUM(FactSales[SalesAmount])
```

## CALCULATE

```DAX
Online Sales =
CALCULATE(
    [Total Sales],
    FactSales[Channel] = "Online"
)
```

## Multiple filters

```DAX
South Online Sales =
CALCULATE(
    [Total Sales],
    FactSales[Region] = "South",
    FactSales[Channel] = "Online"
)
```

## YTD

```DAX
Sales YTD =
TOTALYTD(
    [Total Sales],
    DimDate[Date]
)
```

## QTD

```DAX
Sales QTD =
TOTALQTD(
    [Total Sales],
    DimDate[Date]
)
```

## 3-month rolling average

```DAX
3 Month Rolling Average =
AVERAGEX(
    DATESINPERIOD(
        DimDate[Date],
        MAX(DimDate[Date]),
        -3,
        MONTH
    ),
    [Total Sales]
)
```

## 6-month rolling average

```DAX
6 Month Rolling Average =
AVERAGEX(
    DATESINPERIOD(
        DimDate[Date],
        MAX(DimDate[Date]),
        -6,
        MONTH
    ),
    [Total Sales]
)
```

---

# FINAL STUDENT DELIVERABLE

The completed Power BI report should contain:

## Model

- FactSales
- DimDate
- DimCustomer
- DimProduct
- Correct one-to-many relationships

## DAX measures

- Total Sales
- Online Sales
- South Sales
- South Online Sales
- Sales YTD
- Sales QTD
- 3 Month Rolling Average
- 6 Month Rolling Average

## Report page

- Total Sales KPI
- Online Sales KPI
- Sales YTD KPI
- Sales QTD KPI
- Monthly sales chart
- YTD chart
- QTD chart
- Rolling-average chart
- Year slicer
- Quarter slicer
- Region slicer
- Channel slicer
- Category slicer

---

# COMPLETE LEARNING FLOW

```text
1. Import data
        ↓
2. Check data types
        ↓
3. Build relationships
        ↓
4. Prepare Date table
        ↓
5. Create Total Sales
        ↓
6. Understand filter context
        ↓
7. Learn CALCULATE
        ↓
8. Create filtered measures
        ↓
9. Create YTD
        ↓
10. Create QTD
        ↓
11. Create rolling average
        ↓
12. Add slicers
        ↓
13. Validate calculations
        ↓
14. Build final dashboard
```

# Instructor note

Teach this module progressively.

Do not start by giving students the rolling-average formula.

First make sure they can explain:

```text
Total Sales
      ↓
Filter Context
      ↓
CALCULATE
```

Then introduce:

```text
Date Table
      ↓
YTD
      ↓
QTD
```

Finally introduce:

```text
DATESINPERIOD
      ↓
AVERAGEX
      ↓
Rolling Average
```

This sequence allows students to understand what each part of the calculation is doing instead of memorizing DAX formulas.
