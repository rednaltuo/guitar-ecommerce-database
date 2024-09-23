-- In this document: triggers for automating tasks

-- When one or more products are updated, check the quantity available to determine if a stock alert needs to be produced
DELIMITER $$
CREATE TRIGGER `check_stock_levels`
AFTER UPDATE ON `products`
FOR EACH ROW
BEGIN
    IF NEW.quantity_available <= NEW.low_stock_threshold THEN
        INSERT INTO `stock_alerts` (`product_id`, `alert_message`, `created_at`)
        VALUES (NEW.id, CONCAT('Low stock alert: ', NEW.name, ' is running low. Only ', NEW.quantity_available, ' units left.'), NOW());
    END IF;
END$$
DELIMITER ;