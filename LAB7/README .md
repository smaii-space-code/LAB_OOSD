Ệ THỐNG QUẢN LÝ NHÂN SỰ - CÔNG TY SƠN ĐÔNG Á

Đồ án thực hành môn Phương pháp Phát triển Phần mềm Hướng đối tượng (OOSD) - Bài 7.
Dự án ứng dụng phân tích thiết kế hướng đối tượng, xây dựng hệ thống phần mềm (C# WinForms & SQL Server) để tin học hóa quy trình quản lý nhân sự từ khâu tuyển dụng, ký hợp đồng, chấm công đến tính lương và khen thưởng, kỷ luật tại Công ty Sơn Đông Á.

👨‍🎓 THÔNG TIN SINH VIÊN

Họ và tên: Mai Phước Sang

Mã số sinh viên (MSSV): 1250080159

Lớp học phần: 12_CNPM2

Môn học: Phương pháp phát triển phần mềm hướng đối tượng

🌟 TỔNG QUAN NGHIỆP VỤ HỆ THỐNG

Hệ thống được thiết kế để giải quyết các bài toán quản trị nhân sự thực tế, bao gồm 5 phân hệ chính:

Tuyển dụng & Thử việc:

Quản lý Quyết định tuyển dụng, ghi rõ thời gian thử việc, phòng ban, mức lương và các điều khoản.

Đánh giá và ra quyết định tiếp nhận chính thức.

Hợp đồng & Bảo hiểm:

Ký kết hợp đồng lao động (Ngắn hạn / Dài hạn).

Lập hồ sơ trích nộp Bảo hiểm Y tế (BHYT) và Bảo hiểm Xã hội (BHXH) đối với nhân viên hợp đồng dài hạn.

Quản lý Quyết định & Phụ cấp:

Lập Quyết định chức vụ (kèm phụ cấp chức vụ).

Lập Quyết định lương (lương cơ bản, phụ cấp lương, phụ cấp độc hại).

Phân công, Chấm công & Phụ trội:

Lập kế hoạch phân công ca làm việc hằng tuần.

Ghi nhận chấm công thực tế.

Lập phiếu ghi nhận giờ phụ trội (tăng ca, ngày lễ, ngày nghỉ) với hệ số nhân 1.5.

Tính lương, Khen thưởng & Kỷ luật:

Lập Quyết định khen thưởng / kỷ luật cho cá nhân hoặc tập thể phòng ban.

Quản lý chi thưởng (phiếu chi), thu phạt (phiếu thu) hoặc trừ trực tiếp vào lương.

Tự động tổng hợp dữ liệu chấm công, phụ cấp, giờ phụ trội và các khoản khấu trừ (BHXH, phạt) để lập Bảng lương hằng tháng.

🛠 CÔNG NGHỆ SỬ DỤNG

Ngôn ngữ lập trình: C# (Windows Forms)

Cơ sở dữ liệu: Microsoft SQL Server (T-SQL)

Kiến trúc thiết kế: Phân tích & Thiết kế Hướng đối tượng (OOSD)

Công cụ vẽ UML: PlantUML / Draw.io / StarUML

📂 CẤU TRÚC THƯ MỤC GITHUB (LAB7)

LAB7/
├── Code/                                       # Source code C# WinForms
│   └── QuanLyNhanSu.sln                        # File Solution Visual Studio
├── database/                                   # Kịch bản Cơ sở dữ liệu
│   ├── QuanLyNhanSu_DB.sql                     # Script khởi tạo Database, Tables
│   └── readme.md                               # Hướng dẫn riêng cho DB (nếu có)
├── sodo/                                       # Chứa hình ảnh sơ đồ phân tích thiết kế UML
│   ├── 1. Use Case - Quan ly nhan su.png
│   ├── 2. Class Diagram.png
│   ├── 3. Use Case chi tiet.png
│   ├── 4. Activity Diagram.png
│   └── 5. Sequence - Khen thuong.png
├── 1250080159_MAIPHUOCSANG_12CNPM2_QLNS.docx   # File báo cáo Word chi tiết
└── README.md                                   # File tài liệu dự án (bạn đang đọc)


🚀 HƯỚNG DẪN CÀI ĐẶT & CHẠY ỨNG DỤNG

Bước 1: Khởi tạo Cơ sở dữ liệu

Mở hệ quản trị CSDL SQL Server Management Studio (SSMS).

Mở file script database/QuanLyNhanSu_DB.sql.

Nhấn Execute (F5) để hệ thống tự động tạo Database, các bảng (Tables) và ràng buộc dữ liệu.

Bước 2: Cấu hình ứng dụng

Mở file Solution Code/QuanLyNhanSu.sln bằng Visual Studio 2022.

Tìm đến file App.config (nếu có) trong project.

Cập nhật chuỗi kết nối (ConnectionString) sao cho thuộc tính Data Source trỏ đúng vào tên Server SQL của máy bạn.

Bước 3: Khởi chạy

Nhấn Start (F5) trên Visual Studio để build và chạy ứng dụng.

Bản quyền thuộc về Mai Phước Sang - Đồ án thực hành LAB7 - Môn học OOSD.
