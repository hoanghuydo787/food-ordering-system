-- Retrieve All Dish Info by Restaurant
-- Retrieve All Dish Info by Restaurant
DROP PROCEDURE IF EXISTS getDishInfo;
DELIMITER //
CREATE PROCEDURE getDishInfo(IN para_idNH INT,
							 IN para_tenNH VARCHAR(100),
                             IN para_minratingNH INT,
                             IN para_minsoBan INT,
                             IN para_minratingMon INT,
                             IN para_tenMon varchar(100),
                             IN max_value INT,
                             IN min_value INT,
                             IN para_trangthai tinyint,
                             IN para_topping tinyint,
                             IN para_type varchar(30),
                             IN sortColNum VARCHAR(50),
                             IN dir CHAR(5)
                             )
BEGIN
	SELECT  monan.id as id,
            nhahang.id as idNH,
			nhahang.ten as tenNH,
			diachi,
			nhahang.rating as ratingNH,
			soBan,
			monan.soReview as soReview,
			monan.rating as ratingMon,
			tenMon,
			giaBan,
			trangThai,
			isTopping,
			type,
			moTa
	FROM monan, nhahang
	WHERE monan.idNH = nhahang.id
		AND IF (para_idNH is NULL, 1, idNH = para_idNH)
        -- AND IF (para_tenNH = '', nhahang.ten = nhahang.ten, nhahang.ten = para_tenNH)
		AND IF (para_minratingNH is NULL, 1, nhahang.rating >= para_minratingNH)
        -- AND IF (para_minsoBan is NULL, soBan = soBan, soBan >= para_minsoBan)
		AND IF (para_minratingMon is NULL, 1, monan.rating is not null and monan.rating >= para_minratingMon)
        AND IF (para_tenMon is NULL, 1, POSITION(para_tenMon IN tenMon) <> 0)
        AND IF (max_value is NULL, 1, giaBan <= max_value)
        AND IF (min_value is NULL, 1, giaBan >= min_value)
        -- AND IF (para_trangthai is NULL, trangThai = trangThai, trangThai = para_trangthai)
        AND IF (para_topping is NULL, 1, isTopping = para_topping)
        AND IF (para_type is NULL, 1, type = para_type)
	ORDER BY CASE WHEN dir = 'ASC' OR dir is NULL THEN
        CASE
           WHEN sortColNum = 'ratingNH' THEN ratingNH
           WHEN sortColNum = 'soBan' THEN soBan
           WHEN sortColNum = 'soReview' THEN monan.soReview
           WHEN sortColNum = 'ratingMon' THEN ratingMon
           WHEN sortColNum = 'giaBan' THEN giaBan
           WHEN sortColNum = 'idNH' THEN idNH
           ELSE monan.id
        END
	END ASC 
    , CASE WHEN dir = 'DESC' THEN
        CASE
           WHEN sortColNum = 'ratingNH' THEN ratingNH
           WHEN sortColNum = 'soBan' THEN soBan
           WHEN sortColNum = 'soReview' THEN monan.soReview
           WHEN sortColNum = 'ratingMon' THEN ratingMon
           WHEN sortColNum = 'giaBan' THEN giaBan
           WHEN sortColNum = 'idNH' THEN idNH
           ELSE monan.id
        END
    END DESC;
END //
DELIMITER ;

CALL getDishInfo(null, null, null, null, null, null, null, null, null, null, null, null, null);
CALL getDishInfo(10070, null, null, null, null, null, null, 200000, null, null, null, null, null);
CALL getDishInfo(null, null, null, null, null, null, 500000, 200000, null, null, null, null, null);
CALL getDishInfo(NULL,null,null,null,null,'com',null,200000,null,null,NULL,'giaBan','DESC');
