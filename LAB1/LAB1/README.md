LAB 1: Khảo sát Nghiệp vụ & Phân tích Yêu cầu Hệ thống Thư viện Trực tuyến

## 👨‍🎓 Thông tin sinh viên
* **Họ và tên:** Mai Phước Sang
* **MSSV:** 1250080159
* **Môn học:** Phân tích và Thiết kế Hướng đối tượng (OOSD)

---

## 🎯 Mục tiêu bài Lab
Bài thực hành số 1 tập trung vào việc khảo sát hiện trạng, xác định yêu cầu nghiệp vụ của **Hệ thống Thư viện Trực tuyến** (triển khai trên mạng nội bộ Intranet của trường) và mô hình hóa các chức năng thông qua biểu đồ Use Case.

---

## 📋 1. Tổng quan Hoạt động Nghiệp vụ
Hệ thống phục vụ nhu cầu học tập và tra cứu của **Độc giả** (giảng viên, sinh viên, CBNV) và công tác quản lý của **Thủ thư**:
* **Quản lý tài liệu:** Chia làm 2 nhóm chính là *Tài liệu điện tử* (đọc trực tuyến, tải về) và *Sách in* (đăng ký mượn tại thư viện).
* **Thẻ thư viện:** Mỗi độc giả được cấp một Mã thẻ thư viện dùng để xác thực khi tải tài liệu điện tử hoặc đăng ký mượn sách in.
* **Đặt mua tài liệu:** Độc giả có tài khoản và đăng nhập có thể gửi yêu cầu đặt mua tài liệu điện tử mới.
* **Quản lý mượn - trả & Danh mục:** Thủ thư quản lý việc mượn/trả sách, theo dõi sách quá hạn, cập nhật danh mục tài liệu (thêm, sửa, xóa) và xét duyệt yêu cầu đặt mua từ độc giả.
* **Tự động hóa & Thống kê:** Hệ thống tự động gửi email nhắc nhở độc giả trước hạn trả sách 3 ngày và hỗ trợ xuất các báo cáo thống kê.

---

## ⚙️ 2. Phân tích Yêu cầu Hệ thống

### 2.1. Bảng Đầu vào - Xử lý - Xuất kết quả (IPO)
| Nhóm nghiệp vụ | Đầu vào | Xử lý chính | Xuất kết quả |
| :--- | :--- | :--- | :--- |
| **Tìm kiếm tài liệu** | Loại tài liệu, tên sách, chủ đề, tác giả, năm XB, từ khóa | Truy vấn tài liệu theo một hoặc nhiều tiêu chí | Danh sách tài liệu phù hợp; thông báo nếu không tìm thấy |
| **Đọc / Tải tài liệu điện tử** | Tài liệu được chọn; Mã thẻ thư viện (khi tải về) | Cho đọc trực tuyến; kiểm tra Mã thẻ trước khi cho phép tải | Nội dung đọc trực tuyến; tệp tải về; thông báo lỗi nếu thẻ không hợp lệ |
| **Đăng ký mượn sách** | Sách in được chọn; Mã thẻ thư viện | Kiểm tra Mã thẻ và số lượng sách còn; lưu thông tin đăng ký | Phiếu đăng ký mượn; cập nhật số lượng sách còn lại |
| **Đăng ký / Đăng nhập** | Thông tin đăng ký; Tên đăng nhập, mật khẩu | Tạo tài khoản mới; xác thực thông tin đăng nhập | Tài khoản mới; thông báo trạng thái đăng nhập |
| **Đặt mua tài liệu điện tử** | Tên sách, tác giả, năm XB; tài khoản đã đăng nhập | Kiểm tra trạng thái đăng nhập; lưu yêu cầu đặt mua | Yêu cầu đặt mua ở trạng thái *Chờ duyệt* |
| **Duyệt yêu cầu đặt mua** | Danh sách yêu cầu; quyết định của thủ thư | Chấp nhận hoặc từ chối yêu cầu; cập nhật trạng thái | Kết quả xử lý yêu cầu (*Đã chấp nhận* / *Từ chối*) |
| **Quản lý mượn - trả sách** | Mã thẻ, sách, ngày mượn, hạn trả, ngày trả | Ghi nhận mượn/trả; cập nhật số lượng tồn; xác định quá hạn | Phiếu mượn - trả; danh sách sách đang mượn và quá hạn |
| **Cập nhật danh mục** | Thông tin sách in và tài liệu điện tử | Thêm, sửa, xóa tài liệu; kiểm tra dữ liệu bắt buộc | Danh mục tài liệu sau khi cập nhật |
| **Nhắc hạn trả sách** | Hạn trả sách; địa chỉ email của độc giả | Tự động lọc độc giả còn 3 ngày đến hạn trả; gửi email | Email thông báo thời hạn trả sách |
| **Báo cáo - Thống kê** | Khoảng thời gian, tiêu chí thống kê | Tổng hợp dữ liệu mượn trả, tài liệu, yêu cầu đặt mua | Báo cáo chi tiết, bảng thống kê |

### 2.2. Phân loại công việc theo Tác nhân (Actors)
* **Độc giả:** Tìm kiếm tài liệu (Tra cứu), Đọc trực tuyến & tải tài liệu điện tử (Tra cứu), Đăng ký mượn sách in (Lưu trữ/Tra cứu), Đăng ký tài khoản & Đăng nhập (Lưu trữ), Đặt mua tài liệu điện tử (Lưu trữ).
* **Thủ thư:** Kế thừa toàn bộ quyền của Độc giả, bổ sung: Quản lý mượn - trả sách (Lưu trữ/Tính toán), Xem tình trạng mượn & quá hạn (Tra cứu), Cập nhật danh mục tài liệu (Lưu trữ), Duyệt yêu cầu đặt mua (Lưu trữ), Tạo báo cáo thống kê (Tổng hợp/Kết xuất).
* **Hệ thống (Email):** Gửi email nhắc hạn trả sách tự động trước 3 ngày (Tính toán/Kết xuất).

---

## 📊 3. Mô hình hóa Use Case

### 3.1. Biểu đồ Use Case Tổng quát
Mô tả toàn bộ sự tương tác giữa 3 tác nhân chính (**Độc giả**, **Thủ thư**, **Hệ thống email**) với các chức năng của Hệ thống Thư viện Trực tuyến, bao gồm các mối quan hệ `<<include>>` (như *Kiểm tra mã thẻ thư viện*, *Đăng nhập*) và `<<extend>>` (như *Đăng ký tài khoản*).

### 3.2. Biểu đồ Use Case Phân rã
1. **Phân rã chức năng Quản lý mượn - trả sách:**
   * `Ghi nhận mượn sách` $\xrightarrow{\text{<<include>>}}$ `Kiểm tra số lượng sách còn`
   * `Ghi nhận trả sách` $\xrightarrow{\text{<<include>>}}$ `Tìm phiếu mượn của độc giả`
2. **Phân rã chức năng Theo dõi tình trạng mượn sách:**
   * Mở rộng (`<<extend>>`) ra các chức năng: `Xem tài liệu đang được mượn`, `Xem tình trạng mượn quá hạn`, và `Xem thông tin một quyển sách`.

---

## 📁 Cấu trúc thư mục Lab 1
* `BAOCAOLAB1VA2.docx`: File báo cáo tổng hợp chi tiết.
* `lab dac ta.docx`: Tài liệu đặc tả yêu cầu hệ thống.
* `1250080159_MAI PHUOC SANG...`: Bài làm nộp cá nhân.
* `README.md`: Tài liệu hướng dẫn và tóm tắt nội dung Lab 1.
