DROP DATABASE IF EXISTS dat_mon_online;

CREATE DATABASE dat_mon_online;
USE dat_mon_online;



-- USER ----
CREATE TABLE NguoiDung (
    id int NOT NULL AUTO_INCREMENT, 
    PRIMARY KEY (id),
    username VARCHAR(30) NOT NULL UNIQUE CHECK (LENGTH(username) > 3),
    email VARCHAR(100),														-- 30 => 100 --
    sdt VARCHAR(30),
    matkhau VARCHAR(30) NOT NULL CHECK (LENGTH(matkhau) > 3),
    ngayDK DATETIME DEFAULT CURRENT_TIMESTAMP,						
    anhDaiDien VARCHAR(300),													-- 30 => 300 --
    anhBia VARCHAR(300)														-- 30 => 300 --
);

-- ### Khach Hang(NguoiDung) ------
CREATE TABLE KhachHang(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES NguoiDung(id) ON DELETE CASCADE ON UPDATE CASCADE,
    hovaten VARCHAR(100),
    ngaysinh DATE,
    diemTichLuy int NOT NULL DEFAULT 0,
    hangTV VARCHAR(30) NOT NULL DEFAULT 'member'
);

CREATE TABLE ThongTinLienHe(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    sdt VARCHAR(30) NOT NULL,
    hoten VARCHAR(100) NOT NULL,
    diachi VARCHAR(255) NOT NULL
);

CREATE TABLE TaiKhoanThanhToan(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    idKH int NOT NULL,
    FOREIGN KEY (id) REFERENCES NguoiDung(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ngayLK DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tenChuTK int NOT NULL,
    soTienDaTT int NOT NULL DEFAULT 0
);

CREATE TABLE TaiKhoanNganHang(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES TaiKhoanThanhToan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    stk VARCHAR(100) NOT NULL,
    tenNganHang VARCHAR(30) NOT NULL
);

CREATE TABLE ViDienTu(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES TaiKhoanThanhToan(id) ON DELETE CASCADE ON UPDATE CASCADE,
    sdt VARCHAR(30) NOT NULL,
    tenVDT VARCHAR(30) NOT NULL
);

-- ### Nha Hang(NguoiDung) ------
CREATE TABLE NhaHang(
    id int NOT NULL,
    -- UNIQUE (id),
    FOREIGN KEY (id) REFERENCES NguoiDung(id) ON DELETE CASCADE ON UPDATE CASCADE,
    ten VARCHAR(100) NOT NULL,
    diachi VARCHAR(100) NOT NULL,
    thoigianHD VARCHAR(100) NOT NULL,
    thongtinChung VARCHAR(255),
    trangthaiHD BOOLEAN NOT NULL DEFAULT 0,
    tongDon int NOT NULL DEFAULT 0,
    anhGioiThieu VARCHAR(255),
    soReview int NOT NULL DEFAULT 0 CHECK (soReview >= 0),
    rating double CHECK (rating >= 1 AND rating <= 5),
    idNHchinh int,
    FOREIGN KEY (idNHchinh) REFERENCES NhaHang(id) ON DELETE SET NULL ON UPDATE CASCADE
);


-- MON AN ------
CREATE TABLE MonAn(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    tenMon VARCHAR(100) NOT NULL,
    giaBan int NOT NULL,
    moTa VARCHAR(255) NOT NULL DEFAULT '',
    isTopping BOOLEAN NOT NULL,
    soBan int NOT NULL DEFAULT 0 CHECK (soBan >= 0),
    soReview int NOT NULL DEFAULT 0 CHECK (soReview >= 0),
    rating int CHECK (rating >= 1 AND rating <= 5),
    trangThai BOOLEAN NOT NULL DEFAULT 1,
    type VARCHAR(30) NOT NULL
);

CREATE TABLE AnhMonAn(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    dir VARCHAR(100) NOT NULL
);

CREATE TABLE GiaMonChinh(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    size VARCHAR(30) NOT NULL,
    gia int NOT NULL CHECK (gia >= 0)
);


-- DON HANG -----
CREATE TABLE DonHang(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
	idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idKH int NOT NULL,
    FOREIGN KEY (idKH) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    tgDatHang DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tgNhanHang DATETIME,
	CHECK (tgNhanHang > tgDatHang),
    giaTri int NOT NULL CHECK (giaTri > 0),
    payState BOOLEAN NOT NULL DEFAULT 0,
    soTienKM int NOT NULL DEFAULT 0 CHECK (soTienKM > 0),
    phuongThucVC VARCHAR(100) NOT NULL,
    hotenNgNhan VARCHAR(100) NOT NULL,
    sdtNgNhan VARCHAR(30) NOT NULL,
    diachiNgNhan VARCHAR(100) NOT NULL
);


-- MON AN DA ORDER -----
CREATE TABLE MonAnDaOrder(
	id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
	idMonChinh int NOT NULL,
    FOREIGN KEY (idMonChinh) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idDonHang int NOT NULL,
    FOREIGN KEY (idDonHang) REFERENCES DonHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    soLuong int NOT NULL CHECK (soLuong > 0),
    ghiChu VARCHAR(255) NOT NULL DEFAULT '',
    sizeMonChinh VARCHAR(30) NOT NULL,
    giaMonChinh int NOT NULL CHECK (giaMonChinh > 0),
    tongTien int NOT NULL CHECK (tongTien > 0)
);


-- HOA DON -----
CREATE TABLE HoaDon(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
	idDonHang int NOT NULL,
    FOREIGN KEY (idDonHang) REFERENCES DonHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    tgThanhToan DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    thanhToanOnl BOOLEAN NOT NULL
);

-- ### Hoa Don Online(Hoa Don) -----
CREATE TABLE HoaDonOnline(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES HoaDon(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idTKTT int NOT NULL,
    FOREIGN KEY (idTKTT) REFERENCES TaiKhoanThanhToan(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- CHUONG TRINH KHUYEN MAI -------
CREATE TABLE CTKM(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    tgBatDau DATETIME NOT NULL,
    tgKetThuc DATETIME NOT NULL,
	CHECK (tgKetThuc > tgBatDau),
    tgApDungTrongTuan VARCHAR(255) NOT NULL DEFAULT '',
    minValue int NOT NULL DEFAULT 0,
    isLimited BOOLEAN NOT NULL,
    soLuongPhatHanh int CHECK (soLuongPhatHanh > 0),
    soLuongConLai int,
	CHECK (soLuongConLai <= soLuongPhatHanh)
);

CREATE TABLE Voucher(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    idCTKM int NOT NULL,
    FOREIGN KEY (idCTKM) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    isUsed BOOLEAN NOT NULL DEFAULT 0,
    idDonHang int,
    idKH int,
    soTienGiam int CHECK (soTienGiam >= 0)
);

-- ### Chuong trinh khuyen mai toan he thong(CTKM) -------
CREATE TABLE CTKMheThong(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    phiVC int NOT NULL DEFAULT 0,
    dichvuVC VARCHAR(100) NOT NULL DEFAULT '',
    diemTichLuy int NOT NULL DEFAULT 0,
    ptThanhToan VARCHAR(100) NOT NULL DEFAULT ''
);

-- ### Chuong trinh khuyen mai nha hang(CTKM) -------
CREATE TABLE CTKMnhaHang(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    diemTichLuyToiThieu int NOT NULL DEFAULT 0
);

-- ### Chuong trinh giam co dinh(CTKM) ------
CREATE TABLE CTKMgiamCoDinh(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    soTienGiam int NOT NULL CHECK (soTienGiam > 0)
);

-- ### Chuong trinh giam theo %(CTKM) ------
CREATE TABLE CTKMgiamTheoPhanTram(
    id int NOT NULL,
    UNIQUE (id),
    FOREIGN KEY (id) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    phanTramGiam int NOT NULL CHECK (phanTramGiam > 0 and phanTramGiam <= 1),
    phamViGiam VARCHAR(10) NOT NULL DEFAULT 'total' CHECK (phamViGiam='total' or phamViGiam='vanchuyen' or phamViGiam='food'),
    giamToiDa int
);


-- DICH VU VAN CHUYEN ------
CREATE TABLE DichVuVanChuyen(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    tenDichVu VARCHAR(100) NOT NULL,
    soDonVC int NOT NULL DEFAULT 0 CHECK (soDonVC >= 0),
    ngayHopTac DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rating int CHECK (rating >= 1 AND rating <= 5)
);

-- ### Don vi van chuyen -------
CREATE TABLE DonViVanChuyen(
    id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (id),
    idDichVu int NOT NULL,
    FOREIGN KEY (idDichVu) REFERENCES DichVuVanChuyen(id) ON DELETE CASCADE ON UPDATE CASCADE,
    hoten VARCHAR(255) NOT NULL,
    sdt VARCHAR(30) NOT NULL,
    bienso VARCHAR(255) NOT NULL,
    trangthai BOOLEAN NOT NULL DEFAULT 1
);


-- RELATIONSHIP BETWEEN KHACH HANG VS. NHA HANG
CREATE TABLE KHtheoDoiNH(
    idKH int NOT NULL,
    FOREIGN KEY (idKH) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DiemTichLuy(
    idKH int NOT NULL,
    FOREIGN KEY (idKH) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    diemTichLuy int NOT NULL DEFAULT 0 CHECK (diemTichLuy >= 0)
);

CREATE TABLE DanhGiaNhaHang(
	id int NOT NULL auto_increment,
     PRIMARY KEY (id),
    idKH int NOT NULL,
    FOREIGN KEY (idKH) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    rating int NOT NULL CHECK (rating >= 1 AND rating <= 5),
    binhluan VARCHAR(255) NOT NULL DEFAULT '',
    tg DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- RELATIONSHIP BETWEEN MON AN VS. NHA HANG VS. KHACH HANG
CREATE TABLE DanhGiaMonAn(
    idKH int NOT NULL,
    FOREIGN KEY (idKH) REFERENCES KhachHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idMonAn int NOT NULL,
    FOREIGN KEY (idMonAn) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    rating int NOT NULL CHECK (rating >= 1 AND rating <= 5),
    binhluan VARCHAR(255) NOT NULL DEFAULT '',
    tg DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- RELATIONSHIP BETWEEN CTKM
CREATE TABLE CTKMcungLuc(
    idCTKM1 int NOT NULL,
    FOREIGN KEY (idCTKM1) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idCTKM2 int NOT NULL,
    FOREIGN KEY (idCTKM2) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE
);


-- RELATIONSHIP BETWEEN CTKM VS. NHA HANG
CREATE TABLE NHapDungCTKM(
    idNH int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES NhaHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idCTKM int NOT NULL,
    FOREIGN KEY (idNH) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE DieuKienDatMonCTKM(
    idCTKM int NOT NULL,
    FOREIGN KEY (idCTKM) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idMonChinh int NOT NULL,
    FOREIGN KEY (idCTKM) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    sizeToiThieu VARCHAR(30) NOT NULL,
    soLuong int NOT NULL DEFAULT 1 CHECK (soLuong > 0)
);


-- RELATIONSHIP BETWEEN CTKM VS. DON HANG
CREATE TABLE DonHangApDungCTKM(
    idCTKM int NOT NULL,
    FOREIGN KEY (idCTKM) REFERENCES CTKM(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idDonHang int NOT NULL,
    FOREIGN KEY (idCTKM) REFERENCES DonHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    soTienGiam int NOT NULL CHECK (soTienGiam >= 0)
);

CREATE TABLE DonHangApDungVoucher(
    idVoucher int NOT NULL,
    FOREIGN KEY (idVoucher) REFERENCES Voucher(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idDonHang int NOT NULL,
    FOREIGN KEY (idDonHang) REFERENCES DonHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    soTienGiam int NOT NULL CHECK (soTienGiam >= 0)
);

-- MON DA ORDER GOM CO MON CHINH VA TOPPING
CREATE TABLE MonGomCoTopping(
    id int NOT NULL,
    FOREIGN KEY (id) REFERENCES MonAnDaOrder(id) ON DELETE CASCADE ON UPDATE CASCADE, 
    idTopping int NOT NULL,
    FOREIGN KEY (idTopping) REFERENCES MonAn(id) ON DELETE CASCADE ON UPDATE CASCADE,
    soLuong int NOT NULL DEFAULT 1 CHECK (soLuong > 0),
    giaThanh int NOT NULL CHECK (giaThanh >= 0)
);


-- TAI XE VAN CHUYEN DON HANG
CREATE TABLE TaiXeVanChuyenDH(
    idDonHang int NOT NULL,
    FOREIGN KEY (idDonHang) REFERENCES DonHang(id) ON DELETE CASCADE ON UPDATE CASCADE,
    idTaiXe int NOT NULL,
    FOREIGN KEY (idTaiXe) REFERENCES DonViVanChuyen(id) ON DELETE CASCADE ON UPDATE CASCADE,
    phiVC int NOT NULL,
    rating int CHECK (rating >= 1 AND rating <= 5),
    trangThai int NOT NULL DEFAULT 0
);