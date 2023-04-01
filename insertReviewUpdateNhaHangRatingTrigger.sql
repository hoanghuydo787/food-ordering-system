drop trigger if exists insertReviewUpdateNhaHangRating;
delimiter &&
create trigger insertReviewUpdateNhaHangRating
after insert on DanhGiaNhaHang
for each row
begin
	if new.id = (select max(id) from DanhGiaNhaHang) then
		set @soLuotCu = (select soReview from NhaHang where NhaHang.id = new.idNH);
		set @ratingCu = (select rating from NhaHang where NhaHang.id = new.idNH);
        set @soLuotMoi = @soLuotCu + 1;
        set @ratingMoi = (@ratingCu * @soLuotCu + new.rating) / @soLuotMoi;
        
        update NhaHang
        set soReview = @soLuotMoi
        where id = new.idNH;
        
        update NhaHang
        set rating = @ratingMoi
        where id = new.idNH;
	end if;
end;
&&
delimiter ;

select * from nhahang where id = 10060;
insert into DanhGiaNhaHang(idKH, idNH, rating) values (10000, 10060, 5);
select * from nhahang where id = 10060;

select * from nhahang where id = 10075;
insert into DanhGiaNhaHang(idKH, idNH, rating) values (10010, 10075, 1);
select * from nhahang where id = 10075;
