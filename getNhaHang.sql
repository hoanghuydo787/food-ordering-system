DROP PROCEDURE IF EXISTS getRevenueofRestaurant;
DELIMITER //
CREATE PROCEDURE getRevenueofRestaurant(IN para_ten VARCHAR(100),
										IN para_minsoReview INT,
                                        IN para_minRating INT,
                                        IN para_minSoDon INT,
                                        IN para_maxSoDon INT,
                                        IN para_minDoanhThu INT,
                                        IN para_maxDoanhThu INT,
                                        IN para_fromDate DATE,
                                        IN para_toDate DATE,
										IN $sortColNum VARCHAR(50),
										IN $dir CHAR(5)
										)
BEGIN
	SELECT  nhahang.id,
			nhahang.ten,
            nhahang.diachi,
            nhahang.soReview,
            nhahang.rating,
            COUNT(*) as soDon,
			SUM(donhang.giaTri) as doanhThu,
            if (para_fromDate is NULL, min(DATE(donhang.tgDatHang)), para_fromDate) as fromDate,
            if (para_toDate is NULL, max(DATE(donhang.tgDatHang)), para_toDate) as toDate
	FROM nhahang, donhang
	WHERE nhahang.id = donhang.idNH
		AND IF (para_ten is NULL, 1, POSITION(para_ten IN nhahang.ten))
        AND IF (para_minsoReview is NULL, 1, nhahang.soReview >= para_minsoReview)
		AND IF (para_minRating is NULL, 1, nhahang.rating >= para_minRating)
        AND IF (para_fromDate is NULL, 1, DATE(donhang.tgDatHang) >= para_fromDate)
		AND IF (para_toDate is NULL, 1, DATE(donhang.tgDatHang) <= para_toDate)
	GROUP BY nhahang.id, nhahang.ten, nhahang.diachi, nhahang.soReview, nhahang.rating
	HAVING IF(para_minSoDon is NULL, 1, soDon >= para_minSoDon)
		AND IF(para_maxSoDon is NULL, 1, soDon <= para_maxSoDon)
        AND IF(para_minDoanhThu is NULL, 1, doanhThu >= para_minDoanhThu)
        AND IF(para_maxDoanhThu is NULL, 1, doanhThu <= para_maxDoanhThu)
	ORDER BY
	CASE WHEN $dir = 'ASC' OR $dir is NULL THEN
        CASE
           WHEN $sortColNum = 'soReview' THEN soReview
           WHEN $sortColNum = 'rating' THEN rating
           ELSE nhahang.id
        END
	END ASC 
    , CASE WHEN $dir = 'DESC' THEN
        CASE
           WHEN $sortColNum = 'soReview' THEN soReview
           WHEN $sortColNum = 'rating' THEN rating
           ELSE nhahang.id
        END
    END DESC;
END //
DELIMITER ;

CALL getRevenueofRestaurant('HYDRO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
CALL getRevenueofRestaurant(NULL, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
CALL getRevenueofRestaurant(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'rating', 'ASC');