# 📖 Hướng dẫn Sử dụng Asia Green

## 🚀 Chạy ứng dụng

### Trên Android/iOS
```bash
flutter run
```

### Trên Windows
```bash
flutter run -d windows
```

### Build APK cho Android
```bash
flutter build apk --release
```

## 📱 Hướng dẫn sử dụng tính năng

### 1. Màn hình Dashboard (Trang chủ)

Dashboard hiển thị:
- **Lời chào**: Slogan "Hôm nay bạn đã làm gì cho Trái Đất chưa?"
- **Cấp độ người dùng**: Dựa trên tổng điểm xanh
  - 0-99 điểm: Người mới
  - 100-499 điểm: Nhà Xanh
  - 500+ điểm: Đại sứ Môi trường
- **Thống kê**: Số bài học, thử thách hoàn thành, tổng điểm
- **Nút truy cập nhanh**: Học, Kiểm tra, Chơi, Thử thách

### 2. Phần Học - Kiến thức Môi trường

**Cách sử dụng:**
1. Chọn **"Học"** từ Dashboard
2. Lọc bài học theo danh mục (Nước, Rác thải, Năng lượng, Khí hậu, Thiên nhiên)
3. Chọn bài học muốn đọc
4. Nhấn icon **🔊** để nghe nội dung (Text-to-Speech)
5. Nhấn **"Tóm tắt"** để xem tóm tắt nhanh

**Nội dung bài học:**
- ✅ 5 bài học về các chủ đề môi trường
- ✅ Nội dung chi tiết, dễ hiểu
- ✅ Đọc nội dung bằng giọng nói (TTS)

### 3. Phần Kiểm tra - Trắc nghiệm Xanh

**Cách chơi:**
1. Chọn **"Kiểm tra"** từ Dashboard
2. Chọn bài học muốn kiểm tra
3. Trả lời các câu hỏi trắc nghiệm
4. Xem giải thích sau mỗi câu hỏi
5. Nhận điểm khi hoàn thành

**Tính điểm:**
- Mỗi câu đúng = 1 điểm
- Tổng điểm được cộng vào điểm xanh
- Lưu lịch sử làm bài

### 4. Phần Trò chơi - Mini Games

#### 🎮 Game 1: Phân loại rác (Trash Sort)
**Mục tiêu:** Kéo thả rác vào đúng thùng

**Cách chơi:**
- Nhìn vào loại rác xuất hiện
- Chọn thùng phù hợp:
  - ♻️ **Tái chế**: Chai nhựa, lon, hộp giấy
  - 🍃 **Hữu cơ**: Thức ăn, lá cây
  - ⚠️ **Độc hại**: Pin, bóng đèn
  - 🗑️ **Thường**: Rác khác
- Có 60 giây và 3 mạng
- Mỗi câu đúng +10 điểm

#### 💧 Game 2: Làm sạch dòng sông (River Clean)
**Mục tiêu:** Chạm để loại bỏ rác trôi nổi

**Cách chơi:**
- Rác sẽ trôi từ trên xuống
- Chạm vào rác để dọn sạch
- Thời gian: 45 giây
- Mỗi rác +5 điểm

#### 🌳 Game 3: Trồng cây ảo (Tree Plant)
**Mục tiêu:** Trồng và chăm sóc cây

**Cách chơi:**
- Nhấn dấu "+" để trồng cây (tốn nước)
- Cây sẽ tự động lớn lên nếu đủ nước
- Nhấn "Tưới nước" để bổ sung (tốn 5 điểm)
- Cây trưởng thành +20 điểm

### 5. Phần Thử thách Xanh

**Cách thực hiện:**
1. Chọn **"Thử thách"** từ Dashboard
2. Xem danh sách thử thách
3. Chọn thử thách muốn làm
4. Khi hoàn thành trong thực tế, đánh dấu "Hoàn thành"
5. Nhận điểm xanh tương ứng

**Ví dụ thử thách:**
- Không dùng ống hút nhựa (10 điểm)
- Tắt điện khi ra khỏi phòng (5 điểm)
- Mang chai nước cá nhân (10 điểm)
- Đi xe đạp thay vì xe máy (15 điểm)
- Phân loại rác tại nhà (20 điểm)
- Trồng một cây xanh (25 điểm)

## 💡 Tips & Tricks

### Cách tích điểm nhanh:
1. ✅ Hoàn thành tất cả bài học → Làm quiz
2. ✅ Chơi mini games thường xuyên
3. ✅ Hoàn thành thử thách hàng ngày

### Đạt cấp Đại sứ Môi trường:
- Cần tối thiểu **500 điểm xanh**
- Hoàn thành tất cả bài học: ~50 điểm
- Làm hết challenges: ~180 điểm
- Chơi games giỏi: Còn lại ~270 điểm

## 🔧 Tính năng nâng cao

### Text-to-Speech (Đọc nội dung)
- Hỗ trợ tiếng Việt
- Tự động dừng khi thoát màn hình
- Điều chỉnh tốc độ đọc trong code (mặc định: 0.5)

### Lưu trữ Offline
- Tất cả dữ liệu lưu trong SQLite
- Không cần kết nối Internet
- Dữ liệu không bị mất khi tắt app

### Hệ thống điểm
- Điểm từ quiz được lưu tự động
- Điểm từ games được lưu lịch sử
- Thử thách chỉ được đánh dấu hoàn thành 1 lần

## 🐛 Xử lý sự cố

### Ứng dụng không chạy?
```bash
flutter clean
flutter pub get
flutter run
```

### Không có dữ liệu?
- Database sẽ tự động tạo khi chạy lần đầu
- Dữ liệu mẫu (5 bài học, 10 thử thách) được seed tự động

### Text-to-Speech không hoạt động?
- Kiểm tra quyền truy cập
- Android: Cần cài đặt ngôn ngữ tiếng Việt trong hệ thống
- iOS: TTS tích hợp sẵn

## 📊 Thống kê & Dữ liệu

### Xem thống kê cá nhân:
- Dashboard hiển thị tổng quan
- Số bài học đã hoàn thành
- Số thử thách đã làm
- Tổng điểm xanh tích lũy

### Reset dữ liệu:
```dart
// Trong trường hợp cần reset, xóa database:
// Android: /data/data/com.example.asia_green/databases/
// iOS: Library/Application Support/
```

## 🎨 Tùy chỉnh

### Thay đổi màu sắc:
Chỉnh sửa trong `lib/utils/constants.dart`:
```dart
static const Color primaryGreen = Color(0xFF2E7D32);
static const Color lightGreen = Color(0xFF66BB6A);
```

### Thêm bài học mới:
Chỉnh sửa `_seedData()` trong `lib/services/database_helper.dart`

### Thêm câu hỏi:
Thêm vào phương thức `_seedData()` với `lessonId` tương ứng

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra README.md
2. Xem log: `flutter run -v`
3. Tạo Issue trên GitHub

---

**🌍 Cảm ơn bạn đã sử dụng Asia Green!**

**💚 Mỗi hành động nhỏ đều tạo nên sự thay đổi lớn!**
