CREATE VIEW MonchinhOrder AS
SELECT tenMon, soLuong, giaMonChinh
FROM monan, monandaorder
WHERE monan.id = monandaorder.idMonChinh;

drop function if exists CalcRevenueofDish;
DELIMITER //
CREATE FUNCTION CalcRevenueofDish (dish_name varchar(100))
RETURNS int8
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE sum int8 DEFAULT 0;
	DECLARE sl, gia INTEGER;
	DECLARE mon VARCHAR(100);
    DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT * FROM MonchinhOrder;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	IF (dish_name is NULL or dish_name = '') THEN
    RETURN -1;
    END IF;
	OPEN cur;
	label: LOOP
	FETCH cur INTO mon, sl, gia;
	IF done = 1 THEN LEAVE label;
	END IF;
	IF (mon = dish_name) THEN
	SET sum = sum + (sl * gia);
	END IF;
	END LOOP;
	CLOSE cur;
	RETURN sum;
END//
DELIMITER ;

select CalcRevenueofDish ('com');
select sum(soLuong * giamonchinh)
from monchinhorder
where tenmon = 'com';