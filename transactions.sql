-- In this document: pre-configured transactions


-- Handle the transaction when customers place an order, rolling back if customer's funds or product stock are insufficient
START TRANSACTION;

-- Calculate the total cost of the order based on the products and their quantities
SET @total_order_price = (
    SELECT SUM(op.quantity * p.price)
    FROM order_products op
    JOIN products p ON op.product_id = p.id
    WHERE op.order_id = @order_id -- The order ID is known
);

-- Check if the customer has enough funds in their wallet
SET @wallet_balance = (
    SELECT wallet_balance
    FROM customers
    WHERE id = @customer_id -- The customer ID is known
);

IF @wallet_balance < @total_order_price THEN
    ROLLBACK;
    SELECT 'Insufficient funds in wallet' AS error_message;
    LEAVE;
END IF;

-- Check if each product has enough stock for the quantities ordered
SET @insufficient_stock = (
    SELECT COUNT(*)
    FROM order_products op
    JOIN products p ON op.product_id = p.id
    WHERE op.order_id = @order_id
    AND op.quantity > p.quantity_available
);

IF @insufficient_stock > 0 THEN
    ROLLBACK;
    SELECT 'Insufficient stock for one or more products' AS error_message;
    LEAVE;
END IF;

-- Deduct the quantity of each product in the order from available stock
UPDATE products p
JOIN order_products op ON p.id = op.product_id
SET p.quantity_available = p.quantity_available - op.quantity
WHERE op.order_id = @order_id;

-- Deduct the total order price from the customer's wallet balance
UPDATE customers
SET wallet_balance = wallet_balance - @total_order_price
WHERE id = @customer_id;

COMMIT;

SELECT 'Order placed successfully' AS success_message;