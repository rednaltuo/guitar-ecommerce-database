-- In this document: table definitions, primary and foreign keys


-- Represent customers of the e-commerce platform
CREATE TABLE `customers` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(64) NOT NULL,
    `last_name` VARCHAR(64) NOT NULL,
    `email_address` VARCHAR(255) NOT NULL UNIQUE,
    `password` CHAR(60) NOT NULL,
    `shipping_address` TEXT,
    `wallet_balance` DECIMAL(8,2) NOT NULL DEFAULT 0,
    PRIMARY KEY(`id`)
);

-- Represent cards associated to customers of the platform
CREATE TABLE `cards` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `customer_id` INT UNSIGNED NOT NULL,
    `last_four_digits` CHAR(4) NOT NULL,
    `expiration_date` DATE,
    `payment_token` VARCHAR(255),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`) ON DELETE CASCADE
);

-- Represent products that the platform sells
CREATE TABLE `products` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(256) NOT NULL,
    `category` ENUM('Electric', 'Acoustic', 'Acoustic-Electric', 'Bass') NOT NULL,
    `price` DECIMAL(8,2) NOT NULL,
    `quantity_available` INT UNSIGNED NOT NULL DEFAULT 0,
    `low_stock_threshold` INT UNSIGNED DEFAULT 5,
    PRIMARY KEY(`id`)
);

-- Represent product reviews left by customers
CREATE TABLE `reviews` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `product_id` INT UNSIGNED NOT NULL,
    `customer_id` INT UNSIGNED NOT NULL,
    `rating` TINYINT NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
    `comment` TEXT,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`),
    UNIQUE (`product_id`, `customer_id`) -- prevent duplicate reviews by same customer
);

-- Represent orders placed by customers
CREATE TABLE `orders` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `customer_id` INT UNSIGNED NOT NULL,
    `payment_method` ENUM('wallet', 'card') NOT NULL,
    `order_status` ENUM('Pending', 'Shipped', 'Completed', 'Cancelled') NOT NULL,
    `shipping_address` TEXT NOT NULL,
    `placed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`customer_id`) REFERENCES `customers`(`id`)
);

-- Represent notifications related to products' stock levels
CREATE TABLE `stock_alerts` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `product_id` INT UNSIGNED NOT NULL,
    `alert_message` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
);

-- Associate orders with the products ordered
CREATE TABLE `order_products` (
    `order_id` INT UNSIGNED NOT NULL,
    `product_id` INT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `price_at_order` DECIMAL(8,2) NOT NULL, -- capture price at the time of order
    PRIMARY KEY(`order_id`, `product_id`),
    FOREIGN KEY(`order_id`) REFERENCES `orders`(`id`) ON DELETE CASCADE,
    FOREIGN KEY(`product_id`) REFERENCES `products`(`id`)
);
