# DAX 12-Formulas

## Purpose

This lab is designed around the 12 DAX functions 

The article covers:

1. `CALCULATE`
2. `SUMX`
3. `ALL`
4. `DIVIDE`
5. `ADDCOLUMNS`
6. `SELECTCOLUMNS`
7. `SUMMARIZE`
8. `FILTER`
9. `RELATED`
10. `IF`
11. `SWITCH`
12. `RANKX`

---

# 1. Files in the package

## datasets/Sales.csv

Transaction-level sales data.

Columns:

- OrderID
- OrderDate
- CustomerID
- ProductID
- Quantity
- Discount

Two transactions deliberately have Quantity = 0 so you can test safe division with `DIVIDE`.

## datasets/Customers.csv

Customer dimension.

Columns:

- CustomerID
- CustomerName
- Country
- Region
- Segment

## datasets/Products.csv

Product dimension.

Columns:

- ProductID
- ProductName
- Category
- Tier
- UnitPrice
- UnitCost

## datasets/Date.csv

Calendar table source.

Columns:

- Date
- Year
- MonthNumber
- Month
- Quarter
- YearMonth

---

# 2. Load the data into Power BI

1. Open Power BI Desktop.
2. Select **Home → Get data → Text/CSV**.
3. Load:
   - Sales.csv
   - Customers.csv
   - Products.csv
   - Date.csv
4. Select **Transform Data** if you need to check data types.
5. Confirm:
   - Sales[OrderDate] = Date
   - Sales[Quantity] = Whole number
   - Sales[Discount] = Decimal number
   - Products[UnitPrice] = Decimal/Fixed decimal
   - Products[UnitCost] = Decimal/Fixed decimal
   - Date[Date] = Date
6. Select **Close & Apply**.

---

# 3. Create the relationships

Go to **Model view**.

Create:

```text
Customers[CustomerID]  1 ───── *  Sales[CustomerID]

Products[ProductID]    1 ───── *  Sales[ProductID]

Date[Date]             1 ───── *  Sales[OrderDate]
```

Use single-direction filtering from dimensions to Sales.

This relationship setup is required for the `RELATED` exercise and makes the other exercises easier to understand.

---

# 4. Create the base measures

Select the Sales table.

Choose:

**Home → New measure**

Create:

```DAX
Total Sales =
SUMX(
    Sales,
    Sales[Quantity] *
    RELATED(Products[UnitPrice]) *
    (1 - Sales[Discount])
)
```

This calculates each transaction row first and then adds the results.

Also create:

```DAX
Total Quantity =
SUM(Sales[Quantity])
```

```DAX
Order Count =
COUNTROWS(Sales)
```

```DAX
Customer Count =
DISTINCTCOUNT(Sales[CustomerID])
```

The main 12-function lab starts after these base calculations.

---

# 5. CALCULATE

## Concept

`CALCULATE` evaluates an expression under a changed filter context.

Syntax:

```DAX
CALCULATE(
    [expression],
    [filter1],
    [filter2]
)
```

The article identifies CALCULATE as the most important function in the list and explains that it changes the context in which a calculation is evaluated.

## Create a regional measure

```DAX
South Sales =
CALCULATE(
    [Total Sales],
    Customers[Region] = "South"
)
```

## Test it

1. Add a Card visual.
2. Add `[Total Sales]`.
3. Add another Card.
4. Add `[South Sales]`.
5. Add a table with Customers[Region].
6. Add `[Total Sales]`.

You should be able to compare the overall result with the South-only calculation.

## Practice

Create:

```DAX
North Sales =
CALCULATE(
    [Total Sales],
    Customers[Region] = "North"
)
```

Then create a bar chart by Region.

---

# 6. SUMX

## Concept

`SUMX` is an iterator.

It evaluates an expression row by row and then sums the results.

Syntax:

```DAX
SUMX(
    table,
    expression
)
```

The article specifically contrasts SUM and SUMX: SUM adds values from an existing column, while SUMX can calculate a value per row before adding the results.

## Implementation

Our Sales table does not contain a final net sales column.

The calculation is:

```text
Quantity
   ×
Unit Price
   ×
(1 - Discount)
   =
Net Sales
```

Create:

```DAX
Total Sales =
SUMX(
    Sales,
    Sales[Quantity] *
    RELATED(Products[UnitPrice]) *
    (1 - Sales[Discount])
)
```

## Practice

Create:

```DAX
Total Cost =
SUMX(
    Sales,
    Sales[Quantity] *
    RELATED(Products[UnitCost])
)
```

Then:

```DAX
Total Profit =
[Total Sales] - [Total Cost]
```

---

# 7. ALL

## Concept

`ALL` removes filters from a table or column.

Syntax:

```DAX
ALL(Table)
```

The article describes using ALL inside CALCULATE to return a grand total regardless of slicers or category filters.

## Create grand total

```DAX
All Region Sales =
CALCULATE(
    [Total Sales],
    ALL(Customers[Region])
)
```

## Percentage of total

```DAX
Sales % of Total =
DIVIDE(
    [Total Sales],
    [All Region Sales]
)
```

## Test

1. Add a table.
2. Put Customers[Region] in Rows.
3. Add [Total Sales].
4. Add [All Region Sales].
5. Add [Sales % of Total].
6. Format Sales % of Total as Percentage.

The denominator should remain the overall total while the numerator changes by region.

---

# 8. DIVIDE

## Concept

`DIVIDE` performs safe division.

Syntax:

```DAX
DIVIDE(
    numerator,
    denominator,
    fallback
)
```

The article recommends DIVIDE for percentage and ratio calculations because it handles zero or missing denominators more safely.

## Create average order value

```DAX
Average Sales per Unit =
DIVIDE(
    [Total Sales],
    [Total Quantity],
    0
)
```

## Test the zero case

The Sales dataset contains transactions with Quantity = 0.

This gives you an opportunity to discuss why safe division is preferable when a denominator can be zero.

## Practice

```DAX
Profit Margin =
DIVIDE(
    [Total Profit],
    [Total Sales],
    0
)
```

Format as Percentage.

---

# 9. ADDCOLUMNS

## Concept

`ADDCOLUMNS` adds calculated columns to a table expression.

Syntax:

```DAX
ADDCOLUMNS(
    table,
    "New Column",
    expression
)
```

The article presents it as a table function useful for extending an existing table with calculated values.

## Practice as a calculated table

Go to:

**Modeling → New table**

Create:

```DAX
CustomerSalesTable =
ADDCOLUMNS(
    Customers,
    "Customer Sales",
    CALCULATE([Total Sales])
)
```

This creates a table containing customer information plus a calculated sales value.

## Inspect

Go to Data view and select CustomerSalesTable.

---

# 10. SELECTCOLUMNS

## Concept

`SELECTCOLUMNS` creates a new table containing only the fields you select.

Syntax:

```DAX
SELECTCOLUMNS(
    table,
    "New Name",
    expression
)
```

## Implementation

Create:

```DAX
CustomerLookup =
SELECTCOLUMNS(
    Customers,
    "Customer ID", Customers[CustomerID],
    "Customer Name", Customers[CustomerName],
    "Region", Customers[Region]
)
```

## Practice

Create another table containing:

- Product ID
- Product Name
- Category
- Unit Price

---

# 11. SUMMARIZE

## Concept

`SUMMARIZE` groups data and produces summarized results.

Syntax:

```DAX
SUMMARIZE(
    table,
    group_column,
    "Summary Name",
    expression
)
```

The article compares this concept to pivot-style grouping and describes its use in creating summarized tables.

## Create a region summary

```DAX
RegionSummary =
SUMMARIZE(
    Customers,
    Customers[Region],
    "Sales",
    CALCULATE([Total Sales])
)
```

## Practice

Create a product summary:

```text
Category
Product
Total Sales
```

Then compare the summarized table with a normal Power BI table visual.

---

# 12. FILTER

## Concept

`FILTER` returns only rows that satisfy a condition.

Syntax:

```DAX
FILTER(
    table,
    condition
)
```

The article gives examples such as filtering customers by sales amount or filtering by a category or time condition.

## High-value sales table

Create:

```DAX
HighValueSales =
FILTER(
    Sales,
    Sales[Quantity] >= 7
)
```

This returns only transactions whose quantity is at least 7.

## Practice with customer data

Create a table expression that filters customers to the South region.

```DAX
SouthCustomers =
FILTER(
    Customers,
    Customers[Region] = "South"
)
```

---

# 13. RELATED

## Concept

`RELATED` retrieves a value from a related table.

Syntax:

```DAX
RELATED(Table[Column])
```

The article uses the relationship between a sales table and a customer dimension as the conceptual example.

## Our model

Sales contains:

```text
Sales[ProductID]
```

Products contains:

```text
Products[ProductID]
Products[UnitPrice]
Products[UnitCost]
```

Because the relationship exists, Sales can retrieve the product price.

## Calculated column

Select:

**Sales → New column**

Create:

```DAX
Unit Price =
RELATED(Products[UnitPrice])
```

Create another:

```DAX
Product Category =
RELATED(Products[Category])
```

## Observe

Each Sales row now has information that originally lived in Products.

---

# 14. IF

## Concept

`IF` returns one result when a condition is true and another when it is false.

Syntax:

```DAX
IF(
    condition,
    value_if_true,
    value_if_false
)
```

The article uses a sales threshold example to classify sales as High or Low.

## Create a calculated column

```DAX
Sales Level =
IF(
    Sales[Quantity] >= 7,
    "High",
    "Low"
)
```

## Practice

Create a discount classification:

```DAX
Discount Level =
IF(
    Sales[Discount] > 0.10,
    "High Discount",
    "Normal Discount"
)
```

---

# 15. SWITCH

## Concept

`SWITCH` handles multiple outcomes without creating deeply nested IF statements.

The article uses multiple sales tiers as an example.

## Create quantity bands

```DAX
Quantity Band =
SWITCH(
    TRUE(),
    Sales[Quantity] >= 8, "Very High",
    Sales[Quantity] >= 6, "High",
    Sales[Quantity] >= 3, "Medium",
    "Low"
)
```

## Result

```text
8–9       Very High
6–7       High
3–5       Medium
0–2       Low
```

## Practice

Create product price bands:

```text
Premium
Standard
Budget
```

using Products[UnitPrice].

---

# 16. RANKX

## Concept

`RANKX` assigns a ranking based on an expression or measure.

Syntax:

```DAX
RANKX(
    table,
    expression
)
```

The article describes its use for leaderboards, sorting and Top-N analysis.

## Create region rank

```DAX
Region Rank =
RANKX(
    ALL(Customers[Region]),
    [Total Sales],
    ,
    DESC,
    DENSE
)
```

## Build the leaderboard

Create a table visual containing:

- Region
- Total Sales
- Region Rank

Sort by Region Rank.

You now have a regional sales leaderboard.

---

# 17. Build the final DAX practice page

Create a report page named:

**DAX Formula Lab**

Add these visuals:

## KPI cards

- Total Sales
- Total Profit
- Customer Count
- Profit Margin

## Regional analysis

Bar chart:

```text
Axis: Customers[Region]
Value: [Total Sales]
```

Add:

```text
[Region Rank]
```

## Product analysis

Table:

```text
ProductName
Category
UnitPrice
Total Sales
Total Profit
```

## Sales classification

Table:

```text
OrderID
Quantity
Sales Level
Quantity Band
```

## Filters

Add slicers:

- Region
- Category
- Segment
- Date

---

# 18. Suggested learning sequence

Do not teach the functions as isolated formulas.

Use this sequence:

```text
Base Sales
   ↓
SUMX
   ↓
CALCULATE
   ↓
ALL
   ↓
DIVIDE
   ↓
RELATED
   ↓
FILTER
   ↓
IF
   ↓
SWITCH
   ↓
RANKX
   ↓
ADDCOLUMNS
   ↓
SELECTCOLUMNS
   ↓
SUMMARIZE
   ↓
Final Dashboard
```

This gives learners a progression from row-level calculations to filter context, table expressions and business classifications.

---

# 19. Practice challenges

## Challenge 1: Regional performance

Create:

- Total Sales
- South Sales
- North Sales
- Sales % of Total
- Region Rank

Build a regional leaderboard.

## Challenge 2: Product profitability

Create:

- Total Sales
- Total Cost
- Total Profit
- Profit Margin

Show the products ranked by profit.

## Challenge 3: Customer segmentation

Use IF and SWITCH to create:

```text
Low Value
Medium Value
High Value
```

based on customer sales.

## Challenge 4: Top products

Use RANKX to rank products by Total Sales.

Create a visual showing the Top 3.

## Challenge 5: Safe KPI

Create:

```DAX
Profit Margin =
DIVIDE(
    [Total Profit],
    [Total Sales],
    0
)
```

Then format it as Percentage.

---

# 20. Instructor demonstration checklist

For each function, demonstrate this sequence:

```text
1. Business question
        ↓
2. Identify required table/columns
        ↓
3. Explain the DAX function
        ↓
4. Create the measure/table/column
        ↓
5. Add it to a visual
        ↓
6. Change a slicer
        ↓
7. Observe the result
        ↓
8. Explain why the result changed
```

This is especially important for CALCULATE and ALL because their purpose becomes clearer when learners see the filter context change.

---

# 21. Important distinction

The article discusses both measures and calculated columns.

Use a **measure** when the calculation should respond dynamically to the current report filter context.

Examples:

```DAX
Total Sales =
SUMX(...)
```

```DAX
South Sales =
CALCULATE(...)
```

Use a **calculated column** when you need a row-level value stored with each row.

Examples:

```DAX
Unit Price =
RELATED(Products[UnitPrice])
```

```DAX
Sales Level =
IF(...)
```

The article explains this distinction in its FAQ section.

---

# 22. Expected final report

By the end of the exercise, learners should have a report capable of answering:

1. What are total sales?
2. Which region performs best?
3. What percentage of total sales comes from each region?
4. Which products generate the most profit?
5. Which products rank in the Top 3?
6. Which sales transactions are high volume?
7. Which transactions receive high discounts?
8. How does the result change when Region or Category is filtered?
9. How can related product/customer information be used in Sales calculations?
10. How can sales be grouped into useful business categories?

---

# 23. Source alignment

This workbook is based on the structure and explanations of the ZoomCharts article.

The article's 12 functions are:

```text
CALCULATE
SUMX
ALL
DIVIDE
ADDCOLUMNS
SELECTCOLUMNS
SUMMARIZE
FILTER
RELATED
IF
SWITCH
RANKX
```

The article describes CALCULATE as changing filter context, SUMX as row-by-row iteration, ALL as removing filters, DIVIDE as safe division, the table functions as ways to create or reshape table expressions, RELATED as retrieving values through relationships, IF/SWITCH as conditional logic, and RANKX as a ranking function.

Source:
https://zoomcharts.com/en/microsoft-power-bi-custom-visuals/blog/12-essential-power-bi-dax-formulas-every-report-creator-should-master

