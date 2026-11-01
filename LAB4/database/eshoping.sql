IF DB_ID(N'eShoppingDB') IS NULL
CREATE DATABASE eShoppingDB;
GO
USE eShoppingDB;
GO
IF OBJECT_ID('dbo.NhatKyEmail','U') IS NOT NULL DROP TABLE dbo.NhatKyEmail;
IF OBJECT_ID('dbo.ThanhToan','U') IS NOT NULL DROP TABLE dbo.ThanhToan;
IF OBJECT_ID('dbo.ChiTietDonHang','U') IS NOT NULL DROP TABLE dbo.ChiTietDonHang;
IF OBJECT_ID('dbo.DonDatHang','U') IS NOT NULL DROP TABLE dbo.DonDatHang;
IF OBJECT_ID('dbo.ChiTietGioHang','U') IS NOT NULL DROP TABLE dbo.ChiTietGioHang;
IF OBJECT_ID('dbo.GioHang','U') IS NOT NULL DROP TABLE dbo.GioHang;
IF OBJECT_ID('dbo.BangPhiGiaoHang','U') IS NOT NULL DROP TABLE dbo.BangPhiGiaoHang;
IF OBJECT_ID('dbo.LoaiThe','U') IS NOT NULL DROP TABLE dbo.LoaiThe;
IF OBJECT_ID('dbo.LoaiPhieuDat','U') IS NOT NULL DROP TABLE dbo.LoaiPhieuDat;
IF OBJECT_ID('dbo.KhuVuc','U') IS NOT NULL DROP TABLE dbo.KhuVuc;
IF OBJECT_ID('dbo.KhachHang','U') IS NOT NULL DROP TABLE dbo.KhachHang;
GO

-- Lưu ý: Thông tin sản phẩm do Hệ thống quản lý sản phẩm quản lý (BR03, QĐ02)
-- nên không tạo bảng SanPham/NhomSanPham; chỉ lưu MaSanPham tham chiếu mềm (không có khóa ngoại).

-- 1. Bảng Khách Hàng
CREATE TABLE dbo.KhachHang (
    MaKhachHang NVARCHAR(20) NOT NULL PRIMARY KEY,
    Ho NVARCHAR(50) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    NgaySinh DATE NOT NULL,
    SoCMND_Passport NVARCHAR(20) NOT NULL,
    DiaChi NVARCHAR(250) NOT NULL,
    SoDienThoai NVARCHAR(20) NOT NULL,
    TenDangNhap NVARCHAR(50) NOT NULL,
    MatKhauHash NVARCHAR(256) NOT NULL,  -- QĐ10: lưu mật khẩu dạng băm
    Email NVARCHAR(150) NULL,            -- Không bắt buộc, dùng nhận email xác nhận
    CONSTRAINT UQ_KhachHang_TenDangNhap UNIQUE (TenDangNhap),
    CONSTRAINT UQ_KhachHang_CMND UNIQUE (SoCMND_Passport),
    CONSTRAINT CK_KhachHang_NgaySinh CHECK (NgaySinh <= CAST(GETDATE() AS DATE))
);

-- 2. Bảng Khu Vực giao hàng
CREATE TABLE dbo.KhuVuc (
    MaKhuVuc NVARCHAR(20) NOT NULL PRIMARY KEY,
    TenKhuVuc NVARCHAR(100) NOT NULL UNIQUE
);

-- 3. Bảng Loại Phiếu Đặt Hàng (thường, chuyển phát nhanh, chuyển phát nhanh trong ngày)
CREATE TABLE dbo.LoaiPhieuDat (
    MaLoaiPhieu NVARCHAR(20) NOT NULL PRIMARY KEY,
    TenLoaiPhieu NVARCHAR(100) NOT NULL UNIQUE,
    ThoiGianXuLyGio INT NOT NULL CONSTRAINT CK_LoaiPhieuDat_ThoiGian CHECK (ThoiGianXuLyGio > 0),
    NguongMienPhi DECIMAL(18,0) NULL,    -- BR09, BR10, QĐ07: NULL = không có ngưỡng miễn phí
    CONSTRAINT CK_LoaiPhieuDat_Nguong CHECK (NguongMienPhi IS NULL OR NguongMienPhi > 0)
);

-- 4. Bảng Loại Thẻ tín dụng
CREATE TABLE dbo.LoaiThe (
    MaLoaiThe NVARCHAR(20) NOT NULL PRIMARY KEY,
    TenLoaiThe NVARCHAR(50) NOT NULL UNIQUE,   -- Visa, Master, Discover, American Express
    SoChuSoThe INT NOT NULL,                   -- BR14: 16 hoặc 15
    SoChuSoCSV INT NOT NULL,                   -- BR15: 3 hoặc 4
    LePhi DECIMAL(18,0) NOT NULL CONSTRAINT DF_LoaiThe_LePhi DEFAULT(0),  -- BR17
    CONSTRAINT CK_LoaiThe_SoChuSoThe CHECK (SoChuSoThe IN (15,16)),
    CONSTRAINT CK_LoaiThe_SoChuSoCSV CHECK (SoChuSoCSV IN (3,4)),
    CONSTRAINT CK_LoaiThe_LePhi CHECK (LePhi >= 0)
);

-- 5. Bảng Phí Giao Hàng (theo khu vực và loại phiếu - BR11)
CREATE TABLE dbo.BangPhiGiaoHang (
    MaKhuVuc NVARCHAR(20) NOT NULL,
    MaLoaiPhieu NVARCHAR(20) NOT NULL,
    PhiGiaoHang DECIMAL(18,0) NOT NULL CONSTRAINT CK_BangPhi_Phi CHECK (PhiGiaoHang >= 0),
    CONSTRAINT PK_BangPhiGiaoHang PRIMARY KEY (MaKhuVuc, MaLoaiPhieu),
    CONSTRAINT FK_BangPhi_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES dbo.KhuVuc(MaKhuVuc),
    CONSTRAINT FK_BangPhi_LoaiPhieu FOREIGN KEY (MaLoaiPhieu) REFERENCES dbo.LoaiPhieuDat(MaLoaiPhieu)
);

-- 6. Bảng Giỏ Hàng (lưu theo phiên, gắn tài khoản khi đăng nhập - QĐ05)
CREATE TABLE dbo.GioHang (
    MaGioHang NVARCHAR(30) NOT NULL PRIMARY KEY,
    MaKhachHang NVARCHAR(20) NULL,
    MaPhien NVARCHAR(100) NOT NULL,
    NgayTao DATETIME NOT NULL CONSTRAINT DF_GioHang_NgayTao DEFAULT(GETDATE()),
    TrangThai BIT NOT NULL CONSTRAINT DF_GioHang_TrangThai DEFAULT(1),
    CONSTRAINT FK_GioHang_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang)
);

-- Ràng buộc: Mỗi khách hàng chỉ có một giỏ hàng đang sử dụng
CREATE UNIQUE INDEX UX_GioHang_MotGioHoatDong
ON dbo.GioHang (MaKhachHang) WHERE TrangThai = 1 AND MaKhachHang IS NOT NULL;

-- 7. Bảng Chi Tiết Giỏ Hàng
CREATE TABLE dbo.ChiTietGioHang (
    MaChiTiet NVARCHAR(35) NOT NULL PRIMARY KEY,
    MaGioHang NVARCHAR(30) NOT NULL,
    MaSanPham NVARCHAR(20) NOT NULL,     -- Tham chiếu Hệ thống quản lý sản phẩm
    SoLuong INT NOT NULL CONSTRAINT CK_CTGH_SoLuong CHECK (SoLuong > 0),
    CONSTRAINT UQ_CTGH_Gio_SanPham UNIQUE (MaGioHang, MaSanPham),
    CONSTRAINT FK_CTGH_GioHang FOREIGN KEY (MaGioHang) REFERENCES dbo.GioHang(MaGioHang)
);

-- 8. Bảng Đơn Đặt Hàng (gồm thông tin người nhận - QĐ14)
CREATE TABLE dbo.DonDatHang (
    MaDonHang NVARCHAR(30) NOT NULL PRIMARY KEY,
    MaKhachHang NVARCHAR(20) NOT NULL,   -- Người mua
    NgayDat DATETIME NOT NULL CONSTRAINT DF_DonDatHang_NgayDat DEFAULT(GETDATE()),
    HoTenNguoiNhan NVARCHAR(100) NOT NULL,
    DiaChiNguoiNhan NVARCHAR(250) NOT NULL,
    SoDienThoaiNguoiNhan NVARCHAR(20) NOT NULL,
    MaKhuVuc NVARCHAR(20) NOT NULL,
    MaLoaiPhieu NVARCHAR(20) NOT NULL,
    TongTienHang DECIMAL(18,0) NOT NULL,
    PhiGiaoHang DECIMAL(18,0) NOT NULL CONSTRAINT DF_DonDatHang_PhiGiao DEFAULT(0),
    TongGiaTri DECIMAL(18,0) NOT NULL,
    CONSTRAINT CK_DonDatHang_TongTien CHECK (TongTienHang >= 0),
    CONSTRAINT CK_DonDatHang_PhiGiao CHECK (PhiGiaoHang >= 0),
    CONSTRAINT CK_DonDatHang_TongGiaTri CHECK (TongGiaTri = TongTienHang + PhiGiaoHang),
    CONSTRAINT FK_DonDatHang_KhachHang FOREIGN KEY (MaKhachHang) REFERENCES dbo.KhachHang(MaKhachHang),
    CONSTRAINT FK_DonDatHang_KhuVuc FOREIGN KEY (MaKhuVuc) REFERENCES dbo.KhuVuc(MaKhuVuc),
    CONSTRAINT FK_DonDatHang_LoaiPhieu FOREIGN KEY (MaLoaiPhieu) REFERENCES dbo.LoaiPhieuDat(MaLoaiPhieu)
);

-- 9. Bảng Chi Tiết Đơn Hàng (đơn giá chốt tại thời điểm đặt - QĐ03)
CREATE TABLE dbo.ChiTietDonHang (
    MaChiTiet NVARCHAR(35) NOT NULL PRIMARY KEY,
    MaDonHang NVARCHAR(30) NOT NULL,
    MaSanPham NVARCHAR(20) NOT NULL,     -- Tham chiếu Hệ thống quản lý sản phẩm
    SoLuong INT NOT NULL CONSTRAINT CK_CTDH_SoLuong CHECK (SoLuong > 0),
    DonGia DECIMAL(18,0) NOT NULL CONSTRAINT CK_CTDH_DonGia CHECK (DonGia >= 0),
    CONSTRAINT UQ_CTDH_Don_SanPham UNIQUE (MaDonHang, MaSanPham),
    CONSTRAINT FK_CTDH_DonDatHang FOREIGN KEY (MaDonHang) REFERENCES dbo.DonDatHang(MaDonHang)
);

-- 10. Bảng Thanh Toán (không lưu mã CSV, chỉ lưu 4 số cuối của thẻ - QĐ09)
CREATE TABLE dbo.ThanhToan (
    MaThanhToan NVARCHAR(35) NOT NULL PRIMARY KEY,
    MaDonHang NVARCHAR(30) NOT NULL,
    MaLoaiThe NVARCHAR(20) NOT NULL,
    BonSoCuoiThe NVARCHAR(4) NOT NULL,
    NgayHetHan DATE NOT NULL,
    HoTenChuThe NVARCHAR(100) NOT NULL,
    LePhi DECIMAL(18,0) NOT NULL CONSTRAINT DF_ThanhToan_LePhi DEFAULT(0),
    NgayThanhToan DATETIME NOT NULL CONSTRAINT DF_ThanhToan_Ngay DEFAULT(GETDATE()),
    CONSTRAINT UQ_ThanhToan_DonHang UNIQUE (MaDonHang),
    CONSTRAINT CK_ThanhToan_BonSo CHECK (BonSoCuoiThe LIKE '[0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_ThanhToan_LePhi CHECK (LePhi >= 0),
    CONSTRAINT FK_ThanhToan_DonDatHang FOREIGN KEY (MaDonHang) REFERENCES dbo.DonDatHang(MaDonHang),
    CONSTRAINT FK_ThanhToan_LoaiThe FOREIGN KEY (MaLoaiThe) REFERENCES dbo.LoaiThe(MaLoaiThe)
);

-- 11. Bảng Nhật Ký Email xác nhận (gửi bất đồng bộ, lỗi thì thử lại - QĐ13)
CREATE TABLE dbo.NhatKyEmail (
    MaEmail NVARCHAR(35) NOT NULL PRIMARY KEY,
    MaDonHang NVARCHAR(30) NOT NULL,
    EmailNhan NVARCHAR(150) NOT NULL,
    NgayGui DATETIME NULL,
    TrangThai NVARCHAR(20) NOT NULL CONSTRAINT DF_NhatKyEmail_TrangThai DEFAULT(N'ChoGui'),
    SoLanThu INT NOT NULL CONSTRAINT DF_NhatKyEmail_SoLanThu DEFAULT(0),
    CONSTRAINT CK_NhatKyEmail_TrangThai CHECK (TrangThai IN (N'ChoGui', N'DaGui', N'Loi')),
    CONSTRAINT CK_NhatKyEmail_SoLanThu CHECK (SoLanThu >= 0),
    CONSTRAINT FK_NhatKyEmail_DonDatHang FOREIGN KEY (MaDonHang) REFERENCES dbo.DonDatHang(MaDonHang)
);
GO

-- Dữ liệu cấu hình ban đầu (QĐ07)
INSERT INTO dbo.LoaiPhieuDat (MaLoaiPhieu, TenLoaiPhieu, ThoiGianXuLyGio, NguongMienPhi) VALUES
(N'THUONG', N'Thường', 72, NULL),
(N'NHANH', N'Chuyển phát nhanh', 24, 1000000),
(N'TRONGNGAY', N'Chuyển phát nhanh trong ngày', 6, 5000000);

INSERT INTO dbo.LoaiThe (MaLoaiThe, TenLoaiThe, SoChuSoThe, SoChuSoCSV, LePhi) VALUES
(N'VISA', N'Visa', 16, 3, 0),
(N'MASTER', N'Master', 16, 3, 0),
(N'DISCOVER', N'Discover', 16, 3, 0),
(N'AMEX', N'American Express', 15, 4, 0);
GO