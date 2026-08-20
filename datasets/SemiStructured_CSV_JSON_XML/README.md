# Power BI Lab: CSV with Embedded JSON and XML

## Purpose

Use these two CSV files to practise handling semi-structured data in Power Query.

Files:

1. `iot_embedded_json.csv`
2. `iot_embedded_xml.csv`

Each file has 100 IoT records.

The important feature is that the JSON or XML is stored **inside a CSV column**.

---

# 1. CSV with Embedded JSON

File:

`iot_embedded_json.csv`

Columns:

| Column | Type | Purpose |
|---|---|---|
| Timestamp | Date/Time | Reading timestamp |
| DeviceID | Text | Device identifier |
| SiteID | Text | Site identifier |
| Status | Text | Device status |
| PayloadJSON | Text | Embedded JSON document |

Example value in `PayloadJSON`:

```json
{"temperature":72.4,"humidity":61.8,"energyKWh":5.42,"battery":87,"alert":null,"location":{"zone":"Z2","floor":1}}
```

Notice that the CSV is still a normal table. Only the `PayloadJSON` column contains structured JSON.

---

# 2. Import the JSON CSV into Power BI

Open:

**Power BI Desktop**

Select:

**Home → Get Data → Text/CSV**

Select:

`iot_embedded_json.csv`

Choose:

**Transform Data**

Power Query opens.

---

# 3. Convert the JSON Text

Select:

`PayloadJSON`

Then use:

**Transform → Parse → JSON**

Power Query converts the JSON text into a structured value.

You may see:

```text
Record
```

in the column.

This means Power Query has recognized the JSON object.

---

# 4. Expand the JSON Record

Select the expand button on the `PayloadJSON` column.

Select:

- temperature
- humidity
- energyKWh
- battery
- alert
- location

Click:

**OK**

You now have columns such as:

```text
temperature
humidity
energyKWh
battery
alert
location
```

---

# 5. Expand the Nested Location Object

The `location` column may still contain:

```text
Record
```

Select its expand button.

Choose:

- zone
- floor

Click:

**OK**

Final structure:

```text
Timestamp
DeviceID
SiteID
Status
temperature
humidity
energyKWh
battery
alert
location.zone
location.floor
```

Rename them to:

```text
Temperature
Humidity
EnergyKWh
Battery
Alert
Zone
Floor
```

---

# 6. Set Data Types

Use:

- Timestamp → Date/Time
- DeviceID → Text
- SiteID → Text
- Status → Text
- Temperature → Decimal Number
- Humidity → Decimal Number
- EnergyKWh → Decimal Number
- Battery → Whole Number
- Alert → Text
- Floor → Whole Number
- Zone → Text

---

# 7. CSV with Embedded XML

File:

`iot_embedded_xml.csv`

Columns:

```text
Timestamp
DeviceID
SiteID
Status
PayloadXML
```

Example:

```xml
<Reading>
  <Temperature unit="C">72.4</Temperature>
  <Humidity unit="percent">61.8</Humidity>
  <Energy unit="kWh">5.42</Energy>
  <Battery>87</Battery>
  <Alert>HighTemp</Alert>
  <Location>
    <Zone>Z2</Zone>
    <Floor>1</Floor>
  </Location>
</Reading>
```

---

# 8. Import the XML CSV

Power BI:

**Home → Get Data → Text/CSV**

Select:

`iot_embedded_xml.csv`

Choose:

**Transform Data**

---

# 9. Parse the XML Column

Select:

`PayloadXML`

Use:

**Transform → Parse**

If your Power Query version does not expose the required XML parsing command directly for a text column, use Power Query M.

Example pattern:

```powerquery
Xml.Document([PayloadXML])
```

This converts the XML text into a structured XML document.

The exact resulting navigation can vary by Power BI/Power Query version.

---

# 10. Expand the XML Structure

The XML contains:

```text
Reading
├── Temperature
├── Humidity
├── Energy
├── Battery
├── Alert
└── Location
    ├── Zone
    └── Floor
```

Extract the values into columns:

```text
Temperature
Humidity
EnergyKWh
Battery
Alert
Zone
Floor
```

---

# 11. Important XML Concept

XML can contain:

### Elements

```xml
<Temperature>72.4</Temperature>
```

### Attributes

```xml
<Temperature unit="C">72.4</Temperature>
```

The value is:

```text
72.4
```

The attribute is:

```text
C
```

When transforming XML, students should understand the difference between element values and attributes.

---

# 12. Hands-on Challenge

Create two Power Query queries:

```text
IoT_JSON
IoT_XML
```

For both:

1. Import the CSV.
2. Identify the embedded semi-structured column.
3. Parse the JSON/XML.
4. Expand the structure.
5. Rename columns.
6. Set correct data types.
7. Validate the resulting table.

Expected final structure:

```text
Timestamp
DeviceID
SiteID
Status
Temperature
Humidity
EnergyKWh
Battery
Alert
Zone
Floor
```

---

# 13. Compare JSON and XML

| JSON | XML |
|---|---|
| Object-oriented structure | Element-oriented structure |
| Uses `{ }` | Uses tags |
| Key/value pairs | Elements and attributes |
| Compact | More verbose |
| Common in APIs | Common in enterprise/legacy systems |

---

# 14. Validation

After transformation, check:

**View → Column quality**

Check:

- Valid
- Errors
- Empty

Also check:

**Column distribution**

and:

**Column profile**

Confirm that:

- Temperature is numeric
- Humidity is numeric
- EnergyKWh is numeric
- Battery is numeric
- Floor is numeric
- DeviceID remains text

---

# 15. Final Exercise

Create a single clean IoT table from the JSON source.

Create another clean IoT table from the XML source.

Then compare:

```text
JSON Source
     ↓
Parse
     ↓
Expand
     ↓
Clean
     ↓
Typed IoT Table
```

and:

```text
XML Source
     ↓
Parse
     ↓
Expand
     ↓
Clean
     ↓
Typed IoT Table
```

Finally append the two cleaned tables only if their business meaning and column structure are intentionally compatible.

## Learning objective

Students should finish this exercise knowing how to take a normal CSV file containing a JSON/XML text column and turn the embedded semi-structured information into analysis-ready Power BI columns.
