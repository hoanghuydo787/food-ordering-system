drop trigger if exists insertHoaDonCongDiemTichLuy;
delimiter &&
create trigger insertHoaDonCongDiemTichLuy
after insert on HoaDon
for each row
begin
	if new.id = last_insert_id() then
		set @diemTichLuy = (select giaTri from DonHang where HoaDon.idDonHang = DonHang.id) / 1000;
        set @idKhachHang = (select idKH from DonHang where HoaDon.idDonHang = DonHang.id); 
        set @diemTichLuyCu = (select diemTichLuy from KhachHang where @idKhachHang = id);
        set @diemTichLuyMoi = @diemTichLuyCu + @diemTichLuy;
        
        update KhachHang
        set diemTichLuy = @diemTichLuyMoi
        where id = @idKhachHang;
	end if;
end;
&&
delimiter ;

select last_insert_id();
insert into DonHang(idNH, idKH, tgNhanHang, giaTri, phuongThucVC, hotenNgNhan, sdtNgNhan, diachiNgNhan) values(10070, 10000, '2023-01-01 00:00:00', 500000, 'ghn', 'Nguyen Van A', '0987654321', 'dhbk');
select last_insert_id();
insert into HoaDon(idDonHang, thanhToanOnl) values(1, 0);