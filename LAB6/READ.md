Quản lý hồ sơ bệnh án
Ứng dụng desktop hỗ trợ quản lý thông tin bệnh nhân, hồ sơ bệnh án và một số nghiệp vụ khám chữa bệnh tại bệnh viện. Đây là sản phẩm thực hành được xây dựng bằng C# Windows Forms, dựa trên phạm vi đề tài Quản lý hồ sơ bệnh án của bệnh nhân.
1. Mục tiêu
- Quản lý thông tin bệnh nhân và hồ sơ bệnh án.
- Hỗ trợ tra cứu và cập nhật thông tin khám bệnh.
- Quản lý danh mục chuyên môn và dịch vụ.
- Ghi nhận chỉ định, kết quả xét nghiệm và đơn thuốc.
- Hỗ trợ thanh toán viện phí và xem thống kê.
Lưu ý: Báo cáo mô tả phạm vi phân tích, thiết kế rộng hơn phần demo hiện tại. Không nên xem các chức năng được mô tả trong báo cáo là đã được triển khai đầy đủ trong ứng dụng.

2. Công nghệ sử dụng
- Ngôn ngữ: C#
- Giao diện: Windows Forms
- Nền tảng: .NET Framework 4.7.2
- Lưu trữ dữ liệu của bản demo: DataSet và tệp XML trên máy đang chạy ứng dụng
- Môi trường phát triển phù hợp: Visual Studio hỗ trợ .NET Framework 4.7.2
Ứng dụng hiện không cấu hình kết nối SQL Server trong mã nguồn được cung cấp.
3. Các chức năng chính
- Màn hình chính: điều hướng đến các nhóm chức năng.
- Danh mục: quản lý các danh mục nghiệp vụ có trong bản demo.
- Bệnh nhân và hồ sơ bệnh án: xem và thao tác với thông tin bệnh nhân, hồ sơ.
- Khám bệnh: hỗ trợ nghiệp vụ khám bệnh theo chức năng đã triển khai.
- Xét nghiệm – đơn thuốc: thao tác với thông tin xét nghiệm và đơn thuốc theo phạm vi demo.
- Thanh toán: hỗ trợ các thao tác thanh toán được triển khai.
- Thống kê: xem dữ liệu thống kê theo chức năng hiện có.
Phạm vi cụ thể của từng màn hình phụ thuộc vào mã nguồn hiện tại; một số chức năng trong báo cáo thiết kế có thể chưa hoàn thiện trong bản demo.
4. Cấu trúc dự án
QuanLyBenhAn/
├── QuanLyBenhAn.sln
└── QuanLyBenhAn/
    ├── App.config
    ├── Program.cs
    ├── QuanLyBenhAn.csproj
    ├── Data/
    │   └── Db.cs
    ├── Forms/
    │   ├── FrmMain.cs
    │   ├── FrmDanhMuc.cs
    │   ├── FrmHoSoBenhAn.cs
    │   ├── FrmKhamBenh.cs
    │   ├── FrmXetNghiem.cs
    │   ├── FrmThanhToan.cs
    │   └── FrmThongKe.cs
    ├── Services/
    │   ├── DanhMucService.cs
    │   ├── DichVuService.cs
    │   ├── HoSoBenhAnService.cs
    │   └── KetQuaXuLy.cs
    └── Properties/
- Program.cs: khởi tạo dữ liệu và mở màn hình chính.
- Data/Db.cs: khởi tạo cấu trúc dữ liệu, nạp dữ liệu và lưu dữ liệu XML.
- Forms/: chứa các màn hình giao diện.
- Services/: chứa các lớp xử lý nghiệp vụ.
5. Cách mở và chạy chương trình
1. Tải hoặc clone repository về máy.
2. Giải nén nếu tải về dưới dạng ZIP.
3. Mở file QuanLyBenhAn.sln bằng Visual Studio.
4. Chọn cấu hình Debug và nền tảng phù hợp.
5. Build solution để kiểm tra lỗi biên dịch.
6. Chạy dự án QuanLyBenhAn.
Máy cần có môi trường .NET Framework 4.7.2 hoặc công cụ phát triển tương thích.
6. Dữ liệu ứng dụng
Bản demo lưu dữ liệu tại thư mục dữ liệu cục bộ của người dùng Windows:
%LocalAppData%\QuanLyBenhAn_Lab\DuLieu.xml
Khi khởi động lần đầu, ứng dụng có thể tạo dữ liệu minh họa để phục vụ việc thử nghiệm. Nếu cần làm mới dữ liệu, hãy sao lưu tệp XML trước khi thay đổi hoặc xóa dữ liệu.
Không sử dụng dữ liệu bệnh nhân thật hoặc thông tin sức khỏe nhạy cảm trong bản demo hay repository công khai.
7. Phạm vi và hạn chế
- Đây là ứng dụng thực hành phục vụ học tập và minh họa nghiệp vụ.
- Bản demo chưa triển khai đầy đủ mọi chức năng được phân tích trong báo cáo.
- Mã nguồn hiện tại sử dụng lưu trữ XML cục bộ, không phải hệ quản trị cơ sở dữ liệu dùng chung.
- Không nên sử dụng ứng dụng cho hoạt động khám chữa bệnh thực tế khi chưa được kiểm thử, đánh giá bảo mật và hoàn thiện nghiệp vụ.
8. Tác giả
- Sinh viên: Mai Phước Sang
- Mã số sinh viên: 1250080159
- Lớp: 12CNPM2
- Đề tài: Quản lý hồ sơ bệnh án của bệnh nhân
