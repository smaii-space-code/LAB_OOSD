HỆ THỐNG QUẢN LÝ CỬA HÀNG NƯỚC GIẢI KHÁT

Đồ án môn học Phương pháp Phát triển Phần mềm Hướng đối tượng (OOSD). Dự án ứng dụng C# WinForms và SQL Server để tin học hóa quy trình quản lý mua bán, nhập hàng và theo dõi công nợ cho cửa hàng nước giải khát.

👨‍🎓 THÔNG TIN SINH VIÊN

Họ và tên: Mai Phước Sang

Mã số sinh viên (MSSV): 1250080159

Lớp học phần: 12CNPM2

Giảng viên hướng dẫn: ThS. Phạm Trọng Huynh

🌟 TỔNG QUAN DỰ ÁN

Hệ thống được thiết kế để đáp ứng toàn bộ các nghiệp vụ thực tế của một cửa hàng nước giải khát, bao gồm 4 nhóm chức năng cốt lõi:

Quản lý Hàng hóa & Đối tác:

Quản lý danh mục Nước giải khát (NGK) theo nhãn hiệu.

Quản lý thông tin Nhà cung ứng và Khách hàng (Khách vãng lai, Khách quen).

Quản lý Nhập hàng:

Lập Đơn đặt hàng (ĐĐH) gửi Nhà cung ứng.

Xử lý nhận hàng tối đa 3 đợt/ĐĐH kèm Phiếu giao hàng & cập nhật tồn kho.

Quản lý Bán hàng & Tồn kho:

Lập Đơn đặt hàng cho khách, xuất kho và giao hàng.

Xử lý tự động lập Phiếu hẹn giao nhiều đợt nếu kho không đủ hàng.

Quản lý Thanh toán & Công nợ:

Khách vãng lai: Thanh toán và lập Phiếu thu 100% ngay tại quầy.

Khách quen: Cho phép trả chậm bằng cách lập Phiếu ghi nợ (kiểm soát chặt chẽ theo hạn mức nợ).

🛠 CÔNG NGHỆ SỬ DỤNG

Ngôn ngữ lập trình: C# (WinForms)

Framework: .NET Framework 4.7.2

Cơ sở dữ liệu: Microsoft SQL Server (T-SQL, Stored Procedures, Transaction)

Công nghệ truy xuất dữ liệu: ADO.NET

Công cụ thiết kế UML: PlantUML / StarUML / Draw.io

📂 CẤU TRÚC THƯ MỤC GITHUB (LAB8)

LAB8/
├── code/                                       # Source code C# WinForms
│   ├── QuanLyCuaHangNGK.sln                    # File Solution Visual Studio
│   └── QuanLyCuaHangNGK/
│       ├── App.config                          # File cấu hình chuỗi kết nối DB
│       ├── Program.cs
│       ├── Data/                               # Chứa các file giao tiếp CSDL (Db.cs)
│       └── Services/                           # Chứa logic nghiệp vụ (Services)
├── Database/                                   # Kịch bản Cơ sở dữ liệu
│   └── QuanLyCuaHangNGK_DB.sql                 # Script tạo DB, Tables, và Data mẫu
├── filesodo/                                   # Chứa hình ảnh sơ đồ thiết kế hệ thống
│   ├── 1. Use Case - Tong quat.jpg
│   ├── 2. Class Diagram.jpg
│   ├── 3. Use Case chi tiet.jpg
│   ├── 4. Activity Diagram.jpg
│   └── 5. Sequence - Phieu Ghi No.jpg
├── 1250080159_MAIPHUOCSANG_Bai2_NuocGiaiKhat.docx  # File báo cáo Word hoàn chỉnh
└── README.md                                   # File tài liệu dự án (bạn đang đọc)


🚀 HƯỚNG DẪN CÀI ĐẶT & CHẠY ỨNG DỤNG

Bước 1: Khởi tạo Cơ sở dữ liệu

Mở SQL Server Management Studio (SSMS).

Mở file Database/QuanLyCuaHangNGK_DB.sql.

Nhấn Execute (F5) để hệ thống tự động tạo Database QuanLyCuaHangNGK, các bảng (Tables) và ràng buộc.

Bước 2: Cấu hình ứng dụng

Mở file code/QuanLyCuaHangNGK.sln bằng Visual Studio 2022.

Mở file App.config trong thư mục project.

Tìm đến thẻ <connectionStrings> và cập nhật Data Source (Server Name) cho khớp với SQL Server của máy bạn:

<add name="QuanLyCuaHangNGK_DB" 
     connectionString="Data Source=TEN_MAY_CUA_BAN;Initial Catalog=QuanLyCuaHangNGK;Integrated Security=True;TrustServerCertificate=True" 
     providerName="System.Data.SqlClient" />


Bước 3: Khởi chạy

Nhấn Start (F5) trên Visual Studio để build và chạy ứng dụng.

Bản quyền thuộc về Mai Phước Sang - Dự án thực hành LAB8 - Môn học OOSD.
