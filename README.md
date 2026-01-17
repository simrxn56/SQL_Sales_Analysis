# SQL_Sales_Analysis
## Overview

This project contains a collection of SQL queries designed to analyze sales, customer behavior, and revenue trends from a relational database.
The focus is on business-oriented analytics such as product performance, customer segmentation, churn detection, growth analysis, and revenue concentration.

The project is written as a standard SQL script (not MySQL-specific) and assumes a transactional schema with users, orders, order items, and products.

---

## Objectives

- Analyze product category performance and revenue contribution

- Segment customers using RFM (Recency, Frequency, Monetary) metrics

- Track monthly sales trends and growth

- Identify returning and churned customers

- Calculate average order value and customer lifetime value

- Perform Pareto analysis on revenue distribution

---

## Database Schema Assumptions

The script assumes the following tables and relationships:

`users`

- `user_id (PK)`

- `full_name`

- `email`

- `age`

- `city`


`orders`

- `order_id (PK)`

- `user_id (FK → users.user_id)`

- `order_date`

- `total_amount`


`order_items`

- `item_id (PK)`

- `order_id (FK → orders.order_id)`

- `product_id (FK → products.product_id)`

- `quantity`

- `line_total`


`products`

- `product_id (PK)`

- `product_name`

- `category`

- `price`

---

## Queries Included
### 1. Product Category Performance

Calculates:

Total units sold per category

Total revenue per category

Orders categories by highest revenue

Purpose: Identify which product categories drive the most sales and revenue.

### 2. Customer Segmentation (RFM)

Calculates per customer:

Recency – Days since last purchase

Frequency – Number of orders

Monetary – Total spending

Purpose: Enable customer segmentation and behavioral analysis.

### 3. Monthly Sales Trend

Aggregates total revenue by month.

Purpose: Visualize revenue patterns and seasonality.

### 4. Returning Customers

Identifies customers with more than one order.

Purpose: Measure repeat customer behavior.

### 5. Average Order Value (AOV)

Computes average revenue per order.

Purpose: Evaluate order quality and pricing performance.

### 6. Churned Customers

Identifies customers whose last purchase was more than 180 days ago.

Purpose: Detect inactive or lost customers.

### 7. Top 10 Customers by Lifetime Value

Ranks customers by total revenue generated.

Purpose: Identify high-value customers.

### 8. Pareto Analysis (Revenue Concentration)

Calculates cumulative revenue contribution per customer.

Purpose: Analyze whether a small percentage of customers generate most of the revenue.

### 9. Monthly Growth Analysis

Calculates month-over-month revenue growth percentage using window functions.

Purpose: Track business growth trends.

---

## Notes & Assumptions

Dates used for recency and churn calculations are hard-coded for reproducibility.

Revenue is calculated as:

`price × quantity`

Month grouping is based on formatted order dates (YYYY-MM).

The script assumes clean relational integrity between tables.

---

## Author

Project created as a practical SQL analytics portfolio project.
