drop procedure if exists insertMonAn;
DELIMITER $$
create procedure insertMonAn(
  in p_idNH int,
  in p_tenMon varchar(100),
  in p_giaBan int,
  in p_moTa varchar(255),
  in p_isTopping boolean,
  in p_type varchar(30)
) 
BEGIN
	DECLARE message varchar(100) DEFAULT 'insert success';
	if p_idNH is null then 
		begin
			set message = 'ID Nha Hang: missing';
		end;
	elseif p_tenMon = '' then 
		begin
			set message = 'Ten Mon: missing';
		end;
	elseif p_giaBan is null then 
		begin
			set message = 'Gia Ban: missing';
		end;
    ELSEIF p_giaBan < 0 THEN
    	SET message = 'Gia Ban: be hon 0';
	elseif p_isTopping is null then 
		begin
			set message = 'Topping hay Mon Chinh: missing';
		end;
	elseif p_type = '' then 
		begin
			set message = 'The Loai: missing';
		end;
	else
		begin
			if (select count(*) from nhahang where nhahang.id = p_idNH) = 0 then
				begin
					set message = 'ID Nha Hang: khong ton tai';
				end;
			else
				begin
					insert into dat_mon_online.monan (idNH, tenMon, giaBan, moTa, isTopping, type)
					values (p_idNH, p_tenMon, p_giaBan, p_moTa,p_isTopping, p_type);
				end; 
			end if;
		end;
	end if;
    SELECT message;
END; $$
DELIMITER ;


call insertMonAn(10065, 'rau muong xao', 10000, '', 0, 'thuc an chay'); -- success
call insertMonAn(10068, 'suon chua ngot', 20000, '', 0, 'thuc an man'); -- success
call insertMonAn(10070, 'com trang', 30000, '', 0, 'thuc an chay'); -- success
call insertMonAn(null, 'pizza', 20000, '', 0, 'thuc an man'); -- fail
call insertMonAn(10000, 'pizza', 20000, '', 0, 'thuc an man'); -- fail
call insertMonAn(10060, '', 20000, '', 0, 'thuc an man'); -- fail