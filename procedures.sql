-- In this document: stored procedures


-- Handle the creation of a new customer
DELIMITER $$

CREATE PROCEDURE register_customer(
    IN first_name VARCHAR(64),
    IN last_name VARCHAR(64),
    IN email_address VARCHAR(255),
    IN password CHAR(60), -- Hashed
    IN shipping_address TEXT
)
BEGIN
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM customers WHERE email_address = email_address) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already registered';
    ELSE
        -- Insert new customer
        INSERT INTO customers (first_name, last_name, email_address, password, shipping_address)
        VALUES (first_name, last_name, email_address, password, shipping_address);
    END IF;
END$$

DELIMITER ;