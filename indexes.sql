-- In this document: index definitions


CREATE INDEX idx_customers_email ON customers (email_address);
CREATE INDEX idx_products_name ON products (name);
CREATE INDEX idx_products_category ON products (category);
CREATE INDEX idx_reviews_product_id ON reviews (product_id);
CREATE INDEX idx_orders_customer_id ON orders (customer_id);
CREATE INDEX idx_order_products_order_id_product_id ON order_products(order_id, product_id);