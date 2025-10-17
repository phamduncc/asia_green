# ⚡ Quick Start Guide - Asia Green

## 🚀 Chạy ứng dụng trong 3 bước

### Bước 1: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 2: Chạy app
```bash
# Android/iOS
flutter run

# Windows
flutter run -d windows

# Chọn device cụ thể
flutter devices        # Xem danh sách
flutter run -d <device-id>
```

### Bước 3: Khám phá! 🎉
App sẽ tự động tạo database và seed data khi chạy lần đầu.

---

## 📱 Nhanh chóng test các tính năng

### 1. Dashboard
- Xem tổng quan điểm xanh, cấp độ
- 4 nút: Học, Kiểm tra, Chơi, Thử thách

### 2. Test Học
- Nhấn "Học" → Chọn bài học
- Nhấn icon 🔊 để nghe TTS
- Nhấn "Tóm tắt" để xem summary

### 3. Test Quiz
- Nhấn "Kiểm tra" → Chọn bài
- Làm quiz → Xem kết quả
- Điểm tự động cộng vào tổng

### 4. Test Games
- Nhấn "Chơi" → Chọn game
- **Trash Sort**: Phân loại rác vào đúng thùng
- **River Clean**: Chạm rác để dọn sạch
- **Tree Plant**: Trồng và chăm cây

### 5. Test Challenges
- Nhấn "Thử thách" → Chọn challenge
- Đánh dấu hoàn thành
- Nhận điểm xanh!

---

## 🐛 Gặp lỗi?

### Lỗi dependencies
```bash
flutter clean
flutter pub get
```

### Lỗi build
```bash
flutter clean
flutter pub get
flutter run
```

### Không có dữ liệu
- Xóa app và cài lại
- Database sẽ tự động tạo lại với seed data

---

## 📦 Build Release

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (Google Play)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

---

## 💡 Tips

### Reload nhanh (Hot Reload)
- Nhấn `r` trong terminal
- Hoặc save file trong IDE

### Restart (Hot Restart)
- Nhấn `R` trong terminal  
- Hoặc restart debug trong IDE

### Debug
```bash
flutter run -v      # Verbose mode
flutter logs        # Xem logs
```

### Format code
```bash
dart format lib/
```

### Analyze code
```bash
flutter analyze
```

---

## 🎯 Mục tiêu học nhanh

**5 phút**: Chạy app, xem Dashboard  
**10 phút**: Test Học + TTS  
**15 phút**: Làm Quiz, xem kết quả  
**20 phút**: Chơi 1 game  
**30 phút**: Hoàn thành 1 thử thách, đạt cấp "Nhà Xanh"  

---

## 📚 Tài liệu chi tiết

- **README.md** - Tổng quan dự án
- **GUIDE.md** - Hướng dẫn chi tiết
- **PROJECT_STRUCTURE.md** - Cấu trúc code
- **SUMMARY.md** - Tổng kết dự án

---

**🌱 Chúc bạn có trải nghiệm tuyệt vời với Asia Green!**

**💚 Mỗi hành động nhỏ đều tạo nên sự thay đổi lớn!**
