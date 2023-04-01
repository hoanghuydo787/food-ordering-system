drop procedure if exists deleteMonAn;
DELIMITER $$
create procedure deleteMonAn(in id int) 
BEGIN
    DECLARE message varchar(100) DEFAULT 'delete success';
    if id is null then
        SET message = "ID Mon An: missing";
    elseif (SELECT COUNT(*) FROM monan WHERE monan.id = id) = 0 THEN
        set message = "ID Mon An: khong ton tai";
    else
        DELETE FROM monan WHERE monan.id = id;
    end if;
      
    SELECT message;
END; $$
DELIMITER ;

call deleteMonAn(1);-- success
call deleteMonAn(10);-- fail