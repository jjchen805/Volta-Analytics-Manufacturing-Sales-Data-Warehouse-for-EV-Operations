# Volta Analytics — Manufacturing & Sales Data Pipeline (SQL + Python)

### Overview  
**Volta Analytics** simulates a full-scale **data warehouse and analytics system** for an electric vehicle (EV) manufacturer.  
It integrates **PostgreSQL database design**, **SQL-based KPIs**, and **Python-powered visualizations** to enable data-driven insights across **manufacturing, inventory, and sales operations**.

---

## System Architecture

**Core Components**
1. **Database Design:** Normalized PostgreSQL schema (3NF) modeling suppliers, parts, plants, vehicles, customers, sales, and service operations.  
2. **SQL Analytics Pipeline:** Predefined queries to compute KPIs such as:
   - Monthly revenue trend  
   - Total inventory asset value by plant  
   - Revenue share by vehicle model  
3. **Python Automation & Visualization:**  
   - Uses `psycopg2` for SQL execution and `pandas` for data transformation  
   - Creates interactive visual dashboards using `Plotly`  

**Architecture Flow:**  
PostgreSQL → psycopg2/Pandas → DataFrames → Plotly Dashboards

---

## Database Schema

The relational schema models key operational entities:

| Table | Description |
|--------|--------------|
| `Plants` | Factory information and production capacity |
| `Suppliers` | External component providers and quality ratings |
| `Parts` | Component catalog with supplier references |
| `Inventory` | Stock levels per plant and part |
| `Vehicles` | VIN-level manufacturing records |
| `Customers` | Buyer details |
| `SalesOrders` | Sales transactions with historical pricing |
| `ServiceRecords` | Maintenance history for each vehicle |

All tables are linked through **foreign key constraints** and optimized for **referential integrity**.  
The database follows **ACID properties** to prevent race conditions during concurrent inventory updates.

---

## Sample Analytics Queries

### 1. Monthly Revenue Trend
```sql
SELECT
  TO_CHAR(sale_date, 'YYYY-MM') AS month_year,
  SUM(sale_price) AS total_revenue
FROM SalesOrders
GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY month_year;
```
### 2. Inventory Value by Plant
```sql
SELECT
  pl.name AS plant_name,
  SUM(i.quantity * p.cost) AS total_inventory_value
FROM Inventory i
JOIN Parts p ON i.part_id = p.part_id
JOIN Plants pl ON i.plant_id = pl.plant_id
GROUP BY pl.name
ORDER BY total_inventory_value DESC;
```
### 3. Revenue Share by Vehicle Model
```sql
SELECT
  v.model_name,
  COUNT(s.order_id) AS units_sold,
  SUM(s.sale_price) AS total_revenue
FROM SalesOrders s
JOIN Vehicles v ON s.vin = v.vin
GROUP BY v.model_name;
```
---
## Future Extensions
	•	Integrate IoT/sensor data for real-time production or maintenance analytics.
	•	Build predictive maintenance model using service record frequencies.
	•	Deploy interactive dashboards using Streamlit or Dash for real-time KPI monitoring.
	•	Incorporate machine learning forecasting for production and sales planning.
