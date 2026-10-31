# BÁO CÁO THỰC HÀNH LAB 00
## HỌC PHẦN: PHƯƠNG PHÁP PHÁT TRIỂN PHẦN MỀM HƯỚNG ĐỐI TƯỢNG

- **Sinh viên thực hiện:** Mai Phước Sang
- **Mã số sinh viên (MSSV):** 1250080159
- **Email:** 1250080159@sv.hcmunre.edu.vn
- **Trường:** Đại học Tài nguyên và Môi trường TP.HCM (HCMUNRE)
- **Hệ điều hành:** Windows 11 64-bit (x64)
- **Phiên bản JDK:** Oracle JDK 24.0.2
- **Phiên bản Maven:** Apache Maven 3.9.11
- **Phiên bản Git:** Git 2.52.0
- **IDE:** IntelliJ IDEA Community Edition + PlantUML Integration

---

## 1. Mục tiêu bài thực hành
- Cài đặt và cấu hình thành công JDK, Maven, Git và IDE theo yêu cầu.
- Thiết lập biến môi trường `JAVA_HOME`, `MAVEN_HOME`, `PATH`.
- Mở, biên dịch và chạy starter project của môn học.
- Đóng gói ứng dụng thành file `.jar` và kiểm thử với JUnit.
- Thiết lập Git repository và thực hiện commit khởi tạo.

---

## 2. Các lệnh đã thực hiện và kết quả
1. Kiểm tra môi trường:
   - `java -version` -> Oracle JDK 24.0.2
   - `javac -version` -> javac 24.0.2
   - `mvn -version` -> Apache Maven 3.9.11 (Java home đồng bộ)
   - `git --version` -> Git 2.52.0.windows.1
2. Cấu hình Git:
   - `git config --global user.name "Mai Phước Sang"`
   - `git config --global user.email "1250080159@sv.hcmunre.edu.vn"`
3. Kiểm thử và đóng gói Starter Project:
   - `mvn clean test` -> BUILD SUCCESS (JUnit 5 pass)
   - `mvn package` -> Tạo file JAR `target/library-ooad-labs-1.0.0.jar`
   - `java -jar target/library-ooad-labs-1.0.0.jar` -> In thông báo "Library OOAD starter project is ready."

---

## 3. Cấu trúc thư mục nộp bài
```text
Lab00_1250080159_MAIPHUOCSANG/
├── README.md
├── environment.txt
├── submission_checklist.md
├── pom.xml
├── src/
│   ├── main/java/vn/edu/hcmunre/library/app/Main.java
│   └── test/java/vn/edu/hcmunre/library/app/MainTest.java
├── evidence/
│   ├── screenshots/
│   └── logs/
├── docs/
└── uml/
```

---

## 4. Nhật ký xử lý sự cố (Troubleshooting Log)
Trong quá trình thiết lập và chạy thử nghiệm môi trường, sinh viên ghi nhận và xử lý các sự cố kỹ thuật sau:

1. **Sự cố đường dẫn chứa ký tự tiếng Việt có dấu (`InvalidPathException`):**
   - *Hiện tượng:* Khi mở project từ thư mục học kỳ trên Desktop (`.../NĂM 4 HK1/phương pháp phát triển phần mềm hướng đối tượng`), trình biên dịch Java và IntelliJ báo lỗi `java.nio.file.InvalidPathException: Illegal char <?> at index 49`.
   - *Nguyên nhân gốc:* JVM và một số plugin build tool trên Windows xử lý encoding đường dẫn có dấu tiếng Việt/khoảng trắng chưa tương thích hoàn toàn.
   - *Cách khắc phục triệt để:* Đặt workspace chuẩn tại `D:\OOAD-Labs\Lab00_1250080159_MAIPHUOCSANG` (đường dẫn thuần ASCII ngắn gọn theo khuyến nghị tại Mục 3 và Trang 4 của Lab guide). Đồng thời tạo Windows Directory Junction (`mklink /J`) trỏ từ thư mục học kỳ ở ổ C sang ổ D để vừa biên dịch trơn tru 100%, vừa đồng bộ lưu trữ học kỳ.

2. **Sự cố bộ đệm biến môi trường trên Terminal:**
   - *Hiện tượng:* Sau khi bổ sung `JAVA_HOME` và `MAVEN_HOME` vào Environment Variables, lệnh `mvn -version` trong cửa sổ console cũ vẫn báo không tìm thấy lệnh hoặc nhận phiên bản Java cũ.
   - *Nguyên nhân gốc:* Phiên console/terminal hiện tại đã cache biến `PATH` tại thời điểm khởi chạy.
   - *Cách khắc phục:* Đóng toàn bộ cửa sổ terminal và IntelliJ IDEA, mở lại phiên mới để nạp lại đầy đủ các biến môi trường hệ thống.

3. **Đồng bộ Java Home giữa Maven và hệ thống:**
   - *Hiện tượng:* Cần đảm bảo Maven chạy đúng bản JDK đã cài đặt, tránh tình trạng Maven dùng một JDK và IDE dùng một JDK khác gây sai lệch kết quả kiểm thử.
   - *Cách khắc phục:* Đặt chính xác biến `JAVA_HOME=C:\Program Files\Java\jdk-24` và kiểm tra lệnh `mvn -version` để thấy trường `Java version` khớp 100% với `java -version`.

---

## 5. Tự đánh giá hoàn thành (Checklist)
- [x] Đầy đủ cấu hình JDK, Maven, Git, IntelliJ và PlantUML.
- [x] Dự án biên dịch và chạy thành công qua cả IntelliJ IDEA Run button và Maven CLI (`mvn clean test package`).
- [x] Đã lưu trữ toàn bộ ảnh chụp màn hình minh chứng tại `evidence/screenshots/` và log lệnh tại `evidence/logs/`.
- [x] Đã khởi tạo Git repository cục bộ và commit dự án đúng quy ước.
- [x] Tuân thủ quy định dọn dẹp thư mục tạm (`target/`) trước khi đóng gói nộp bài.
