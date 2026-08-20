# Date Tables - Auto Date/Time vs Custom Date Table

## Objective

This lab teaches **Auto Date/Time vs a Custom Date Table** using the IoT dataset.


You will practise:
- Auto Date/Time
- Date Hierarchy
- Year, Quarter, Month and Day
- Importing a custom calendar
- Date relationships
- One-to-many relationships
- Single filter direction
- Month sorting
- Week analysis
- Working-day analysis
- Holiday analysis
- Financial-year analysis
- Financial-month analysis
- Comparing automatic and custom date structures

---

# 1. Dataset package

## FactIoTReadings_2026.csv

Contains 730 IoT readings, with two readings per day for 2026.

Columns:
- ReadingID
- Date
- DeviceID
- SiteID
- Temperature
- Humidity
- EnergyKWh
- AlertCount

## DimDate_Practice.csv

Contains every date in 2026.

Columns:
- Date
- DayName
- DayOfMonth
- MonthNumber
- MonthName
- Quarter
- WeekNumber
- IsWorkingDay
- IsHoliday
- FinancialYear
- FinancialMonthNumber

The supplied financial year follows an April-to-March calendar.

## DimDevice.csv
Device master data.

## DimSite.csv
Site master data.

---

# PART A: AUTO DATE/TIME

## Step 1: Import the IoT fact table

Power BI Desktop:

**Home → Get Data → Text/CSV**

Select:

`FactIoTReadings_2026.csv`

Choose **Transform Data**.

Check that:
- Date = Date
- Temperature = Decimal Number
- Humidity = Decimal Number
- EnergyKWh = Decimal Number
- AlertCount = Whole Number

Select **Close & Apply**.

## Step 2: Check Auto Date/Time

Go to:

**File → Options and settings → Options**

Then:

**Current File → Data Load**

Find **Time intelligence**.

Keep **Auto date/time** enabled.

Click **OK**.

## Step 3: Build a date visual

Insert a Line chart.

Use:
- X-axis: `FactIoTReadings_2026[Date]`
- Values: `FactIoTReadings_2026[EnergyKWh]`

Power BI may provide **Date Hierarchy**.

## Step 4: Test the hierarchy

Use:
- Year
- Quarter
- Month
- Day

Try the drill controls on the visual.

Observe how Power BI automatically provides calendar levels.

---

# PART B: UNDERSTAND THE LIMITATION

Suppose the business asks for:
- Week Number
- Working Day
- Holiday
- Financial Year
- Financial Month

These are business-calendar requirements.

The supplied custom calendar contains these fields so you can see why a dedicated Date table gives you more control.

---

# PART C: IMPORT THE CUSTOM DATE TABLE

## Step 5: Import DimDate

**Home → Get Data → Text/CSV**

Select:

`DimDate_Practice.csv`

Choose **Transform Data**.

Check the types:

| Column | Type |
|---|---|
| Date | Date |
| DayName | Text |
| DayOfMonth | Whole Number |
| MonthNumber | Whole Number |
| MonthName | Text |
| Quarter | Text |
| WeekNumber | Whole Number |
| IsWorkingDay | Whole Number |
| IsHoliday | Whole Number |
| FinancialYear | Text |
| FinancialMonthNumber | Whole Number |

Select **Close & Apply**.

---

# PART D: CREATE THE DATE RELATIONSHIP

## Step 6: Open Model view

Select **Model view**.

Find:
- `DimDate_Practice`
- `FactIoTReadings_2026`

## Step 7: Create the relationship

Drag:

`DimDate_Practice[Date]`

to:

`FactIoTReadings_2026[Date]`

Set:

**Cardinality:** One to many (1:*)

**Cross-filter direction:** Single

The model should be:

```text
DimDate_Practice
       1
       |
       |
       *
FactIoTReadings_2026
```

Why?

The Date table has one row per date.

The fact table has multiple readings for the same date.

---

# PART E: MONTH ANALYSIS

## Step 8: Create Energy by Month

Create a column chart.

Category:

`DimDate_Practice[MonthName]`

Value:

`FactIoTReadings_2026[EnergyKWh]`

## Step 9: Fix the month order

Month names are text and can sort alphabetically.

Select:

`DimDate_Practice[MonthName]`

Then:

**Column tools → Sort by column → MonthNumber**

The order should become:

January, February, March, April, May, June, July, August, September, October, November, December.

---

# PART F: QUARTER ANALYSIS

Create a visual using:

`DimDate_Practice[Quarter]`

and:

`FactIoTReadings_2026[EnergyKWh]`

Expected categories:

Q1, Q2, Q3, Q4.

---

# PART G: WEEK ANALYSIS

Create a visual using:

`DimDate_Practice[WeekNumber]`

and:

`FactIoTReadings_2026[EnergyKWh]`

This gives you explicit weekly reporting.

---

# PART H: WORKING DAY ANALYSIS

Use:

`DimDate_Practice[IsWorkingDay]`

with:

`FactIoTReadings_2026[EnergyKWh]`

Interpret:

0 = Weekend

1 = Working day

This type of business-calendar classification is available because the calendar is explicitly modelled.

---

# PART I: HOLIDAY ANALYSIS

The supplied calendar marks three sample holidays:

- 26-Jan-2026
- 15-Aug-2026
- 02-Oct-2026

Use:

`IsHoliday`

as a slicer or category.

Interpret:

0 = Not a holiday

1 = Holiday

You can modify the values in Power Query for your own business calendar.

---

# PART J: FINANCIAL YEAR

Use:

`DimDate_Practice[FinancialYear]`

with:

`FactIoTReadings_2026[EnergyKWh]`

The supplied calendar follows an April-to-March financial year.

---

# PART K: FINANCIAL MONTH

Use:

`FinancialMonthNumber`

for the financial sequence:

April = 1
May = 2
June = 3
July = 4
August = 5
September = 6
October = 7
November = 8
December = 9
January = 10
February = 11
March = 12

This demonstrates a business calendar that differs from the normal January-to-December sequence.

---

# PART L: AUTO VS CUSTOM PRACTICE

Create two report sections.

## Section A: Auto Date/Time

Use the automatic Date Hierarchy.

Test:
- Year
- Quarter
- Month
- Day

## Section B: Custom Date Table

Use `DimDate_Practice`.

Test:
- Year
- Quarter
- Month
- Week
- Working Day
- Holiday
- Financial Year
- Financial Month

---

# COMPARISON

| Requirement | Auto Date/Time | Custom Date Table |
|---|---|---|
| Year | Yes | Yes |
| Quarter | Yes | Yes |
| Month | Yes | Yes |
| Day | Yes | Yes |
| Week | Limited | Yes |
| Working Day | No | Yes |
| Holiday | No | Yes |
| Financial Year | Not business-specific | Yes |
| Financial Month | Not business-specific | Yes |
| Calendar customization | Limited | High |
| Visible calendar table | No | Yes |
| Model control | Lower | Higher |

---

# FINAL HANDS-ON DASHBOARD

Build an IoT date-analysis page with:

1. Energy by Month
2. Energy by Quarter
3. Energy by Week
4. Working Day vs Weekend
5. Energy by Financial Year
6. Energy by Financial Month
7. Holiday slicer
8. Year slicer

Use the **custom Date table** for these visuals.

---

# KNOWLEDGE CHECK

### 1. What does Auto Date/Time provide?
A convenient automatically generated date hierarchy.

### 2. Why use a custom Date table?
To control the calendar and add business-specific fields.

### 3. Which table belongs on the 1 side?
The Date table.

### 4. Which table belongs on the * side?
The fact/event table.

### 5. Why sort MonthName by MonthNumber?
To prevent alphabetical month ordering.

### 6. Give three examples of information that a custom calendar can contain.
Examples:
- Working day
- Holiday
- Financial year
- Financial month
- Week number

---

# FINAL MODEL

```text
                   DimDate_Practice
                         |
                         | 1
                         |
                         | *
                         v
                 FactIoTReadings
                         |
                 ┌───────┴───────┐
                 ▼               ▼
             DimDevice        DimSite
```

# Key takeaway

Auto Date/Time is convenient for basic date analysis.

A custom Date table gives you control over the calendar structure and lets you represent business-specific concepts such as financial periods, working days, holidays and week numbers.

This lab intentionally uses **no DAX**. All exercises are performed using Power BI Desktop, Power Query, Model view, relationships, sorting, filters, slicers and report visuals.
