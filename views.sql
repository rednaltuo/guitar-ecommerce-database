-- In this document: view definitions


-- Aggregate sales data for each product, including the total number of units sold and total revenue generated
CREATE VIEW product_sales_summary AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    SUM(op.quantity) AS total_units_sold,
    SUM(op.quantity * op.price_at_order) AS total_revenue
FROM
    products p
JOIN
    order_products op ON p.id = op.product_id
JOIN
    orders o ON op.order_id = o.id
WHERE
    o.order_status = 'Completed'
GROUP BY
    p.id, p.name;


-- List all reviews left by customers, including product names and ratings.
CREATE VIEW customer_reviews AS
SELECT
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    p.name AS product_name,
    r.rating,
    r.comment,
    r.created_at
FROM
    reviews r
JOIN
    customers c ON r.customer_id = c.id
JOIN
    products p ON r.product_id = p.id;


-- Aggregate sales made on each day, useful for daily sales reports
CREATE VIEW daily_sales AS
SELECT
    DATE(o.placed_at) AS sales_date,
    COUNT(DISTINCT o.id) AS total_orders,
    SUM(op.quantity * op.price_at_order) AS total_sales
FROM
    orders o
JOIN
    order_products op ON o.id = op.order_id
WHERE
    o.order_status = 'Completed'
GROUP BY
    DATE(o.placed_at);


-- Show products that have received the highest average ratings from customers
CREATE VIEW top_rated_products AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    AVG(r.rating) AS average_rating
FROM
    products p
JOIN
    reviews r ON p.id = r.product_id
GROUP BY
    p.id, p.name
HAVING
    AVG(r.rating) >= 4.0;