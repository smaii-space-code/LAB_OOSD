/* ==========================================================
   QuanLyDuLichVanHoaViet - Qu?n lý ??t tour và d?ch v? du l?ch
   SQL Server. Ch?y trong SSMS. Script t?o l?i DB t? ??u (xóa b?ng c?).
   D?a trên c?u trúc c?a QuanLyDoAnBenhNhan.sql
   ========================================================== */
IF DB_ID(N'QuanLyDuLichVanHoaViet') IS NULL CREATE DATABASE QuanLyDuLichVanHoaViet;
GO
USE QuanLyDuLichVanHoaViet;
GO

/* ---------- Xóa b?ng c? (th? t? ng??c khóa ngo?i) ---------- */
IF OBJECT_ID('ThanhToan','U') IS NOT NULL DROP TABLE ThanhToan;
IF OBJECT_ID('HoaDon','U') IS NOT NULL DROP TABLE HoaDon;
IF OBJECT_ID('ChiTietDonDatDichVu','U') IS NOT NULL DROP TABLE ChiTietDonDatDichVu;
IF OBJECT_ID('DonDatDichVu','U') IS NOT NULL DROP TABLE DonDatDichVu;
IF OBJECT_ID('PhieuDangKyHoatDong','U') IS NOT NULL DROP TABLE PhieuDangKyHoatDong;
IF OBJECT_ID('LichHenTuVan','U') IS NOT NULL DROP TABLE LichHenTuVan;
IF OBJECT_ID('PhieuDatTour','U') IS NOT NULL DROP TABLE PhieuDatTour;
IF OBJECT_ID('HoSoKhachHang','U') IS NOT NULL DROP TABLE HoSoKhachHang;
IF OBJECT_ID('KhachHang','U') IS NOT NULL DROP TABLE KhachHang;
IF OBJECT_ID('LoaiHoatDong','U') IS NOT NULL DROP TABLE LoaiHoatDong;
IF OBJECT_ID('DichVuDuLich','U') IS NOT NULL DROP TABLE DichVuDuLich;
IF OBJECT_ID('HuongDanVien','U') IS NOT NULL DROP TABLE HuongDanVien;
IF OBJECT_ID('NhanVien','U') IS NOT NULL DROP TABLE NhanVien;
IF OBJECT_ID('VungMien','U') IS NOT NULL DROP TABLE VungMien;
GO

/* ---------- Danh m?c ---------- */
CREATE TABLE VungMien(            -- T??ng ???ng b?ng Khoa
    MaVung   varchar(20)   NOT NULL PRIMARY KEY,
    TenVung  nvarchar(100) NOT NULL UNIQUE
);
CREATE TABLE HuongDanVien(        -- T??ng ???ng b?ng BacSi
    MaHDV      varchar(20)   NOT NULL PRIMARY KEY,
    HoTen      nvarchar(120) NOT NULL,
    MaVung     varchar(20)   NOT NULL,
    DienThoai  varchar(20)   NULL,
    CONSTRAINT FK_HDV_VungMien FOREIGN KEY(MaVung) REFERENCES VungMien(MaVung)
);
CREATE TABLE NhanVien(            -- Nhân viên sale, t? v?n, thu ngân...
    MaNV       varchar(20)   NOT NULL PRIMARY KEY,
    HoTen      nvarchar(120) NOT NULL,
    VaiTro     nvarchar(50)  NOT NULL,
    DienThoai  varchar(20)   NULL
);
CREATE TABLE DichVuDuLich(        -- T??ng ???ng b?ng Thuoc
    MaDichVu   varchar(20)   NOT NULL PRIMARY KEY,
    TenDichVu  nvarchar(120) NOT NULL,
    DonViTinh  nvarchar(40)  NOT NULL,
    DonGia     decimal(18,2) NOT NULL CHECK(DonGia >= 0)
);
CREATE TABLE LoaiHoatDong(        -- T??ng ???ng b?ng LoaiXetNghiem (Các ho?t ??ng tr?i nghi?m v?n hoá)
    MaLoaiHD      varchar(20)   NOT NULL PRIMARY KEY,
    TenHoatDong   nvarchar(120) NOT NULL UNIQUE,
    ChiPhi        decimal(18,2) NOT NULL CHECK(ChiPhi >= 0)
);
GO

/* ---------- Khách hàng - H? s? (Th? thành viên) ---------- */
CREATE TABLE KhachHang(           -- T??ng ???ng b?ng BenhNhan
    MaKH       varchar(20)   NOT NULL PRIMARY KEY,
    HoTen      nvarchar(120) NOT NULL,
    NgaySinh   date          NOT NULL,
    DiaChi     nvarchar(250) NOT NULL,
    DienThoai  varchar(20)   NOT NULL,
    Anh        varbinary(max) NULL      -- ?nh ??i di?n
);
CREATE TABLE HoSoKhachHang(       -- T??ng ???ng b?ng HoSoBenhAn
    MaHoSo      varchar(20)   NOT NULL PRIMARY KEY,
    MaKH        varchar(20)   NOT NULL,
    MaNV        varchar(20)   NOT NULL,      -- NV t? v?n l?p h? s?/th?
    NgayCap     date          NOT NULL,
    NgayHetHan  date          NOT NULL,
    PhiGiaNhap  decimal(18,2) NOT NULL DEFAULT 0 CHECK(PhiGiaNhap >= 0),
    TrangThai   nvarchar(30)  NOT NULL DEFAULT N'Còn h?n',
    CONSTRAINT CK_HoSo_Ngay CHECK(NgayHetHan >= NgayCap),
    CONSTRAINT CK_HoSo_TrangThai CHECK(TrangThai IN (N'Còn h?n',N'H?t h?n')),
    CONSTRAINT FK_HoSo_KH FOREIGN KEY(MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT FK_HoSo_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
);
GO

/* ---------- Giao d?ch ??t Tour ---------- */
CREATE TABLE PhieuDatTour(        -- T??ng ???ng b?ng PhieuKham
    SoPhieuDat   varchar(30)   NOT NULL PRIMARY KEY,
    MaHoSo       varchar(20)   NOT NULL,
    MaHDV        varchar(20)   NOT NULL,
    MaVung       varchar(20)   NOT NULL,
    NgayKhoiHanh datetime      NOT NULL,
    LoaiTour     nvarchar(40)  NOT NULL,
    NhuCau       nvarchar(500) NULL,
    SoLuongKhach decimal(3,1)  NULL CHECK(SoLuongKhach BETWEEN 1 AND 100), -- Ánh x? ThanNhiet
    TuyenDuong   varchar(10)   NULL,                                       -- Ánh x? HuyetAp
    GhiChuTour   nvarchar(500) NULL,                                       -- Ánh x? ChanDoan
    GiaTour      decimal(18,2) NOT NULL DEFAULT 0 CHECK(GiaTour >= 0),   
    TrangThai    nvarchar(30)  NOT NULL DEFAULT N'?ang di?n ra',
    CONSTRAINT CK_PhieuDat_Loai CHECK(LoaiTour IN (N'Tour tr?n gói',N'Tour thi?t k? riêng')),
    CONSTRAINT CK_PhieuDat_TT CHECK(TrangThai IN (N'?ang di?n ra',N'?ã k?t thúc')),
    CONSTRAINT FK_PhieuDat_HoSo FOREIGN KEY(MaHoSo) REFERENCES HoSoKhachHang(MaHoSo),
    CONSTRAINT FK_PhieuDat_HDV FOREIGN KEY(MaHDV) REFERENCES HuongDanVien(MaHDV),
    CONSTRAINT FK_PhieuDat_Vung FOREIGN KEY(MaVung) REFERENCES VungMien(MaVung)
);
CREATE TABLE LichHenTuVan(         -- T??ng ???ng b?ng LichHenKham (L?ch h?n t? v?n/ch?m sóc KH)
    SoLichHen  varchar(30)   NOT NULL PRIMARY KEY,
    MaHoSo     varchar(20)   NOT NULL,
    MaNV       varchar(20)   NOT NULL,
    NgayHen    datetime      NOT NULL,
    Quy        nvarchar(10)  NOT NULL,
    GhiChu     nvarchar(250) NULL,
    TrangThai  nvarchar(30)  NOT NULL DEFAULT N'?ã h?n',
    CONSTRAINT CK_LichHen_Quy CHECK(Quy IN (N'Quý 1',N'Quý 2',N'Quý 3',N'Quý 4')),
    CONSTRAINT CK_LichHen_TT CHECK(TrangThai IN (N'?ã h?n',N'?ã t? v?n',N'H?y')),
    CONSTRAINT FK_LichHen_HoSo FOREIGN KEY(MaHoSo) REFERENCES HoSoKhachHang(MaHoSo),
    CONSTRAINT FK_LichHen_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
);
CREATE TABLE PhieuDangKyHoatDong(  -- T??ng ???ng b?ng PhieuXetNghiem (??ng ký tr?i nghi?m v?n hoá)
    SoPhieuHD    varchar(30)   NOT NULL PRIMARY KEY,
    SoPhieuDat   varchar(30)   NOT NULL,
    MaLoaiHD     varchar(20)   NOT NULL,
    NgayThamGia  date          NOT NULL,
    KetQua       nvarchar(500) NULL,
    CONSTRAINT FK_PhieuHD_PD FOREIGN KEY(SoPhieuDat) REFERENCES PhieuDatTour(SoPhieuDat),
    CONSTRAINT FK_PhieuHD_Loai FOREIGN KEY(MaLoaiHD) REFERENCES LoaiHoatDong(MaLoaiHD)
);
CREATE TABLE DonDatDichVu(         -- T??ng ???ng b?ng ToaThuoc (??t d?ch v? thêm: thuê xe, ?n u?ng...)
    SoDon        varchar(30)   NOT NULL PRIMARY KEY,
    SoPhieuDat   varchar(30)   NOT NULL,
    MaHDV        varchar(20)   NOT NULL,
    NgayLap      date          NOT NULL,
    LuuY         nvarchar(250) NULL,
    GhiChuKhac   nvarchar(250) NULL,
    TongTien     decimal(18,2) NOT NULL DEFAULT 0 CHECK(TongTien >= 0),
    CONSTRAINT FK_Don_PD FOREIGN KEY(SoPhieuDat) REFERENCES PhieuDatTour(SoPhieuDat),
    CONSTRAINT FK_Don_HDV FOREIGN KEY(MaHDV) REFERENCES HuongDanVien(MaHDV)
);
CREATE TABLE ChiTietDonDatDichVu(  -- T??ng ???ng b?ng ChiTietToaThuoc
    SoDon      varchar(30)   NOT NULL,
    MaDichVu   varchar(20)   NOT NULL,
    SoLuong    int           NOT NULL CHECK(SoLuong > 0),
    QuyCach    nvarchar(200) NOT NULL,
    DonGia     decimal(18,2) NOT NULL CHECK(DonGia >= 0),
    ThanhTien  AS (CONVERT(decimal(18,2), SoLuong * DonGia)) PERSISTED,
    PRIMARY KEY(SoDon, MaDichVu),
    CONSTRAINT FK_CTDon_Don FOREIGN KEY(SoDon) REFERENCES DonDatDichVu(SoDon),
    CONSTRAINT FK_CTDon_DV FOREIGN KEY(MaDichVu) REFERENCES DichVuDuLich(MaDichVu)
);
GO

/* ---------- Thanh toán ---------- */
CREATE TABLE HoaDon(
    SoHoaDon     varchar(30)   NOT NULL PRIMARY KEY,
    SoPhieuDat   varchar(30)   NOT NULL UNIQUE,
    MaNV         varchar(20)   NOT NULL,
    NgayLap      datetime      NOT NULL,
    TienTour     decimal(18,2) NOT NULL CHECK(TienTour >= 0),
    TienDichVu   decimal(18,2) NOT NULL CHECK(TienDichVu >= 0),
    TienHoatDong decimal(18,2) NOT NULL CHECK(TienHoatDong >= 0),
    TongTien     AS (CONVERT(decimal(18,2), TienTour + TienDichVu + TienHoatDong)) PERSISTED,
    TrangThai    nvarchar(30)  NOT NULL DEFAULT N'Ch?a thanh toán',
    CONSTRAINT CK_HoaDon_TT CHECK(TrangThai IN (N'Ch?a thanh toán',N'?ã thanh toán')),
    CONSTRAINT FK_HoaDon_PD FOREIGN KEY(SoPhieuDat) REFERENCES PhieuDatTour(SoPhieuDat),
    CONSTRAINT FK_HoaDon_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
);
CREATE TABLE ThanhToan(
    MaThanhToan    varchar(30)   NOT NULL PRIMARY KEY,
    SoHoaDon       varchar(30)   NOT NULL,
    NgayThanhToan  datetime      NOT NULL,
    HinhThuc       nvarchar(30)  NOT NULL,
    SoTien         decimal(18,2) NOT NULL CHECK(SoTien > 0),
    CONSTRAINT CK_ThanhToan_HT CHECK(HinhThuc IN (N'Ti?n m?t',N'Chuy?n kho?n',N'Th?',N'Ví ?i?n t?')),
    CONSTRAINT FK_ThanhToan_HD FOREIGN KEY(SoHoaDon) REFERENCES HoaDon(SoHoaDon)
);
GO

CREATE INDEX IX_PhieuDatTour_HoSo ON PhieuDatTour(MaHoSo, NgayKhoiHanh);
CREATE INDEX IX_KhachHang_HoTen ON KhachHang(HoTen);
CREATE INDEX IX_KhachHang_DienThoai ON KhachHang(DienThoai);
GO

/* ==================== DU LIEU DEMO ==================== */
INSERT INTO VungMien(MaVung,TenVung) VALUES
('V01',N'V?n hoá B?c B?'),('V02',N'V?n hoá Trung B?'),('V03',N'V?n hoá Nam B?');

INSERT INTO HuongDanVien(MaHDV,HoTen,MaVung,DienThoai) VALUES
('HDV01',N'Nguy?n V?n Hùng','V01','0903000001'),
('HDV02',N'Tr?n Th? Lan','V02','0903000002'),
('HDV03',N'Lê Minh Quân','V03','0903000003');

INSERT INTO NhanVien(MaNV,HoTen,VaiTro,DienThoai) VALUES
('NV01',N'Ph?m Thu Hà',N'Ch?m sóc khách hàng','0901000001'),
('NV02',N'Võ Hoàng Nam',N'Thu ngân','0901000002'),
('NV03',N'?? Ng?c Anh',N'T? v?n viên','0901000003');

INSERT INTO DichVuDuLich(MaDichVu,TenDichVu,DonViTinh,DonGia) VALUES
('DV01',N'Thuê xe ??p d?o ph? c?',N'Chi?c',50000),
('DV02',N'Thuê trang ph?c truy?n th?ng',N'B?',150000),
('DV03',N'B?a ?n ??c s?n ??a ph??ng',N'Ph?n',250000),
('DV04',N'Thuê xích lô',N'Gi?',100000),
('DV05',N'Ch?p ?nh l?u ni?m',N'Gói',500000),
('DV06',N'Thuê xe 16 ch?',N'Ngày',1500000);

INSERT INTO LoaiHoatDong(MaLoaiHD,TenHoatDong,ChiPhi) VALUES
('HD01',N'Xem Múa R?i N??c',120000),
('HD02',N'Giao l?u C?ng Chiêng Tây Nguyên',150000),
('HD03',N'Nghe Ca Hu? trên sông H??ng',80000),
('HD04',N'Tham quan ??n Tháp Ch?m',200000);

INSERT INTO KhachHang(MaKH,HoTen,NgaySinh,DiaChi,DienThoai) VALUES
('KH001',N'Nguy?n V?n An','1985-03-12',N'12 Lê L?i, Q1, TP.HCM','0911000001'),
('KH002',N'Tr?n Th? Bích','1972-07-25',N'45 Nguy?n Hu?, Q1, TP.HCM','0911000002'),
('KH003',N'Lê Hoàng Phúc','2015-11-02',N'88 Cách M?ng Tháng 8, Q3, TP.HCM','0911000003'),
('KH004',N'Ph?m Qu?c Khánh','1990-01-30',N'7 Hai Bà Tr?ng, Q1, TP.HCM','0911000004');

INSERT INTO HoSoKhachHang(MaHoSo,MaKH,MaNV,NgayCap,NgayHetHan,PhiGiaNhap,TrangThai) VALUES
('HS001','KH001','NV01','2026-02-10','2027-02-10',200000,N'Còn h?n'),
('HS002','KH002','NV01','2026-03-05','2027-03-05',200000,N'Còn h?n'),
('HS003','KH003','NV03','2026-06-18','2027-06-18',200000,N'Còn h?n'),
('HS004','KH004','NV03','2025-09-01','2026-09-01',200000,N'H?t h?n');

INSERT INTO PhieuDatTour(SoPhieuDat,MaHoSo,MaHDV,MaVung,NgayKhoiHanh,LoaiTour,NhuCau,SoLuongKhach,TuyenDuong,GhiChuTour,GiaTour,TrangThai) VALUES
('PD001','HS001','HDV01','V01','2026-10-05 08:30',N'Tour tr?n gói',N'Mu?n tham quan di tích c?',15.0,'HN-NB',N'Khách ?oàn gia ?ình',1500000,N'?ã k?t thúc'),
('PD002','HS002','HDV02','V02','2026-10-12 09:15',N'Tour tr?n gói',N'Ngh? d??ng k?t h?p v?n hoá',2.0,'DN-HA',N'Khách VIP',2000000,N'?ang di?n ra'),
('PD003','HS001','HDV01','V01','2026-10-20 08:00',N'Tour thi?t k? riêng',N'Tr?i nghi?m làng ngh?',5.0,'HN-BN',N'L?ch trình linh ho?t',0,N'?ã k?t thúc'),
('PD004','HS003','HDV03','V03','2026-10-25 10:00',N'Tour tr?n gói',N'Du l?ch sinh thái mi?t v??n',10.0,'HCM-CT',N'?oàn có tr? em',1200000,N'?ang di?n ra');

INSERT INTO PhieuDangKyHoatDong(SoPhieuHD,SoPhieuDat,MaLoaiHD,NgayThamGia,KetQua) VALUES
('PHD001','PD001','HD01','2026-10-05',N'Khách r?t hài lòng v?i show di?n'),
('PHD002','PD002','HD03','2026-10-12',N'Th?i ti?t t?t, tr?i nghi?m thu?n l?i');

INSERT INTO DonDatDichVu(SoDon,SoPhieuDat,MaHDV,NgayLap,LuuY,GhiChuKhac,TongTien) VALUES
('DD001','PD001','HDV01','2026-10-05',N'Chu?n b? ?? xe cho ?oàn',NULL,500000),
('DD002','PD002','HDV02','2026-10-12',N'Khách ?n chay',N'Có ng??i cao tu?i',300000);

INSERT INTO ChiTietDonDatDichVu(SoDon,MaDichVu,SoLuong,QuyCach,DonGia) VALUES
('DD001','DV01',10,N'Xe m?i, ?ã ki?m tra l?p',50000),
('DD001','DV05',1,N'Ch?p hình 2 ti?ng bu?i sáng',500000),
('DD002','DV03',2,N'Menu chay ??c bi?t',150000);

INSERT INTO HoaDon(SoHoaDon,SoPhieuDat,MaNV,NgayLap,TienTour,TienDichVu,TienHoatDong,TrangThai) VALUES
('HD001','PD001','NV02','2026-10-05 11:00',1500000,500000,120000,N'?ã thanh toán'),
('HD002','PD002','NV02','2026-10-12 12:00',2000000,300000,80000,N'Ch?a thanh toán');

INSERT INTO ThanhToan(MaThanhToan,SoHoaDon,NgayThanhToan,HinhThuc,SoTien) VALUES
('TT001','HD001','2026-10-05 11:10',N'Ti?n m?t',1500000),
('TT002','HD001','2026-10-05 11:12',N'Chuy?n kho?n',620000),
('TT003','HD002','2026-10-12 12:10',N'Th?',1000000);

INSERT INTO LichHenTuVan(SoLichHen,MaHoSo,MaNV,NgayHen,Quy,GhiChu,TrangThai) VALUES
('LH001','HS001','NV01','2026-10-20 08:00',N'Quý 4',N'T? v?n tour l? h?i cu?i n?m',N'?ã t? v?n'),
('LH002','HS001','NV01','2027-01-15 08:30',N'Quý 1',N'T? v?n tour du xuân 2027',N'?ã h?n'),
('LH003','HS002','NV03','2026-12-10 09:00',N'Quý 4',N'Ch?m sóc sau chuy?n ?i',N'?ã h?n');
GO

/* Ki?m tra nhanh */
SELECT 'VungMien' T, COUNT(*) N FROM VungMien UNION ALL SELECT 'KhachHang',COUNT(*) FROM KhachHang
UNION ALL SELECT 'HoSoKhachHang',COUNT(*) FROM HoSoKhachHang UNION ALL SELECT 'PhieuDatTour',COUNT(*) FROM PhieuDatTour
UNION ALL SELECT 'HoaDon',COUNT(*) FROM HoaDon;
GO