drop trigger if exists insertHoaDonCongDiemTichLuy;
delimiter &&
create trigger insertHoaDonCongDiemTichLuy
after insert on HoaDon
for each row
begin
	if new.id = (select max(id) from HoaDon) then
		set @diemTichLuy = (select giaTri from DonHang where id = new.idDonHang) / 1000;
        set @idKhachHang = (select id from KhachHang where KhachHang.id = (select idKH from DonHang where id = new.idDonHang)); 
        set @diemTichLuyCu = (select diemTichLuy from KhachHang where id = @idKhachHang);
        set @diemTichLuyMoi = @diemTichLuyCu + @diemTichLuy;

        update KhachHang
        set diemTichLuy = @diemTichLuyMoi
        where id = @idKhachHang;
	end if;
end;
&&
delimiter ;

select * from khachhang where id = 10000;
insert into DonHang(idNH, idKH, tgNhanHang, giaTri, phuongThucVC, hotenNgNhan, sdtNgNhan, diachiNgNhan) values(10070, 10000, '2023-01-01 00:00:00', 500000, 'ghn', 'Nguyen Van A', '0987654321', 'dhbk');
insert into HoaDon(idDonHang, thanhToanOnl) values(1, 0);
select * from khachhang where id = 10000;
