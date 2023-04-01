drop trigger if exists insertReviewUpdateNhaHangRating;
delimiter &&
create trigger insertReviewUpdateNhaHangRating
after insert on DanhGiaNhaHang
for each row
begin
	if new.id = last_insert_id() then
		set @soLuotReviewNhaHangCu = (select soReview from NhaHang where id = new.id);
		set @ratingTrungBinhNhaHangCu = (select rating from NhaHang where id = new.id);
        set @soLuotReviewNhaHangMoi = @soLuotReviewNhaHangCu + 1;
        set @ratingTrungBinhNhaHangMoi = (@ratingTrungBinhNhaHangCu * soLuotReviewNhaHangCu + rating) / soLuotReviewNhaHangMoi;
        
        update NhaHang
        set soReview = @soLuotReviewNhaHangMoi
        where id = new.idNH;
        
        update NhaHang
        set rating = @ratingTrungBinhNhaHangMoi
        where id = new.idNH;
	end if;
end;
&&
delimiter ;

select * from nhahang where id = 10060;
select last_insert_id();
(select soReview from NhaHang where NhaHang.id = 10060);
insert into DanhGiaNhaHang(idKH, idNH, rating) values (10000, 10060, 5);
select last_insert_id();
select * from nhahang where id = 10060;