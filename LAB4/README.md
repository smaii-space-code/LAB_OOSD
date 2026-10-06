# LAB 4: PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG e-SHOPPING

## Giới thiệu
Đây là dự án phân tích và thiết kế hệ thống phần mềm cửa hàng online "e-SHOPPING" thuộc LAB 4[cite: 2, 3]. Hệ thống được thiết kế theo kiến trúc 3 lớp (3-Tier) bao gồm UI Tier, Service/Adapter Tier và Data Tier (DAL), có khả năng tương tác với các hệ thống bên ngoài (Hệ thống quản lý sản phẩm, Hệ thống thanh toán trực tuyến và Hệ thống Email)[cite: 2].

## Cấu trúc thư mục
Thư mục `LAB4` bao gồm các tệp tin sau[cite: 3]:
- `BÁO CÁO LAB4.docx`: Tài liệu báo cáo chi tiết về quá trình phân tích, thiết kế mô hình UML, cơ sở dữ liệu và hiện thực giao diện[cite: 2, 3].
- `sc.zip`: Mã nguồn (source code) chứa Prototype của dự án[cite: 3].
- `README.md`: Tệp tin thông tin dự án[cite: 3].

## Nội dung Phân tích và Thiết kế
Dự án thực hiện các bước phân tích và thiết kế phần mềm chi tiết như sau:

1. **Mô hình UML - Pha Phân tích:**
   - **Biểu đồ Use Case:** Xác định các tác nhân (Khách hàng, Hệ thống bên ngoài) và các chức năng hệ thống[cite: 2].
   - **Biểu đồ Lớp Phân tích:** Xác định các thực thể chính như Khách Hàng, Đơn Đặt Hàng, Sản Phẩm, Thẻ Tín Dụng...[cite: 2].

2. **Mô hình UML - Pha Phân tích Hành vi:**
   - **Biểu đồ Trạng thái:** Mô tả vòng đời của một Đơn Đặt Hàng từ lúc khởi tạo đến khi thanh toán thành công, hoặc bị từ chối/hủy[cite: 2].
   - **Biểu đồ Tuần tự:** Xây dựng luồng tương tác chi tiết cho nghiệp vụ "Đặt mua hàng và Tính tiền"[cite: 2].

3. **Mô hình UML - Pha Thiết kế:**
   - **Biểu đồ Hoạt động:** Mô tả luồng thực thi (Control Flow) với 3 phân làn (Khách hàng, Hệ thống e-SHOPPING, Hệ thống Thanh toán)[cite: 2].
   - **Biểu đồ Lớp Thiết kế:** Ánh xạ các thực thể thành các lớp C# cụ thể áp dụng kiến trúc 3-Tier (WinForms, Services, DAO)[cite: 2].

4. **Cơ sở dữ liệu:**
   - Thiết kế CSDL quan hệ trên Microsoft SQL Server với tên CSDL là `eSHOPPING` (bao gồm các bảng Khách Hàng, Đơn Đặt Hàng, Chi Tiết Đơn Hàng...)[cite: 2].

5. **Prototype Hệ thống:**
   - Xây dựng giao diện mô phỏng (SANG MAI E-SHOPPING) bằng công nghệ **C# WinForms (.NET 4.7.2)**[cite: 2].
   - Các Form chức năng chính bao gồm: Đăng ký, Đăng nhập, Bảng điều khiển (Main), Sản phẩm, Giỏ hàng, Thanh toán, và Xác nhận đơn hàng[cite: 2].

## Hướng dẫn cài đặt và sử dụng
1. Tải về và giải nén tệp tin mã nguồn `sc.zip`[cite: 3].
2. Chạy tệp script SQL (nếu có) hoặc đính kèm CSDL `eSHOPPING` vào Microsoft SQL Server của bạn[cite: 2].
3. Mở Solution bằng Visual Studio.
4. Cấu hình lại chuỗi kết nối (`connectionString`) trong file cấu hình để trỏ đến server SQL của bạn[cite: 2].
5. Build và Run dự án để trải nghiệm các chức năng[cite: 2].
