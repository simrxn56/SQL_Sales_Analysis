--  1. Analyzing Product Category Performance
SELECT 
	p.category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 2. Segment Customers using RFM (Recency, Frequency and Monetory)
WITH customer_metrics AS (
	SELECT
		u.user_id,
        u.full_name,
        MAX(o.order_date) AS last_order,
        COUNT(o.order_id) AS frequency,
        SUM(p.price * oi.quantity) AS monetory
	FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY u.user_id
)
SELECT *,
		TO_DAYS('2026-01-15') - TO_DAYS(last_order) AS recency_days
FROM customer_metrics;

-- 3. Monthly Sales Trend
SELECT
	DATE_FORMAT(o.order_date, "%Y-%m") AS month,
    SUM(oi.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- 4. Returning Customer by Most Orders
SELECT
	u.user_id,
    u.full_name,
    COUNT(DISTINCT o.order_id) as total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
HAVING total_orders > 1
ORDER BY total_orders DESC;

-- 5. Average Order Value
SELECT
	ROUND(SUM(p.price * oi.quantity) * 1.0 / COUNT(DISTINCT oi.order_id), 2) AS avg_order_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- 6. Churned Customers
SELECT
	u.user_id,
    u.full_name,
    MAX(o.order_date) AS last_purchase,
    DATEDIFF('2026-01-16', MAX(o.order_date)) AS days_since_last_purchase
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
HAVING days_since_last_purchase > 180;

-- 7. Top 10 Customers by Lifetime Value
SELECT
	u.user_id,
    u.full_name,
    SUM(p.price * oi.quantity) AS lifetime_value
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.full_name
ORDER BY lifetime_value DESC
LIMIT 10;

-- 8. Pareto Analysis (Revenue Concentration)
WITH revenue_per_user AS(
	SELECT
		u.user_id,
        SUM(oi.quantity * p.price) as revenue
	FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY u.user_id
)
ranked AS(
	SELECT *,
		SUM(revenue) OVER() AS total_revenue,
        SUM(revenue) OVER(ORDER BY revenue DESC) AS running_revenue
	FROM revenue_per_user
)
SELECT 
	user_id,
    revenue,
    ROUND(running_revenue / total_revenue * 100, 2) as cumulative_percentage
FROM ranked
ORDER BY revenue DESC;

-- 9. Monthly Growth
WITH monthly AS(
SELECT
	DATE_FORMAT(o.order_date, "%Y-%m") AS month,
    SUM(oi.quantity * p.price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY month
)
SELECT
	month,
    revenue,
    LAG(revenue) OVER(ORDER BY month) as prev_month_revenue,
    ROUND(
		(revenue - LAG(revenue) OVER(ORDER BY month))
        / LAG(revenue) OVER(ORDER BY month) * 100, 2
    ) AS growth_percentage
FROM monthly;
