-- HỆ THỐNG QUẢN LÝ NHÂN SỰ - CÔNG TY SƠN ĐÔNG Á
-- Chạy bằng SQL Server 2016 SP1 trở lên / LocalDB, hoặc nút Khởi tạo database trong ứng dụng.
-- Không xóa database, bảng hoặc dữ liệu đã có. Tạo dữ liệu minh họa lần đầu.
USE master;
GO
IF DB_ID(N'QuanLyNhanSu') IS NULL
    EXEC(N'CREATE DATABASE QuanLyNhanSu COLLATE Vietnamese_CI_AS');
GO
USE QuanLyNhanSu;
GO
IF OBJECT_ID(N'dbo.PhongBan', N'U') IS NULL
CREATE TABLE dbo.PhongBan (
    MaPhongBan VARCHAR(20) PRIMARY KEY,
    TenPhongBan NVARCHAR(100) NOT NULL UNIQUE,
    TruongPhong NVARCHAR(100) NULL,
    DienThoai VARCHAR(20) NULL,
    DiaDiem NVARCHAR(200) NULL
);
GO

-- =========================================================================================
-- 2. BẢNG CHỨC VỤ (ChucVu)
-- =========================================================================================
IF OBJECT_ID(N'dbo.ChucVu', N'U') IS NULL
CREATE TABLE dbo.ChucVu (
    MaChucVu VARCHAR(20) PRIMARY KEY,
    TenChucVu NVARCHAR(100) NOT NULL UNIQUE,
    PhuCapChucVu DECIMAL(18, 2) NOT NULL DEFAULT 0,
    MoTa NVARCHAR(255) NULL
);
GO

-- =========================================================================================
-- 3. BẢNG NHÂN VIÊN (NhanVien)
-- =========================================================================================
IF OBJECT_ID(N'dbo.NhanVien', N'U') IS NULL
CREATE TABLE dbo.NhanVien (
    MaNhanVien VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE NULL,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    CCCD VARCHAR(20) NOT NULL UNIQUE,
    DienThoai VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    DiaChi NVARCHAR(255) NULL,
    NgayVaoLam DATE NOT NULL DEFAULT GETDATE(),
    MaPhongBan VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES PhongBan(MaPhongBan),
    MaChucVu VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ChucVu(MaChucVu),
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Thử việc' -- N'Thử việc', N'Chính thức', N'Đã nghỉ việc'
);
GO

-- =========================================================================================
-- 4. BẢNG QUYẾT ĐỊNH TUYỂN DỤNG / THỬ VIỆC (QuyetDinhTuyenDung)
-- =========================================================================================
IF OBJECT_ID(N'dbo.QuyetDinhTuyenDung', N'U') IS NULL
CREATE TABLE dbo.QuyetDinhTuyenDung (
    SoQuyetDinhTD VARCHAR(30) PRIMARY KEY,
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    NgayQuyetDinh DATE NOT NULL DEFAULT GETDATE(),
    ThoiGianThuViec INT NOT NULL DEFAULT 60, -- Số ngày thử việc (30 ngày, 60 ngày)
    LuongThuViec DECIMAL(18, 2) NOT NULL, -- Tối thiểu 85% lương chính thức
    DieuKhoanThoaThuan NVARCHAR(500) NULL,
    TrangThaiDuyet NVARCHAR(50) NOT NULL DEFAULT N'Đã duyệt', -- N'Chờ duyệt', N'Đã duyệt'
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 5. BẢNG HỢP ĐỒNG LAO ĐỘNG (HopDongLaoDong)
-- =========================================================================================
IF OBJECT_ID(N'dbo.HopDongLaoDong', N'U') IS NULL
CREATE TABLE dbo.HopDongLaoDong (
    SoHopDong VARCHAR(30) PRIMARY KEY,
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    LoaiHopDong NVARCHAR(50) NOT NULL CHECK (LoaiHopDong IN (N'Ngắn hạn', N'Dài hạn', N'Không xác định thời hạn')),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NULL, -- NULL nếu là Không xác định thời hạn
    LuongThoaThuan DECIMAL(18, 2) NOT NULL,
    CoBaoHiem BIT NOT NULL DEFAULT 0, -- 1 nếu là HĐ dài hạn, 0 nếu ngắn hạn
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Hiệu lực', -- N'Hiệu lực', N'Hết hạn', N'Đã chấm dứt'
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 6. BẢNG HỒ SƠ BẢO HIỂM (HoSoBaoHiem) - Áp dụng HĐ dài hạn
-- =========================================================================================
IF OBJECT_ID(N'dbo.HoSoBaoHiem', N'U') IS NULL
CREATE TABLE dbo.HoSoBaoHiem (
    MaHoSoBH VARCHAR(30) PRIMARY KEY,
    MaNhanVien VARCHAR(20) NOT NULL UNIQUE FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    SoTheBHYT VARCHAR(30) NOT NULL UNIQUE,
    MaSoBHXH VARCHAR(30) NOT NULL UNIQUE,
    NgayThamGia DATE NOT NULL,
    MucDongBHXH DECIMAL(18, 2) NOT NULL, -- Mức lương đóng bảo hiểm
    TyLeDongNV DECIMAL(5, 2) NOT NULL DEFAULT 10.5, -- % NV đóng (8% BHXH, 1.5% BHYT, 1% BHTN)
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đang tham gia'
);
GO

-- =========================================================================================
-- 7. BẢNG QUYẾT ĐỊNH CHỨC VỤ (QuyetDinhChucVu)
-- =========================================================================================
IF OBJECT_ID(N'dbo.QuyetDinhChucVu', N'U') IS NULL
CREATE TABLE dbo.QuyetDinhChucVu (
    SoQuyetDinhCV VARCHAR(30) PRIMARY KEY,
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    MaChucVu VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES ChucVu(MaChucVu),
    PhuCapChucVu DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NgayHieuLuc DATE NOT NULL,
    LyDoBoNhiem NVARCHAR(255) NULL,
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 8. BẢNG QUYẾT ĐỊNH LƯƠNG (QuyetDinhLuong) - Có Phụ cấp độc hại cho nhân sự xưởng sơn
-- =========================================================================================
IF OBJECT_ID(N'dbo.QuyetDinhLuong', N'U') IS NULL
CREATE TABLE dbo.QuyetDinhLuong (
    SoQuyetDinhL VARCHAR(30) PRIMARY KEY,
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    LuongCoBan DECIMAL(18, 2) NOT NULL,
    PhuCapLuong DECIMAL(18, 2) NOT NULL DEFAULT 0,
    PhuCapDocHai DECIMAL(18, 2) NOT NULL DEFAULT 0, -- Nhân viên xưởng sơn tiếp xúc hóa chất
    NgayHieuLuc DATE NOT NULL,
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 9. BẢNG KẾ HOẠCH PHÂN CA TUẦN (KeHoachPhanCa)
-- =========================================================================================
IF OBJECT_ID(N'dbo.KeHoachPhanCa', N'U') IS NULL
CREATE TABLE dbo.KeHoachPhanCa (
    MaKeHoach VARCHAR(30) PRIMARY KEY,
    TuanThu INT NOT NULL,
    TuNgay DATE NOT NULL,
    DenNgay DATE NOT NULL,
    MaPhongBan VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES PhongBan(MaPhongBan),
    NguoiLap NVARCHAR(100) NOT NULL,
    NgayLap DATE NOT NULL DEFAULT GETDATE(),
    GhiChu NVARCHAR(255) NULL
);
GO

-- =========================================================================================
-- 10. BẢNG CHI TIẾT PHÂN CA (ChiTietPhanCa)
-- =========================================================================================
IF OBJECT_ID(N'dbo.ChiTietPhanCa', N'U') IS NULL
CREATE TABLE dbo.ChiTietPhanCa (
    MaChiTietPC INT IDENTITY(1,1) PRIMARY KEY,
    MaKeHoach VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES KeHoachPhanCa(MaKeHoach),
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    ThuTrongTuan NVARCHAR(20) NOT NULL, -- N'Thứ Hai', N'Thứ Ba', ...
    CaLamViec NVARCHAR(50) NOT NULL, -- N'Ca 1 (06:00 - 14:00)', N'Ca 2 (14:00 - 22:00)', N'Ca 3 (22:00 - 06:00)'
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    CoPhuTroi BIT NOT NULL DEFAULT 0
);
GO

-- =========================================================================================
-- 11. BẢNG PHIẾU PHỤ TRỘI / TĂNG CA (PhieuPhuTroi) - Hệ số x1.5 ngày thường, x2.0 ngày nghỉ, x3.0 lễ
-- =========================================================================================
IF OBJECT_ID(N'dbo.PhieuPhuTroi', N'U') IS NULL
CREATE TABLE dbo.PhieuPhuTroi (
    SoPhieuPT VARCHAR(30) PRIMARY KEY,
    NgayPhuTroi DATE NOT NULL,
    HinhThucPhuTroi NVARCHAR(50) NOT NULL CHECK (HinhThucPhuTroi IN (N'Tăng ca ngày thường', N'Ngày nghỉ', N'Ngày lễ')),
    HeSoPhuTroi DECIMAL(4, 2) NOT NULL DEFAULT 1.5, -- 1.5 ngày thường, 2.0 ngày nghỉ, 3.0 lễ
    NguoiLap NVARCHAR(100) NOT NULL DEFAULT N'Ban chấm công',
    TrangThaiDuyet NVARCHAR(50) NOT NULL DEFAULT N'Đã duyệt'
);
GO

-- =========================================================================================
-- 12. BẢNG CHI TIẾT PHIẾU PHỤ TRỘI (ChiTietPhuTroi)
-- =========================================================================================
IF OBJECT_ID(N'dbo.ChiTietPhuTroi', N'U') IS NULL
CREATE TABLE dbo.ChiTietPhuTroi (
    MaChiTietPT INT IDENTITY(1,1) PRIMARY KEY,
    SoPhieuPT VARCHAR(30) NOT NULL FOREIGN KEY REFERENCES PhieuPhuTroi(SoPhieuPT),
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    SoGioPhuTroi DECIMAL(4, 1) NOT NULL, -- Ví dụ: 2.5 giờ, 4.0 giờ
    NoiDungCongViec NVARCHAR(255) NULL,
    GhiChu NVARCHAR(255) NULL
);
GO

-- =========================================================================================
-- 13. BẢNG CHẤM CÔNG THÁNG (BangChamCong)
-- =========================================================================================
IF OBJECT_ID(N'dbo.BangChamCong', N'U') IS NULL
CREATE TABLE dbo.BangChamCong (
    MaChamCong VARCHAR(30) PRIMARY KEY,
    ThangNam VARCHAR(10) NOT NULL, -- '10/2026'
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    SoNgayCongChuan DECIMAL(4, 1) NOT NULL DEFAULT 26.0,
    SoNgayLamThucTe DECIMAL(4, 1) NOT NULL DEFAULT 0,
    SoNgayNghiCoPhep DECIMAL(4, 1) NOT NULL DEFAULT 0,
    SoNgayNghiKhongPhep DECIMAL(4, 1) NOT NULL DEFAULT 0,
    TongGioPhuTroi DECIMAL(5, 1) NOT NULL DEFAULT 0,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đã khóa công'
);
GO

-- =========================================================================================
-- 14. BẢNG QUYẾT ĐỊNH KHEN THƯỞNG (QuyetDinhKhenThuong)
-- =========================================================================================
IF OBJECT_ID(N'dbo.QuyetDinhKhenThuong', N'U') IS NULL
CREATE TABLE dbo.QuyetDinhKhenThuong (
    SoQuyetDinhKT VARCHAR(30) PRIMARY KEY,
    NgayQuyetDinh DATE NOT NULL DEFAULT GETDATE(),
    LoaiKhenThuong NVARCHAR(50) NOT NULL CHECK (LoaiKhenThuong IN (N'Cá nhân', N'Tập thể')),
    MaDoiTuong VARCHAR(20) NOT NULL, -- Mã NV hoặc Mã PB
    LyDoKhenThuong NVARCHAR(255) NOT NULL,
    SoTienThuong DECIMAL(18, 2) NOT NULL,
    HinhThucChi NVARCHAR(50) NOT NULL CHECK (HinhThucChi IN (N'Chi tiền mặt', N'Cộng vào bảng lương')),
    TrangThaiChi NVARCHAR(50) NOT NULL DEFAULT N'Chưa chi', -- N'Đã chi', N'Chưa chi', N'Đã cộng lương'
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 15. BẢNG PHIẾU CHI KHEN THƯỞNG (PhieuChiKhenThuong) - Sinh ra khi chi tiền mặt
-- =========================================================================================
IF OBJECT_ID(N'dbo.PhieuChiKhenThuong', N'U') IS NULL
CREATE TABLE dbo.PhieuChiKhenThuong (
    SoPhieuChi VARCHAR(30) PRIMARY KEY,
    SoQuyetDinhKT VARCHAR(30) NOT NULL UNIQUE FOREIGN KEY REFERENCES QuyetDinhKhenThuong(SoQuyetDinhKT),
    NgayChi DATE NOT NULL DEFAULT GETDATE(),
    SoTienChi DECIMAL(18, 2) NOT NULL,
    NguoiNhan NVARCHAR(100) NOT NULL,
    NguoiChiTien NVARCHAR(100) NOT NULL DEFAULT N'Thủ quỹ',
    GhiChu NVARCHAR(255) NULL
);
GO

-- =========================================================================================
-- 16. BẢNG QUYẾT ĐỊNH KỶ LUẬT (QuyetDinhKyLuat)
-- =========================================================================================
IF OBJECT_ID(N'dbo.QuyetDinhKyLuat', N'U') IS NULL
CREATE TABLE dbo.QuyetDinhKyLuat (
    SoQuyetDinhKL VARCHAR(30) PRIMARY KEY,
    NgayQuyetDinh DATE NOT NULL DEFAULT GETDATE(),
    LoaiKyLuat NVARCHAR(50) NOT NULL CHECK (LoaiKyLuat IN (N'Cá nhân', N'Tập thể')),
    MaDoiTuong VARCHAR(20) NOT NULL,
    LyDoKyLuat NVARCHAR(255) NOT NULL,
    HinhThucPhat NVARCHAR(50) NOT NULL CHECK (HinhThucPhat IN (N'Thu tiền nộp phạt', N'Trừ vào bảng lương', N'Khiển trách')),
    SoTienPhat DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TrangThaiThu NVARCHAR(50) NOT NULL DEFAULT N'Chưa thu', -- N'Đã thu', N'Chưa thu', N'Đã trừ lương'
    NguoiKy NVARCHAR(100) NOT NULL DEFAULT N'Giám đốc'
);
GO

-- =========================================================================================
-- 17. BẢNG PHIẾU THU NỘP PHẠT (PhieuThuNopPhat) - Sinh ra khi thu tiền nộp phạt
-- =========================================================================================
IF OBJECT_ID(N'dbo.PhieuThuNopPhat', N'U') IS NULL
CREATE TABLE dbo.PhieuThuNopPhat (
    SoPhieuThu VARCHAR(30) PRIMARY KEY,
    SoQuyetDinhKL VARCHAR(30) NOT NULL UNIQUE FOREIGN KEY REFERENCES QuyetDinhKyLuat(SoQuyetDinhKL),
    NgayThu DATE NOT NULL DEFAULT GETDATE(),
    SoTienThu DECIMAL(18, 2) NOT NULL,
    NguoiNop NVARCHAR(100) NOT NULL,
    NguoiThuTien NVARCHAR(100) NOT NULL DEFAULT N'Thủ quỹ',
    GhiChu NVARCHAR(255) NULL
);
GO

-- =========================================================================================
-- 18. BẢNG BẢNG LƯƠNG THÁNG (BangLuongThang)
-- =========================================================================================
IF OBJECT_ID(N'dbo.BangLuongThang', N'U') IS NULL
CREATE TABLE dbo.BangLuongThang (
    MaBangLuong VARCHAR(30) PRIMARY KEY,
    ThangNam VARCHAR(10) NOT NULL, -- '10/2026'
    MaNhanVien VARCHAR(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
    LuongCoBan DECIMAL(18, 2) NOT NULL DEFAULT 0,
    LuongThucTeTheoCong DECIMAL(18, 2) NOT NULL DEFAULT 0,
    PhuCapLuong DECIMAL(18, 2) NOT NULL DEFAULT 0,
    PhuCapChucVu DECIMAL(18, 2) NOT NULL DEFAULT 0,
    PhuCapDocHai DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TienPhuTroi DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TienKhenThuong DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TienPhatKyLuat DECIMAL(18, 2) NOT NULL DEFAULT 0,
    TienBaoHiem DECIMAL(18, 2) NOT NULL DEFAULT 0,
    ThucLinh DECIMAL(18, 2) NOT NULL DEFAULT 0,
    NgayLap DATE NOT NULL DEFAULT GETDATE(),
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Đã tính' -- N'Dự thảo', N'Đã tính', N'Đã chi trả'
);
GO

-- =========================================================================================


-- Ràng buộc và chỉ mục, có thể chạy lại mà không xóa dữ liệu.
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Cong_KyNhanVien')
    CREATE UNIQUE INDEX UX_Cong_KyNhanVien ON dbo.BangChamCong(ThangNam,MaNhanVien);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Luong_KyNhanVien')
    CREATE UNIQUE INDEX UX_Luong_KyNhanVien ON dbo.BangLuongThang(ThangNam,MaNhanVien);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_QuyetDinhLuong_Ngay')
    CREATE UNIQUE INDEX UX_QuyetDinhLuong_Ngay ON dbo.QuyetDinhLuong(MaNhanVien,NgayHieuLuc);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_QuyetDinhChucVu_Ngay')
    CREATE UNIQUE INDEX UX_QuyetDinhChucVu_Ngay ON dbo.QuyetDinhChucVu(MaNhanVien,NgayHieuLuc);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_PhuTroi_NhanVien')
    CREATE UNIQUE INDEX UX_PhuTroi_NhanVien ON dbo.ChiTietPhuTroi(SoPhieuPT,MaNhanVien);
GO
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_HopDong')
ALTER TABLE dbo.HopDongLaoDong ADD CONSTRAINT CK_HopDong CHECK
    (LuongThoaThuan > 0 AND (NgayKetThuc IS NULL OR NgayKetThuc>=NgayBatDau)
     AND (LoaiHopDong=N'Không xác định thời hạn' OR NgayKetThuc IS NOT NULL)
     AND (CoBaoHiem=0 OR LoaiHopDong<>N'Ngắn hạn'));
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_BaoHiem')
ALTER TABLE dbo.HoSoBaoHiem ADD CONSTRAINT CK_BaoHiem CHECK(MucDongBHXH>0 AND TyLeDongNV BETWEEN 0 AND 100);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_Luong')
ALTER TABLE dbo.QuyetDinhLuong ADD CONSTRAINT CK_Luong CHECK(LuongCoBan>0 AND PhuCapLuong>=0 AND PhuCapDocHai>=0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_ChucVu')
ALTER TABLE dbo.ChucVu ADD CONSTRAINT CK_ChucVu CHECK(PhuCapChucVu>=0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_QDChucVu')
ALTER TABLE dbo.QuyetDinhChucVu ADD CONSTRAINT CK_QDChucVu CHECK(PhuCapChucVu>=0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_TuyenDung')
ALTER TABLE dbo.QuyetDinhTuyenDung ADD CONSTRAINT CK_TuyenDung CHECK(ThoiGianThuViec>0 AND LuongThuViec>0 AND TrangThaiDuyet IN(N'Chờ duyệt',N'Đã duyệt'));
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_KeHoach')
ALTER TABLE dbo.KeHoachPhanCa ADD CONSTRAINT CK_KeHoach CHECK
    (TuanThu BETWEEN 1 AND 53 AND DenNgay=DATEADD(DAY,6,TuNgay) AND DATEDIFF(DAY,CONVERT(date,'19000101',112),TuNgay)%7=0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_PhanCa')
ALTER TABLE dbo.ChiTietPhanCa ADD CONSTRAINT CK_PhanCa CHECK(GioBatDau<>GioKetThuc AND ThuTrongTuan IN(N'Thứ Hai',N'Thứ Ba',N'Thứ Tư',N'Thứ Năm',N'Thứ Sáu',N'Thứ Bảy',N'Chủ nhật'));
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_PhuTroi')
ALTER TABLE dbo.PhieuPhuTroi ADD CONSTRAINT CK_PhuTroi CHECK
    ((HinhThucPhuTroi=N'Tăng ca ngày thường' AND HeSoPhuTroi=1.5) OR (HinhThucPhuTroi=N'Ngày nghỉ' AND HeSoPhuTroi=2) OR (HinhThucPhuTroi=N'Ngày lễ' AND HeSoPhuTroi=3));
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_GioPhuTroi')
ALTER TABLE dbo.ChiTietPhuTroi ADD CONSTRAINT CK_GioPhuTroi CHECK(SoGioPhuTroi>0 AND SoGioPhuTroi<=24);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_Cong')
ALTER TABLE dbo.BangChamCong ADD CONSTRAINT CK_Cong CHECK
    (LEN(ThangNam)=7 AND SUBSTRING(ThangNam,3,1)='/' AND TRY_CONVERT(date,'01/'+ThangNam,103) IS NOT NULL
     AND SoNgayCongChuan>0 AND SoNgayCongChuan<=31 AND SoNgayLamThucTe>=0
     AND SoNgayNghiCoPhep>=0 AND SoNgayNghiKhongPhep>=0 AND TongGioPhuTroi>=0
     AND SoNgayLamThucTe+SoNgayNghiCoPhep+SoNgayNghiKhongPhep<=SoNgayCongChuan
     AND TrangThai IN(N'Đang nhập',N'Đã khóa công'));
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_TienThuong')
ALTER TABLE dbo.QuyetDinhKhenThuong ADD CONSTRAINT CK_TienThuong CHECK(SoTienThuong>0);
IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name='CK_TienPhat')
ALTER TABLE dbo.QuyetDinhKyLuat ADD CONSTRAINT CK_TienPhat CHECK(SoTienPhat>=0 AND (HinhThucPhat<>N'Khiển trách' OR SoTienPhat=0));
GO
CREATE OR ALTER TRIGGER dbo.tr_HopDong ON dbo.HopDongLaoDong AFTER INSERT,UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i JOIN dbo.HopDongLaoDong h WITH(UPDLOCK,HOLDLOCK)
      ON h.MaNhanVien=i.MaNhanVien AND h.SoHopDong<>i.SoHopDong
      AND h.TrangThai<>N'Đã chấm dứt' AND i.TrangThai<>N'Đã chấm dứt'
      AND i.NgayBatDau<=ISNULL(h.NgayKetThuc,CONVERT(date,'99991231',112))
      AND h.NgayBatDau<=ISNULL(i.NgayKetThuc,CONVERT(date,'99991231',112)))
      THROW 50001,N'Hợp đồng của cùng nhân viên không được trùng thời gian.',1;
END;
GO
CREATE OR ALTER VIEW dbo.v_CaLamThucTe AS
SELECT c.MaChiTietPC,c.MaNhanVien,
       DATEADD(SECOND,DATEDIFF(SECOND,CONVERT(time,'00:00'),c.GioBatDau),CONVERT(datetime,d.Ngay)) AS BatDau,
       DATEADD(DAY,CASE WHEN c.GioKetThuc<c.GioBatDau THEN 1 ELSE 0 END,
         DATEADD(SECOND,DATEDIFF(SECOND,CONVERT(time,'00:00'),c.GioKetThuc),CONVERT(datetime,d.Ngay))) AS KetThuc
FROM dbo.ChiTietPhanCa c JOIN dbo.KeHoachPhanCa k ON c.MaKeHoach=k.MaKeHoach
CROSS APPLY(SELECT DATEADD(DAY,CASE c.ThuTrongTuan WHEN N'Thứ Hai' THEN 0 WHEN N'Thứ Ba' THEN 1 WHEN N'Thứ Tư' THEN 2
    WHEN N'Thứ Năm' THEN 3 WHEN N'Thứ Sáu' THEN 4 WHEN N'Thứ Bảy' THEN 5 ELSE 6 END,k.TuNgay) AS Ngay)d;
GO
CREATE OR ALTER TRIGGER dbo.tr_PhanCa ON dbo.ChiTietPhanCa AFTER INSERT,UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM dbo.v_CaLamThucTe a JOIN dbo.v_CaLamThucTe b ON a.MaNhanVien=b.MaNhanVien
        AND a.MaChiTietPC<b.MaChiTietPC AND a.BatDau<b.KetThuc AND b.BatDau<a.KetThuc)
        THROW 50002,N'Ca làm việc bị trùng giờ, bao gồm ca đêm sang ngày hôm sau.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_KeHoach ON dbo.KeHoachPhanCa AFTER UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM dbo.v_CaLamThucTe a JOIN dbo.v_CaLamThucTe b ON a.MaNhanVien=b.MaNhanVien
        AND a.MaChiTietPC<b.MaChiTietPC AND a.BatDau<b.KetThuc AND b.BatDau<a.KetThuc)
        THROW 50003,N'Đổi tuần làm việc gây trùng ca đã phân công.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_KhenThuong ON dbo.QuyetDinhKhenThuong AFTER INSERT,UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i WHERE (i.LoaiKhenThuong=N'Cá nhân' AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaNhanVien=i.MaDoiTuong))
        OR (i.LoaiKhenThuong=N'Tập thể' AND NOT EXISTS(SELECT 1 FROM dbo.PhongBan WHERE MaPhongBan=i.MaDoiTuong)))
        THROW 50004,N'Đối tượng khen thưởng không tồn tại.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON i.SoQuyetDinhKT=d.SoQuyetDinhKT
        WHERE EXISTS(SELECT 1 FROM dbo.PhieuChiKhenThuong p WHERE p.SoQuyetDinhKT=i.SoQuyetDinhKT)
        AND (i.SoTienThuong<>d.SoTienThuong OR i.MaDoiTuong<>d.MaDoiTuong OR i.LoaiKhenThuong<>d.LoaiKhenThuong OR i.HinhThucChi<>d.HinhThucChi OR i.NgayQuyetDinh<>d.NgayQuyetDinh))
        THROW 50005,N'Quyết định đã chi tiền không được đổi đối tượng, ngày, hình thức hoặc số tiền.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_KyLuat ON dbo.QuyetDinhKyLuat AFTER INSERT,UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i WHERE (i.LoaiKyLuat=N'Cá nhân' AND NOT EXISTS(SELECT 1 FROM dbo.NhanVien WHERE MaNhanVien=i.MaDoiTuong))
        OR (i.LoaiKyLuat=N'Tập thể' AND NOT EXISTS(SELECT 1 FROM dbo.PhongBan WHERE MaPhongBan=i.MaDoiTuong)))
        THROW 50006,N'Đối tượng kỷ luật không tồn tại.',1;
    IF EXISTS(SELECT 1 FROM inserted i JOIN deleted d ON i.SoQuyetDinhKL=d.SoQuyetDinhKL
        WHERE EXISTS(SELECT 1 FROM dbo.PhieuThuNopPhat p WHERE p.SoQuyetDinhKL=i.SoQuyetDinhKL)
        AND (i.SoTienPhat<>d.SoTienPhat OR i.MaDoiTuong<>d.MaDoiTuong OR i.LoaiKyLuat<>d.LoaiKyLuat OR i.HinhThucPhat<>d.HinhThucPhat OR i.NgayQuyetDinh<>d.NgayQuyetDinh))
        THROW 50007,N'Quyết định đã thu tiền không được đổi đối tượng, ngày, hình thức hoặc số tiền.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_NhanVien_DoiTuong ON dbo.NhanVien AFTER DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted d WHERE
        EXISTS(SELECT 1 FROM dbo.QuyetDinhKhenThuong q WHERE q.LoaiKhenThuong=N'Cá nhân' AND q.MaDoiTuong=d.MaNhanVien)
        OR EXISTS(SELECT 1 FROM dbo.QuyetDinhKyLuat q WHERE q.LoaiKyLuat=N'Cá nhân' AND q.MaDoiTuong=d.MaNhanVien))
        THROW 50015,N'Nhân viên đang được sử dụng trong quyết định khen thưởng hoặc kỷ luật.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_PhongBan_DoiTuong ON dbo.PhongBan AFTER DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM deleted d WHERE
        EXISTS(SELECT 1 FROM dbo.QuyetDinhKhenThuong q WHERE q.LoaiKhenThuong=N'Tập thể' AND q.MaDoiTuong=d.MaPhongBan)
        OR EXISTS(SELECT 1 FROM dbo.QuyetDinhKyLuat q WHERE q.LoaiKyLuat=N'Tập thể' AND q.MaDoiTuong=d.MaPhongBan))
        THROW 50016,N'Phòng ban đang được sử dụng trong quyết định khen thưởng hoặc kỷ luật.',1;
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_PhieuChi ON dbo.PhieuChiKhenThuong AFTER INSERT,UPDATE,DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i JOIN dbo.QuyetDinhKhenThuong q ON q.SoQuyetDinhKT=i.SoQuyetDinhKT
       WHERE q.HinhThucChi<>N'Chi tiền mặt' OR q.SoTienThuong<>i.SoTienChi OR i.NgayChi<q.NgayQuyetDinh)
       THROW 50008,N'Phiếu chi phải khớp số tiền, ngày và quyết định chi tiền mặt; không chi lại khoản qua lương.',1;
    UPDATE q SET TrangThaiChi=CASE WHEN EXISTS(SELECT 1 FROM dbo.PhieuChiKhenThuong p WHERE p.SoQuyetDinhKT=q.SoQuyetDinhKT) THEN N'Đã chi' ELSE N'Chưa chi' END
    FROM dbo.QuyetDinhKhenThuong q WHERE q.SoQuyetDinhKT IN(SELECT SoQuyetDinhKT FROM inserted UNION SELECT SoQuyetDinhKT FROM deleted);
END;
GO
CREATE OR ALTER TRIGGER dbo.tr_PhieuThu ON dbo.PhieuThuNopPhat AFTER INSERT,UPDATE,DELETE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted i JOIN dbo.QuyetDinhKyLuat q ON q.SoQuyetDinhKL=i.SoQuyetDinhKL
       WHERE q.HinhThucPhat<>N'Thu tiền nộp phạt' OR q.SoTienPhat<>i.SoTienThu OR i.SoTienThu<=0 OR i.NgayThu<q.NgayQuyetDinh)
       THROW 50009,N'Phiếu thu phải khớp số tiền, ngày và quyết định thu riêng; không thu lại khoản qua lương.',1;
    UPDATE q SET TrangThaiThu=CASE WHEN EXISTS(SELECT 1 FROM dbo.PhieuThuNopPhat p WHERE p.SoQuyetDinhKL=q.SoQuyetDinhKL) THEN N'Đã thu' ELSE N'Chưa thu' END
    FROM dbo.QuyetDinhKyLuat q WHERE q.SoQuyetDinhKL IN(SELECT SoQuyetDinhKL FROM inserted UNION SELECT SoQuyetDinhKL FROM deleted);
END;
GO
-- Tính toàn bộ kỳ trong một transaction; lỗi một hồ sơ sẽ giữ nguyên bảng lương cũ.
-- Quy ước bài tập: mức lương/phụ cấp có hiệu lực cuối kỳ; tăng ca theo từng phiếu đã duyệt.
CREATE OR ALTER PROCEDURE dbo.sp_TinhBangLuongThang @ThangNam varchar(10)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    DECLARE @Begin date=TRY_CONVERT(date,'01/'+@ThangNam,103);
    IF @Begin IS NULL OR LEN(@ThangNam)<>7 OR SUBSTRING(@ThangNam,3,1)<>'/'
        THROW 50010,N'Kỳ lương phải có dạng MM/yyyy.',1;
    DECLARE @End date=EOMONTH(@Begin);
    BEGIN TRY
        BEGIN TRAN;
        IF NOT EXISTS(SELECT 1 FROM dbo.BangChamCong WITH(UPDLOCK,HOLDLOCK) WHERE ThangNam=@ThangNam)
            THROW 50011,N'Kỳ này chưa có bảng chấm công.',1;
        IF EXISTS(SELECT 1 FROM dbo.BangChamCong WHERE ThangNam=@ThangNam AND TrangThai<>N'Đã khóa công')
            THROW 50012,N'Cần khóa tất cả bảng công trong kỳ trước khi tính lương.',1;
        SELECT c.MaNhanVien, c.SoNgayCongChuan,c.SoNgayLamThucTe,
               COALESCE(l.LuongCoBan,h.LuongThoaThuan,t.LuongThuViec,0) AS LuongCoBan,
               ISNULL(l.PhuCapLuong,0) AS PhuCapLuong,ISNULL(l.PhuCapDocHai,0) AS PhuCapDocHai,
               COALESCE(v.PhuCapChucVu,cv.PhuCapChucVu,0) AS PhuCapChucVu,
               ISNULL(h.CoBaoHiem,0) AS CoBaoHiem,b.MucDongBHXH,b.TyLeDongNV,
               ISNULL(ot.GioHeSo,0) AS GioHeSo,
               CAST(0 AS decimal(18,2)) AS TienKhenThuong,CAST(0 AS decimal(18,2)) AS TienPhatKyLuat
        INTO #Pay
        FROM dbo.BangChamCong c JOIN dbo.NhanVien n ON n.MaNhanVien=c.MaNhanVien
        JOIN dbo.ChucVu cv ON cv.MaChucVu=n.MaChucVu
        OUTER APPLY(SELECT TOP(1) * FROM dbo.QuyetDinhLuong q WHERE q.MaNhanVien=c.MaNhanVien AND q.NgayHieuLuc<=@End ORDER BY q.NgayHieuLuc DESC)l
        OUTER APPLY(SELECT TOP(1) * FROM dbo.HopDongLaoDong q WHERE q.MaNhanVien=c.MaNhanVien AND q.NgayBatDau<=@End AND (q.NgayKetThuc IS NULL OR q.NgayKetThuc>=@Begin) AND q.TrangThai<>N'Đã chấm dứt' ORDER BY q.NgayBatDau DESC)h
        OUTER APPLY(SELECT TOP(1) * FROM dbo.QuyetDinhTuyenDung q WHERE q.MaNhanVien=c.MaNhanVien AND q.NgayQuyetDinh<=@End AND DATEADD(DAY,q.ThoiGianThuViec-1,q.NgayQuyetDinh)>=@Begin AND q.TrangThaiDuyet=N'Đã duyệt' ORDER BY q.NgayQuyetDinh DESC)t
        OUTER APPLY(SELECT TOP(1) * FROM dbo.QuyetDinhChucVu q WHERE q.MaNhanVien=c.MaNhanVien AND q.NgayHieuLuc<=@End ORDER BY q.NgayHieuLuc DESC)v
        OUTER APPLY(SELECT * FROM dbo.HoSoBaoHiem q WHERE q.MaNhanVien=c.MaNhanVien AND q.NgayThamGia<=@End AND q.TrangThai=N'Đang tham gia')b
        OUTER APPLY(SELECT SUM(d.SoGioPhuTroi*p.HeSoPhuTroi) AS GioHeSo FROM dbo.ChiTietPhuTroi d JOIN dbo.PhieuPhuTroi p ON p.SoPhieuPT=d.SoPhieuPT
           WHERE d.MaNhanVien=c.MaNhanVien AND p.NgayPhuTroi BETWEEN @Begin AND @End AND p.TrangThaiDuyet=N'Đã duyệt')ot
        WHERE c.ThangNam=@ThangNam;
        IF EXISTS(SELECT 1 FROM #Pay WHERE LuongCoBan<=0)
            THROW 50013,N'Có nhân viên chưa có quyết định lương, hợp đồng hoặc quyết định thử việc hợp lệ trong kỳ.',1;
        IF EXISTS(SELECT 1 FROM #Pay WHERE CoBaoHiem=1 AND MucDongBHXH IS NULL)
            THROW 50014,N'Có hợp đồng tham gia bảo hiểm nhưng chưa có hồ sơ bảo hiểm hợp lệ.',1;
        -- Thưởng/phạt tập thể được chia đều cho nhân viên hiện thuộc phòng ban.
        UPDATE p SET TienKhenThuong=ISNULL((SELECT SUM(CASE WHEN q.LoaiKhenThuong=N'Cá nhân' THEN q.SoTienThuong
            ELSE q.SoTienThuong/NULLIF(d.MemberCount,0) END)
            FROM dbo.QuyetDinhKhenThuong q LEFT JOIN(SELECT MaPhongBan,COUNT(*) AS MemberCount FROM dbo.NhanVien GROUP BY MaPhongBan)d ON d.MaPhongBan=q.MaDoiTuong
            WHERE q.NgayQuyetDinh BETWEEN @Begin AND @End AND q.HinhThucChi=N'Cộng vào bảng lương'
            AND ((q.LoaiKhenThuong=N'Cá nhân' AND q.MaDoiTuong=p.MaNhanVien) OR(q.LoaiKhenThuong=N'Tập thể' AND q.MaDoiTuong=n.MaPhongBan))),0),
            TienPhatKyLuat=ISNULL((SELECT SUM(CASE WHEN q.LoaiKyLuat=N'Cá nhân' THEN q.SoTienPhat
            ELSE q.SoTienPhat/NULLIF(d.MemberCount,0) END)
            FROM dbo.QuyetDinhKyLuat q LEFT JOIN(SELECT MaPhongBan,COUNT(*) AS MemberCount FROM dbo.NhanVien GROUP BY MaPhongBan)d ON d.MaPhongBan=q.MaDoiTuong
            WHERE q.NgayQuyetDinh BETWEEN @Begin AND @End AND q.HinhThucPhat=N'Trừ vào bảng lương'
            AND ((q.LoaiKyLuat=N'Cá nhân' AND q.MaDoiTuong=p.MaNhanVien) OR(q.LoaiKyLuat=N'Tập thể' AND q.MaDoiTuong=n.MaPhongBan))),0)
        FROM #Pay p JOIN dbo.NhanVien n ON n.MaNhanVien=p.MaNhanVien;
        DELETE dbo.BangLuongThang WHERE ThangNam=@ThangNam;
        INSERT dbo.BangLuongThang(MaBangLuong,ThangNam,MaNhanVien,LuongCoBan,LuongThucTeTheoCong,PhuCapLuong,PhuCapChucVu,PhuCapDocHai,TienPhuTroi,TienKhenThuong,TienPhatKyLuat,TienBaoHiem,ThucLinh)
        SELECT 'BL'+REPLACE(@ThangNam,'/','')+MaNhanVien,@ThangNam,MaNhanVien,LuongCoBan,m.Cong,PhuCapLuong,PhuCapChucVu,PhuCapDocHai,m.OT,
            ROUND(TienKhenThuong,0),ROUND(TienPhatKyLuat,0),m.BH,
            m.Cong+PhuCapLuong+PhuCapChucVu+PhuCapDocHai+m.OT+ROUND(TienKhenThuong,0)-ROUND(TienPhatKyLuat,0)-m.BH
        FROM #Pay CROSS APPLY(SELECT ROUND(LuongCoBan/SoNgayCongChuan*SoNgayLamThucTe,0) AS Cong,
            ROUND(LuongCoBan/SoNgayCongChuan/8*GioHeSo,0) AS OT,
            CASE WHEN CoBaoHiem=1 THEN ROUND(MucDongBHXH*TyLeDongNV/100,0) ELSE 0 END AS BH)m;
        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT>0 ROLLBACK;
        THROW;
    END CATCH
END;
GO
-- Dữ liệu minh họa: chỉ thêm lần đầu, không ghi đè hồ sơ của người dùng.
SET XACT_ABORT ON;
BEGIN TRAN;
IF NOT EXISTS(SELECT 1 FROM dbo.PhongBan)
BEGIN
    DECLARE @Today date=GETDATE(),@Month date=DATEFROMPARTS(YEAR(GETDATE()),MONTH(GETDATE()),1);
    DECLARE @Monday date=DATEADD(DAY,-(DATEDIFF(DAY,CONVERT(date,'19000101',112),GETDATE())%7),CONVERT(date,GETDATE()));
    INSERT dbo.PhongBan VALUES('PB01',N'Phòng nhân sự',N'Nguyễn Văn An','0900000001',N'Văn phòng'),('PB02',N'Phân xưởng sản xuất',N'Trần Thị Bình','0900000002',N'Xưởng số 1');
    INSERT dbo.ChucVu VALUES('CV01',N'Nhân viên',0,N'Nhân viên chuyên môn'),('CV02',N'Tổ trưởng',500000,N'Quản lý tổ');
    INSERT dbo.NhanVien VALUES
      ('NV001',N'Nguyễn Văn An','19950115',N'Nam','000000000001','0900000001','an@example.com',N'TP. Hồ Chí Minh',@Month,'PB01','CV01',N'Chính thức'),
      ('NV002',N'Trần Thị Bình','19980220',N'Nữ','000000000002','0900000002','binh@example.com',N'TP. Hồ Chí Minh',@Month,'PB02','CV02',N'Chính thức');
    INSERT dbo.QuyetDinhTuyenDung VALUES('TD001','NV001',DATEADD(DAY,-60,@Month),60,6800000,N'Thử việc tại phòng nhân sự',N'Đã duyệt',N'Giám đốc');
    INSERT dbo.HopDongLaoDong VALUES
      ('HD001','NV001',N'Dài hạn',@Month,DATEADD(YEAR,1,@Month),8000000,1,N'Hiệu lực',N'Giám đốc'),
      ('HD002','NV002',N'Ngắn hạn',@Month,EOMONTH(@Month),9000000,0,N'Hiệu lực',N'Giám đốc');
    INSERT dbo.HoSoBaoHiem VALUES('BH001','NV001','BHYT000001','BHXH000001',@Month,8000000,10.5,N'Đang tham gia');
    INSERT dbo.QuyetDinhLuong VALUES('L001','NV001',8000000,300000,0,@Month,N'Giám đốc'),('L002','NV002',9000000,0,500000,@Month,N'Giám đốc');
    INSERT dbo.QuyetDinhChucVu VALUES('CVQD001','NV002','CV02',500000,@Month,N'Bổ nhiệm tổ trưởng',N'Giám đốc');
    INSERT dbo.KeHoachPhanCa VALUES('KH001',DATEPART(ISO_WEEK,@Monday),@Monday,DATEADD(DAY,6,@Monday),'PB02',N'Phòng nhân sự',@Today,N'Kế hoạch tuần mẫu');
    INSERT dbo.ChiTietPhanCa(MaKeHoach,MaNhanVien,ThuTrongTuan,CaLamViec,GioBatDau,GioKetThuc,CoPhuTroi) VALUES('KH001','NV002',N'Thứ Hai',N'Ca 1','06:00','14:00',0);
    INSERT dbo.PhieuPhuTroi VALUES('PT001',@Month,N'Tăng ca ngày thường',1.5,N'Ban chấm công',N'Đã duyệt');
    INSERT dbo.ChiTietPhuTroi(SoPhieuPT,MaNhanVien,SoGioPhuTroi,NoiDungCongViec,GhiChu) VALUES('PT001','NV001',2,N'Hoàn thành báo cáo',NULL);
    INSERT dbo.BangChamCong VALUES
      ('CC001',FORMAT(@Month,'MM/yyyy'),'NV001',26,26,0,0,2,N'Đã khóa công'),
      ('CC002',FORMAT(@Month,'MM/yyyy'),'NV002',26,25,1,0,0,N'Đã khóa công');
    INSERT dbo.QuyetDinhKhenThuong VALUES('KT001',@Month,N'Cá nhân','NV001',N'Hoàn thành công việc',500000,N'Cộng vào bảng lương',N'Chưa chi',N'Giám đốc');
    INSERT dbo.QuyetDinhKyLuat VALUES('KL001',@Month,N'Cá nhân','NV002',N'Ví dụ xử lý nội quy trong bài tập',N'Trừ vào bảng lương',100000,N'Chưa thu',N'Giám đốc');
END;
COMMIT;
GO
PRINT N'Database QuanLyNhanSu đã sẵn sàng. Dữ liệu mẫu không ghi đè hồ sơ hiện có.';
