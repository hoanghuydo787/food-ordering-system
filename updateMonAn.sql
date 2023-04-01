drop procedure if exists updateMonAn;
DELIMITER $$
create procedure updateMonAn(
      in id int,
      in idNH int,
      in tenMon varchar(100),
      in giaBan int,
      in isTopping boolean,
      in type varchar(30),
      in moTa varchar(255),
      IN trangThai boolean
) 
BEGIN
	DECLARE message varchar(100) DEFAULT 'update success';
    if id is null then
    	SET message = "ID Mon An: missing";
    elseif (SELECT COUNT(*) FROM monan WHERE monan.id = id) = 0 THEN
    	set message = "ID Mon An: khong ton tai";
	elseif idNH is not null and (SELECT COUNT(*) FROM nhahang WHERE nhahang.id = 0) then 
		begin
			set message = 'ID Nha Hang: khong ton tai';
		end;
    ELSEIF giaBan is not null and giaBan < 0 THEN
    	SET message = 'Gia Ban: be hon 0';
	else
		begin
			if idNH is not null then
				UPDATE monan SET monan.idNH = idNH WHERE monan.id = id;
			end IF;
            
			if tenMon <> '' THEN
                UPDATE monan SET monan.tenMon = tenMon WHERE monan.id = id;
            end IF; 
            
            IF giaBan is not null then
            	UPDATE monan SET monan.giaBan = giaBan WHERE monan.id = id;
            end IF;
            
            IF isTopping is not null then
            	UPDATE monan SET monan.isTopping = isTopping WHERE monan.id = id;
            end if;
            
            IF type <> '' then
            	UPDATE monan SET monan.type = type WHERE monan.id = id;
            end if;
            
            IF moTa <> '' then
            	UPDATE monan SET monan.moTa = moTa WHERE monan.id = id;
            end if;
            
            if trangThai is not null THEN
            	UPDATE monan SET monan.trangThai = trangThai WHERE monan.id = id;
			end if;
		end;
	end if;
    SELECT message;
END; $$
DELIMITER ;

call updateMonAn(1, 10065, 'tom hap bia', 10000, 0, 'do uong co con', 'day la mot mon an', 0);-- success
call updateMonAn(null, 10068, 'ca chua xao', 10000, 0, 'thuc an man', '', 1);-- fail
call updateMonAn(3, 10068, '', null, 0, 'do uong co con', '', 1);-- success