-- In this document: queries that users will commonly run on the database


-- Find customer information by email
SELECT id, first_name, last_name, email_address, shipping_address, wallet_balance
FROM customers
WHERE email_address = 'customer@example.com';

-- Find products by name
SELECT id, name, price, quantity_available
FROM products
WHERE name = 'Izzocaster';

-- Find products by category
SELECT id, name, price, quantity_available
FROM products
WHERE category = 'Electric';

-- Find the average rating of a product
SELECT AVG(r.rating) AS average_rating
FROM reviews
WHERE product_id = 123;

-- Find all orders placed by a customer
SELECT
    o.id AS order_id,
    o.placed_at,
    p.name AS product_name,
    op.quantity,
    op.line_total,
    SUM(op.line_total) OVER (PARTITION BY o.id) AS total_order_cost
FROM
    orders o
JOIN
    order_products op ON o.id = op.order_id
JOIN
    products p ON op.product_id = p.id
WHERE
    o.customer_id = 123
ORDER BY
    o.placed_at DESC;

-- Create a new order
INSERT INTO orders (customer_id, payment_method, order_status)
VALUES (123, 'wallet', 'Pending');

-- After creating an order, this query inserts the ordered products into the order_products table
INSERT INTO order_products (order_id, product_id, quantity, price_at_order)
VALUES (123, 456, 3, 100);

-- Update order status
UPDATE orders
SET order_status = 'Shipped'
WHERE id = 123;

-- Update product stock after purchase
UPDATE products
SET quantity_available = quantity_available - 3
WHERE id = 123;