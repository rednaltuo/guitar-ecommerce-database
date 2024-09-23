-- Customer login
PREPARE stmt FROM 'SELECT id, first_name, last_name FROM customers WHERE email_address = ? AND password = ?';
SET @email = 'customer@example.com';
SET @password = 'hashed_password';
EXECUTE stmt USING @email, @password;
DEALLOCATE PREPARE stmt;

-- Search products based on the user's input
PREPARE stmt FROM 'SELECT id, name, price FROM products WHERE name LIKE ?';
SET @search_term = 'search_term';
EXECUTE stmt USING @search_term;
DEALLOCATE PREPARE stmt;