# 📊 Profitability and Sales Optimization

## 🎯 Project Objective
*   **Primary Business Objective:** Despite high overall order volumes, the company lacks visibility into the true drivers of profitability. The core business objective of this project is to identify the most and least profitable product lines and customer regions to optimize future marketing initiatives and pricing strategies.

## ⚙️ Technical Objectives
*   **Data Engineering & Consolidation:** Develop a modern data warehouse using SQL Server to ingest, clean, and consolidate disparate sales data into a single source of truth for analytical reporting.
*   **Advanced Analytics:** Leverage Python to perform deep exploratory data analysis (EDA) and diagnostic modeling on the warehoused data, transforming raw transactional records into actionable profitability metrics.

---

## 🛠️ Tools & Technologies
*   **Languages & Scripts:** Python (Pandas, NumPy, Matplotlib, Seaborn, SQL Alchemy), DAX.
*   **Database & Warehousing:** SSMS (SQL Server Management Studio).
*   **Visualization & BI:** Power BI, Jupyter Notebook.
*   **Design & Planning:** Excel, Notion, Draw.io, PowerPoint, Word.
*   **Development & Version Control:** VS Code, GitHub.

---

## ❓ Key Business Questions Answered

### 1️⃣ Product & Category Profitability
These questions will help identify which products to push in marketing and which to re-price:
*   **Q1:** Which product lines are "Revenue Illusions"? Which product categories or subcategories generate the top 20% of total revenue but fall into the bottom 50% for profit margin?.
*   **Q2:** Who are the hidden gems (High Margin, Low Volume)? Are there specific product names or subcategory items that have exceptional profit margins but low overall quantity sold?.
*   **Q3:** How does product cost impact the bottom line? Is there a correlation between higher product cost items and tighter profit margins?.
*   **Q4:** Does the maintenance flag/cost cannibalize product profitability?.

### 2️⃣ Regional & Geographic Insights
These questions address the "customer regions" part of the problem statement:
*   **Q5:** Which countries are driving true profit based on average profit margin per order?.
*   **Q6:** Are there regional pricing inefficiencies for the same product categories across different countries?.
*   **Q7:** Where is our top 20% most profitable customer base concentrated geographically?.

### 3️⃣ Customer Demographics & Behavior
These questions help tailor target audiences for future marketing campaigns:
*   **Q8:** What is the profit contribution of the top 10% of customers?.
*   **Q9:** Are high-revenue customers actually profitable, or do they mostly buy low-margin products?.
*   **Q10:** Which demographic segment (derived from age groups, gender, and marital status) is the most lucrative?.
*   **Q11:** Do frequent buyers equal profitable buyers, and is there a correlation between order frequency and overall profit margin?.

### 4️⃣ Time Series & Operational Efficiency
These questions provide context on when to run campaigns and identify operational bottlenecks:
*   **Q12:** Are there seasonal profitability dips when comparing month-over-month trends for Revenue vs. Profit Margin?.
*   **Q13:** Does shipping lag (average time between order date and shipping date) correlate with specific product lines?.

---

## 🚀 Process & Methodology

### 📂 Dataset & Planning
*   **Dataset:** Random Dataset from YouTube (Data with Baraa).
*   **Planning:** Notion was used for planning and project tracking.
*   **Data Understanding:** Excel was utilized to understand the initial data.
*   **Architecture Design:** Draw.io was used for High-Level Design, Data Integration Design, Data Flow Diagram Design, and Data Schema Design.

### 🗄️ SSMS Data Warehousing & EDA
*   **Database Creation:** Built the core SQL database.
*   **Bronze Layer (Table):** Created DDL scripts and executed Data Load Procedures.
*   **Silver Layer (Table):** Created DDL scripts and executed Data Load Procedures for refined data.
*   **Gold Layer (View):** Created analytical views.
*   **EDA:** Conducted detailed Exploratory Data Analysis, creating procedures for dimension and measure report summaries, as well as ranking report summaries.

### 🐍 Python Analysis
*   Imported necessary modules and connected to SSMS using `sqlalchemy`.
*   Fetched data directly from the SSMS Gold layer.
*   Performed Data Type Validation and Date Time conversions (`pd.to_datetime`).
*   **Feature Engineering:** Calculated `total_cost`, `total_profit`, `profit_margin%`, generated `month_num` and `month_name`, derived `age` from birthdates, and calculated `shipping_lag_days`.
*   Utilized Python to solve the core business questions and generate visualizations.

---

## 📈 Power BI Development

### 📊 Dashboards Created
*   **Product and Category Profit Dashboard Page**.
*   [Dashboard Page Preview](https://github.com/omkar-2004/Profitability-and-Sales-optimization/blob/master/Dashboard/Dashboard%20Screenshots/Screenshot%202026-08-14%20153221.png)
*   **Geographic Dashboard Page**.
*   **Customer Dashboard Page**.

### 🧮 Key DAX Measures
*   `AOV = [Total Profit] / [Total Revenue]`.
*   `Average Profit = AVERAGEX(fact_sales, [Total Revenue] -RELATED(dim_products[product_cost]))`.
*   `P80 = PERCENTILE.INC(regional_profit_metric[Total_profit],0.80)`.
*   `Profit Margin = ([Total Profit] / [Total Revenue]) * 100`.
*   `Total Cost = SUMX(fact_sales, fact_sales[quantity] * RELATED(dim_products[product_cost]))`.
*   `Total Customers = DISTINCTCOUNT(dim_customers[customer_key])`.
*   `Total orders = DISTINCTCOUNT(fact_sales[order_number])`.
*   `Total Product Cost = SUMX(dim_products,dim_products[product_cost])`.
*   `Total Profit = [Total Revenue] - [Total Cost]`.
*   `Total Quantity = SUMX(fact_sales,fact_sales[quantity])`.
*   `Total Revenue = SUMX(fact_sales,[sales_amount])`.

### ➕ Custom Columns & Tables
*   **Custom Columns:** Developed columns for `Age`, `Orders Placed`, `Age Groups`, `Order Groups`, `Sales Profit Margin`, and `Shipping Lag Days`.
*   **Custom Tables:** Built summarization tables like `country Count`, `product_line_metric`, `regional_profit_metric`, and filtered tables for `top 20%` profit percentiles.

---

## 💻 Code Snippets (Python Visuals)

### Profit Contribution: Top 10% Customers vs. Others
```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

top_customers = dataset.sort_values(by='Total Profit', ascending=False)
overall_profit = dataset['Total Profit'].sum()
top_10_per_count = int(len(top_customers)* 0.10)

top_profit_sum = top_customers.head(top_10_per_count)['Total Profit'].sum()
top_10_profit = top_customers.iloc[:top_10_per_count]['Total Profit'].sum()
others_profit = top_customers.iloc[top_10_per_count:]['Total Profit'].sum()

labels = ['Top 10% ', 'Other 90%']
sizes = [top_10_profit, others_profit]
explode = (0.15, 0)

plt.figure(figsize=(10, 8), facecolor='none')
plt.pie(sizes, explode=explode, labels=labels,autopct='%1.1f%%',shadow=True, startangle=90,textprops={'color': 'white', 'fontsize': 24})
plt.title('Profit Contribution:Top 10% Customers vs. Others', fontsize=25,pad = 0,color = 'white', fontweight = 'bold')
plt.show()
```

---

### Profit Contribution: Top 10% Customers vs. Others
```python
import matplotlib.pyplot as plt
import seaborn as pd
import pandas as pd

correlation_metric = dataset[['Total Product Cost','Profit Margin']].corr(method='spearman')
plt.title('Spearman Correlation: Cost vs. Margin')
sns.heatmap(correlation_metric, annot=True, fmt = '.2f', vmin=-1, vmax= 1, cmap=sns.cubehelix_palette(as_cmap=True))
plt.yticks(rotation=45,fontsize = 6)
plt.show()
```
