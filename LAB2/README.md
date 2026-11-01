**# 🛠️ LAB 2: Thiết kế Hệ thống, Biểu đồ Lớp & Đặc tả Giao diện (UI)

## 👨‍🎓 Thông tin sinh viên
* **Họ và tên:** Mai Phước Sang
* **MSSV:** 1250080159
* **Môn học:** Phân tích và Thiết kế Hướng đối tượng (OOSD)

---

## 🎯 Mục tiêu bài Lab
Bài thực hành số 2 tiếp nối kết quả phân tích từ Lab 1, đi sâu vào việc thiết kế hành vi và cấu trúc tĩnh của hệ thống thông qua **Biểu đồ Trạng thái (State Machine Diagram)**, **Biểu đồ Lớp (Class Diagram)** theo kiến trúc phân tầng, và **Thiết kế chi tiết Giao diện người dùng (UI Specification)**.

---

## 🔄 1. Thiết kế Biểu đồ Trạng thái (State Diagram)

### 1.1. Trạng thái Phiếu mượn sách
Mô tả vòng đời của một phiếu mượn từ khi độc giả đăng ký:
* **Đã đăng ký:** Khi gọi `DangKyMuon()` (điều kiện: thẻ còn hạn, còn sách). Hệ thống lưu chi tiết phiếu mượn và giảm số lượng sách còn (`SoLuongCon = SoLuongCon - 1`).
  * Nếu hủy (`HuyDangKy()`) $\rightarrow$ Chuyển sang trạng thái **Hủy** (hoàn lại số lượng sách `SoLuongCon + 1`).
* **Đang mượn:** Khi thủ thư xác nhận (`XacNhanChoMuon()`), ghi nhận `NgayMuon`, `NgayHenTra`. Tại đây có sự kiện tự gọi `GuiNhacHan()` khi còn 3 ngày đến hạn.
* **Quá hạn:** Khi vượt quá ngày hẹn trả (`hôm nay > NgayHenTra`), hệ thống đánh dấu quá hạn.
* **Đã trả:** Khi độc giả trả sách (`TraSach()`) từ trạng thái *Đang mượn* hoặc *Quá hạn*. Hệ thống ghi nhận `NgayTra` và cộng lại số lượng sách tồn (`SoLuongCon = SoLuongCon + 1`).

### 1.2. Trạng thái Yêu cầu Đặt mua Tài liệu
* **Chờ duyệt:** Khởi tạo khi độc giả đã đăng nhập và gửi yêu cầu (`GuiYeuCauMua()`).
* **Đã chấp nhận:** Khi thủ thư duyệt (`ChapNhan()`), cập nhật trạng thái thành *Đã chấp nhận*.
* **Từ chối:** Khi thủ thư từ chối (`TuChoi(lyDo)`), hệ thống ghi nhận lý do từ chối và kết thúc quy trình.

---

## 🏗️ 2. Thiết kế Biểu đồ Lớp (Class Diagram)

### 2.1. Biểu đồ Lớp Thực thể (Domain Class Diagram)
Hệ thống bao gồm các lớp thực thể cốt lõi và mối quan hệ chặt chẽ:
* **Nhóm Tài liệu:** `TaiLieu` (lớp cha) kế thừa ra `SachIn` (quản lý `SoLuongTong`, `SoLuongCon`, `ViTriKe`) và `TaiLieuDienTu` (quản lý `DuongDan`, `DinhDang`, `DungLuong`). Liên kết với các lớp danh mục `LoaiTaiLieu`, `ChuDe`, `TacGia`.
* **Nhóm Người dùng & Thẻ:** `DocGia`, `ThuThu`, `TaiKhoan`, `TheThuVien`, `LuotTai`, `YeuCauMua`.
* **Nhóm Mượn trả:** `PhieuMuon` kết hợp chặt (Composition) với `ChiTietPhieuMuon`, và liên kết với `ThongBaoNhacHan`.

### 2.2. Thiết kế Lớp theo chức năng (Kiến trúc BCE / 3-Layer)
Ví dụ minh họa cho chức năng **Đăng ký mượn sách**:
* **Lớp Giao diện (Boundary):** `FrmMuonSach` (Xử lý các sự kiện `Frm_Load()`, `Tai()`, `btnDangKy_Click()`, `btnDong_Click()`).
* **Lớp Điều khiển (Control/Service):** `MuonSachService` (Chứa các phương thức xử lý nghiệp vụ: `LaySachIn()`, `LayPhieuMuon()`, `LayChiTiet()`, `DangKyMuon()`).
* **Lớp Thực thể (Entity):** `TheThuVien`, `SachIn`, `PhieuMuon`, `ChiTietPhieuMuon`.

---

## 🖥️ 3. Đặc tả Giao diện Người dùng (UI Design)
Giao diện ứng dụng Desktop (WinForms) được thiết kế chi tiết gồm **6 màn hình chính**:

| STT | Tên Form | Mục đích chính | Các kiểm soát & Ràng buộc (Validation) nổi bật |
| :-: | :--- | :--- | :--- |
| **01** | `FrmMain` | Màn hình điều hướng chính của hệ thống | Gồm 6 nút điều hướng mở các Form con bằng `ShowDialog(this)`. Nút *Thoát* có hộp thoại xác nhận `Yes/No`. |
| **02** | `FrmDanhMuc` | Quản lý CRUD Nhân viên, Thể loại, Nhà xuất bản (chia theo 3 Tab) | Khóa (`ReadOnly`) mã khi đang ở chế độ Cập nhật; chặn xóa danh mục khi đang có khóa ngoại (FK) tham chiếu. |
| **03** | `FrmSach` | Quản lý CRUD và tìm kiếm đầu sách theo mã/tên | Số lượng hiện có $\ge 0$; Năm xuất bản hợp lệ ($1000 \dots \text{năm hiện tại} + 1$); chọn Thể loại và NXB từ `ComboBox`. |
| **04** | `FrmDocGia` | Quản lý thông tin độc giả, Cấp thẻ mới và Gia hạn thẻ | Không cấp thẻ thứ 2 khi thẻ hiện tại còn hiệu lực (`TrangThai = 1`); `HanSuDung >= NgayCap`; kiểm tra định dạng Email chứa `@`. |
| **05** | `FrmMuonTra` | Lập phiếu mượn (Tab 1) và Nhận trả sách / Tính phạt (Tab 2) | **Tab Mượn:** Chặn thẻ hết hạn/chưa đóng phí, còn sách quá hạn, mượn tối đa 3 cuốn, không trùng đầu sách.<br>**Tab Trả:** Trả trễ/mất/hư hỏng bắt buộc nhập `PhiPhat > 0`. Sử dụng Transaction `Serializable` để đảm bảo toàn vẹn dữ liệu. |
| **06** | `FrmThongKe` | Thống kê lượt mượn, quá hạn, mất, hư hỏng và tổng phí phạt theo thời gian | Hiển thị 5 chỉ số KPI và bảng chi tiết phiếu phạt. Tự động đảo thứ tự nếu người dùng chọn `Đến ngày < Từ ngày`. |

---

## 📁 Tài liệu đính kèm trong Lab 2
* Thiết kế sơ đồ UML (State Diagram, Class Diagram).
* File đặc tả giao diện Excel: `GiaoDien_MAIPHUOCSANG_1250080159.xlsx`.
* Báo cáo tổng hợp: `BAOCAOLAB1VA2.docx`.**
