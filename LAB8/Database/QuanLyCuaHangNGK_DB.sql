-- =======================================================
-- CSDL HỆ THỐNG QUẢN LÝ CỬA HÀNG NƯỚC GIẢI KHÁT
-- =======================================================
CREATE DATABASE QuanLyCuaHangNGK;
GO
USE QuanLyCuaHangNGK;
GO

CREATE TABLE KhachHang (
    MaKH VARCHAR(20) PRIMARY KEY, 
    TenKH NVARCHAR(100), 
    LoaiKH NVARCHAR(50), -- Khách vãng lai, Khách quen
    SDT VARCHAR(20)
);

CREATE TABLE NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    TenNV NVARCHAR(100),
    ChucVu NVARCHAR(50)
);

CREATE TABLE NhaCungCap (
    MaNCC VARCHAR(20) PRIMARY KEY,
    TenNCC NVARCHAR(100),
    DiaChi NVARCHAR(255),
    SDT VARCHAR(20)
);

CREATE TABLE NuocGiaiKhat (
    MaNGK VARCHAR(20) PRIMARY KEY, 
    TenNGK NVARCHAR(100), 
    DonViTinh NVARCHAR(20), 
    SoLuongTon INT,
    DonGia DECIMAL(18,2),
    MaNCC VARCHAR(20) FOREIGN KEY REFERENCES NhaCungCap(MaNCC)
);

CREATE TABLE HoaDon (
    MaHD VARCHAR(20) PRIMARY KEY, 
    NgayLap DATE, 
    TongTien DECIMAL(18,2), 
    MaKH VARCHAR(20) FOREIGN KEY REFERENCES KhachHang(MaKH),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV)
);

CREATE TABLE PhieuGhiNo (
    MaPGN VARCHAR(20) PRIMARY KEY, 
    NgayLap DATE, 
    SoTienNo DECIMAL(18,2), 
    NgayHenTra DATE, 
    LyDo NVARCHAR(255), 
    MaKH VARCHAR(20) FOREIGN KEY REFERENCES KhachHang(MaKH),
    MaNV VARCHAR(20) FOREIGN KEY REFERENCES NhanVien(MaNV)
);
