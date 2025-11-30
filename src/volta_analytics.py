import psycopg2
import pandas as pd
import plotly.express as px

# 1. DATABASE CONNECTION
DB_CONFIG = {
    "host": "34.63.247.27",
    "database": "postgres",
    "user": "guest",
    "password": "iLoveDataBases365247!!",
    "port": "5432"
}

def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

# 2. ANALYSIS & VISUALIZATION

def run_analytics():
    conn = get_db_connection()
    if not conn:
        return

    # VISUALIZATION 1: Monthly Revenue Trend (Line Chart)

    query_1 = """
    SELECT
        TO_CHAR(sale_date, 'YYYY-MM') AS month_year,
        SUM(sale_price) AS total_revenue
    FROM SalesOrders
    GROUP BY TO_CHAR(sale_date, 'YYYY-MM')
    ORDER BY month_year;
    """

    # Execute query and load into Pandas DataFrame
    df_revenue = pd.read_sql(query_1, conn)

    # Create Plotly Line Chart
    fig1 = px.line(
        df_revenue,
        x='month_year',
        y='total_revenue',
        title='Volta Motors: Monthly Revenue Trend (2023)',
        markers=True,
        labels={'month_year': 'Month', 'total_revenue': 'Revenue (USD)'}
    )
    fig1.show()

    # VISUALIZATION 2: Inventory Value by Plant (Bar Chart)

    query_2 = """
    SELECT
        pl.name AS plant_name,
        SUM(i.quantity * p.cost) AS total_inventory_value
    FROM Inventory i
    JOIN Parts p ON i.part_id = p.part_id
    JOIN Plants pl ON i.plant_id = pl.plant_id
    GROUP BY pl.name
    ORDER BY total_inventory_value DESC;
    """

    df_inventory = pd.read_sql(query_2, conn)

    # Create Plotly Bar Chart
    fig2 = px.bar(
        df_inventory,
        x='plant_name',
        y='total_inventory_value',
        title='Total Value of Inventory Assets by Plant',
        color='total_inventory_value',
        labels={'plant_name': 'Manufacturing Plant', 'total_inventory_value': 'Value (USD)'}
    )
    fig2.show()

    # VISUALIZATION 3: Sales Performance by Model (Pie Chart)

    query_3 = """
    SELECT
        v.model_name,
        COUNT(s.order_id) AS units_sold,
        SUM(s.sale_price) AS total_revenue
    FROM SalesOrders s
    JOIN Vehicles v ON s.vin = v.vin
    GROUP BY v.model_name;
    """

    df_models = pd.read_sql(query_3, conn)

    # Create Plotly Pie Chart
    fig3 = px.pie(
        df_models,
        values='total_revenue',
        names='model_name',
        title='Revenue Share by Vehicle Model',
        hover_data=['units_sold']
    )
    fig3.update_traces(textposition='inside', textinfo='percent+label')
    fig3.show()

    conn.close()
    print("Analysis Complete.")

if __name__ == "__main__":
    run_analytics()
