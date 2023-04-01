drop view if exists Dish_of_Res;
CREATE VIEW Dish_of_Res AS
SELECT tenMon, monan.rating, nhahang.ten as tenNH, nhahangchinh.ten as tenNHChinh
FROM monan, nhahang, nhahang as nhahangchinh
WHERE monan.idNH = nhahang.id AND nhahang.idNHchinh = nhahangchinh.id;

DROP function if exists CalcAvgRatingofDish;
DELIMITER //
CREATE FUNCTION CalcAvgRatingofDish (main_res_name  varchar(100), dish_name varchar(100))
RETURNS float
READS SQL DATA
DETERMINISTIC
BEGIN
	DECLARE count INT DEFAULT 0;
	DECLARE sum int8 DEFAULT 0;
	DECLARE rating INTEGER;
	DECLARE mon, nh, nhchinh VARCHAR(100);
    DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT * FROM Dish_of_Res;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	OPEN cur;
	label: LOOP
	FETCH cur INTO mon, rating, nh, nhchinh;
	IF done = 1 THEN LEAVE label;
	END IF;
	IF (mon = dish_name AND nhchinh = main_res_name) THEN
	SET count = count + 1;
	SET sum = sum + rating;
	END IF;
	END LOOP;
	CLOSE cur;
	IF (count = 0) THEN
    RETURN -1;
    END IF;
	RETURN sum/count;
END//
DELIMITER ;

SELECT CalcAvgRatingofDish ('Cetirizine Hydrochloride', 'com them');
select AVG(rating)
FROM dish_of_res
where tenNHChinh = 'Cetirizine Hydrochloride' and tenMon = 'com them';