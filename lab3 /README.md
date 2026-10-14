# 🏨 HỆ THỐNG QUẢN LÝ KHÁCH SẠN (LAB 3 - OOSD)

Dự án **Hệ thống Quản lý Khách sạn** thuộc học phần Phân tích và Thiết kế Hướng đối tượng (OOSD), được xây dựng dưới dạng ứng dụng Desktop nội bộ trên nền tảng **C# Windows Forms (.NET Framework 4.7.2)** kết nối cơ sở dữ liệu **SQL Server** qua **ADO.NET**.

---

## 📌 1. Giới thiệu bài toán & Nghiệp vụ
Hệ thống hỗ trợ nhân viên khách sạn thực hiện trọn vẹn quy trình nghiệp vụ từ quản lý danh mục đến thống kê doanh thu:
- **Quản lý Phòng & Tiện nghi:** Phân loại phòng theo khu vực, sức chứa tối đa và đơn giá thuê theo ngày. Theo dõi trang bị/luân chuyển thiết bị (ti vi, tủ lạnh, điện thoại...) qua phiếu lắp đặt với quy tắc mỗi ngày một thiết bị chỉ lắp cho một phòng.
- **Đặt phòng & Nhận phòng:** Hỗ trợ đặt phòng qua điện thoại, website hoặc trực tiếp; kiểm tra sức chứa và chống trùng lịch đặt; ghi nhận danh sách người lưu trú thực tế (Họ tên, CCCD, Quốc tịch) và xử lý trạng thái `No-show`.
- **Ghi nhận Dịch vụ:** Ghi nhận dịch vụ phát sinh cho các phòng đang lưu trú; tự động cộng dồn số lượng và thành tiền nếu cùng một dịch vụ được gọi nhiều lần trong cùng một ngày.
- **Trả phòng, Đền bù & Thanh toán:** Kiểm tra tình trạng tiện nghi khi trả phòng và lập phiếu đền bù nếu có hư hỏng/mất mát; tính hóa đơn (tiền phòng + tiền dịch vụ); hỗ trợ thanh toán nhiều lần qua 4 phương thức (*Tiền mặt, Chuyển khoản, Thẻ, Ví điện tử*) trước khi giải phóng phòng.
- **Tra cứu & Thống kê:** Tổng hợp số lượng phiếu đặt, số phòng đang ở, doanh thu hóa đơn, tiền đền bù và thống kê chi tiết dịch vụ theo khoảng thời gian.

---

## 📋 2. Quy tắc nghiệp vụ cốt lõi (Business Rules)

| Mã quy tắc | Nội dung quy tắc nghiệp vụ |
| :--- | :--- |
| **BR01** | Một khu vực có nhiều phòng; mỗi phòng thuộc duy nhất một khu vực. |
| **BR02** | Mỗi phòng có sức chứa tối đa (`> 0`) và đơn giá thuê theo ngày (`>= 0`). |
| **BR03** | Mỗi tiện nghi có số thứ tự phân biệt duy nhất trong cùng một loại tiện nghi. |
| **BR04** | Trong một ngày, một thiết bị tiện nghi chỉ được trang bị cho một phòng duy nhất. |
| **BR05** | Phiếu đặt phòng ghi nhận phòng, ngày nhận, ngày trả dự kiến (`>= ngày nhận`) và tiền cọc. |
| **BR06** | Ghi nhận đầy đủ họ tên, số CCCD/CMND và quốc tịch của từng người lưu trú thực tế. |
| **BR07** | Cùng một dịch vụ sử dụng nhiều lần trong cùng một ngày được cộng dồn số lượng thành một dòng. |
| **BR08** | Khi phát hiện hư hỏng/mất mát lúc trả phòng, lập phiếu đền bù theo tiện nghi và mức độ thiệt hại. |
| **BR09** | Tổng tiền hóa đơn bao gồm tiền thuê phòng (`Đơn giá ngày × Số ngày`) và tiền sử dụng dịch vụ. |
| **BR10** | Hỗ trợ 4 phương thức thanh toán: `Tiền mặt`, `Chuyển khoản`, `Thẻ`, `Ví điện tử`. |

---

## 👥 3. Phân quyền Actor & Chức năng (Use Cases)

Hệ thống gồm 1 Actor tổng quát (**Nhân viên**) và 4 Actor chuyên biệt kế thừa từ Nhân viên:

| Actor | Vai trò & Chức năng chính | Màn hình thao tác |
| :--- | :--- | :--- |
| **Nhân viên** | Quản lý danh mục nền; Ghi nhận sử dụng dịch vụ | `FrmMain`, `FrmDanhMuc`, `FrmDichVu` |
| **NV Lễ tân** | Quản lý khách hàng; Đặt phòng; Ghi nhận người lưu trú; Nhận phòng; Đánh dấu No-show | `FrmDatPhong` |
| **NV Phục vụ phòng** | Quản lý phòng & tiện nghi; Lập phiếu lắp đặt/luân chuyển; Kiểm tra tiện nghi & lập đền bù | `FrmPhongTienNghi`, `FrmTraPhong` |
| **NV Thanh toán** | Lập phiếu đền bù; Lập hóa đơn; Ghi nhận giao dịch thanh toán; Hoàn tất trả phòng | `FrmTraPhong` |
| **Quản lý** | Tra cứu dữ liệu tổng hợp & Thống kê doanh thu dịch vụ theo thời gian | `FrmThongKe` |

---

## 🏗️ 4. Kiến trúc & Cấu trúc thư mục dự án

Ứng dụng được thiết kế theo kiến trúc phân tầng rõ ràng: **`WinForms UI (Forms)` ➔ `Business Logic (Services)` ➔ `Data Access (Data/Db.cs)` ➔ `SQL Server`**. Các thao tác cập nhật nhiều bảng đều được bọc trong `SqlTransaction` để đảm bảo tính toàn vẹn dữ liệu.

```text
LAB_OOSD/
└── lab3/
    ├── Database/
    │   └── QuanLyKhachSan.sql           # Script khởi tạo CSDL, 18 bảng, ràng buộc & dữ liệu mẫu
    ├── QuanLyKhachSan/
    │   ├── Data/
    │   │   └── Db.cs                    # Lớp kết nối SQL Server & các hàm Query, Execute, Scalar
    │   ├── Services/
    │   │   ├── KetQuaXuLy.cs            # Đối tượng trả về trạng thái xử lý (Thành công / Thông báo)
    │   │   ├── DanhMucService.cs        # Xử lý Khu vực, Nhân viên, Loại TN, Dịch vụ, Quy định đền bù
    │   │   ├── PhongTienNghiService.cs  # Xử lý Phòng, Tiện nghi và Phiếu lắp đặt
    │   │   ├── DatPhongService.cs       # Xử lý Khách hàng, Đặt phòng, Trùng lịch, Nhận phòng, No-show
    │   │   ├── DichVuService.cs         # Xử lý ghi nhận và cộng dồn dịch vụ trong ngày
    │   │   ├── TraPhongService.cs       # Xử lý Đền bù, Hóa đơn, Thanh toán và Trả phòng
    │   │   └── ThongKeService.cs        # Xử lý truy vấn thống kê tổng hợp và thống kê dịch vụ
    │   ├── Forms/
    │   │   ├── FrmMain.cs               # Màn hình điều hướng chính
    │   │   ├── FrmDanhMuc.cs            # Quản lý 5 danh mục nền
    │   │   ├── FrmPhongTienNghi.cs      # Quản lý phòng, thiết bị và lắp đặt
    │   │   ├── FrmDatPhong.cs           # Quản lý khách, lập phiếu đặt và nhận phòng
    │   │   ├── FrmDichVu.cs             # Ghi nhận dịch vụ cho phòng đang ở
    │   │   ├── FrmTraPhong.cs           # Lập đền bù, hóa đơn, thu tiền và trả phòng
    │   │   └── FrmThongKe.cs            # Báo cáo thống kê theo khoảng thời gian
    │   ├── App.config                   # Cấu hình chuỗi kết nối QuanLyKhachSanDB
    │   ├── Program.cs                   # Điểm khởi chạy ứng dụng
    │   └── QuanLyKhachSan.csproj        # File cấu hình Project C#
    ├── QLKS_BAOCAO.docx                 # Báo cáo phân tích thiết kế UML đầy đủ
    ├──QuanLyKhachSan.sln                # File Solution Visual Studio 2022
    └── README.md                        # Tài liệu hướng dẫn dự án
