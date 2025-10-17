# 🌱 Asia Green - Ứng dụng Giáo dục Môi trường

Ứng dụng giáo dục và nâng cao nhận thức về bảo vệ môi trường, hoạt động hoàn toàn **offline** cho cộng đồng và doanh nghiệp.

## 🎯 Mục tiêu

- Giáo dục và nâng cao nhận thức về bảo vệ môi trường
- Cung cấp kiến thức, hướng dẫn, bài học tương tác
- Trò chơi giáo dục và thử thách xanh
- Hoạt động **100% offline** - không cần Internet

## ✨ Tính năng chính

### 📘 Học - Kiến thức Môi trường
- 5 chủ đề chính: Nước, Rác thải, Năng lượng, Khí hậu, Thiên nhiên
- Nội dung chi tiết với hình ảnh minh họa
- **Text-to-Speech**: Đọc nội dung bài học
- Tóm tắt nhanh cho mỗi bài học

### 🧠 Kiểm tra - Trắc nghiệm Xanh
- Câu hỏi trắc nghiệm cho từng bài học
- Chấm điểm tự động với giải thích chi tiết
- Hệ thống xếp hạng theo cấp độ
- Lưu lịch sử và tiến độ học tập

### 🎮 Trò chơi Giáo dục
- **Phân loại rác**: Kéo thả rác vào đúng thùng
- **Làm sạch dòng sông**: Chạm để loại bỏ rác trôi nổi
- **Trồng cây ảo**: Chăm sóc và trồng cây xanh
- **Tiết kiệm năng lượng**: Tắt thiết bị điện không sử dụng

### 🏆 Thử thách Xanh
- 10+ thử thách thực tế hàng ngày
- Tích điểm xanh khi hoàn thành
- Hệ thống huy hiệu và chứng nhận
- Theo dõi tiến độ cá nhân

## 🛠️ Công nghệ

- **Flutter**: Framework đa nền tảng (Android, iOS, Windows)
- **SQLite**: Lưu trữ dữ liệu offline
- **Flutter TTS**: Text-to-Speech
- **Google Fonts**: Font chữ đẹp
- **Shared Preferences**: Lưu cài đặt người dùng

## 📦 Cài đặt

### Yêu cầu
- Flutter SDK 3.6.0 trở lên
- Dart 3.6.0 trở lên

### Các bước cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd asia_green
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
# Android
flutter run

# iOS
flutter run -d ios

# Windows
flutter run -d windows
```

## 📁 Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── models/                   # Data models
│   ├── lesson.dart
│   ├── question.dart
│   ├── challenge.dart
│   ├── progress.dart
│   └── game_score.dart
├── screens/                  # UI screens
│   ├── dashboard_screen.dart
│   ├── lessons_screen.dart
│   ├── lesson_detail_screen.dart
│   ├── quiz_list_screen.dart
│   ├── quiz_screen.dart
│   ├── games_screen.dart
│   ├── challenges_screen.dart
│   └── games/
│       ├── trash_sort_game.dart
│       ├── river_clean_game.dart
│       └── tree_plant_game.dart
├── services/                 # Business logic
│   └── database_helper.dart
├── theme/                    # App theme
│   └── app_theme.dart
└── utils/                    # Utilities
    └── constants.dart

assets/
├── images/                   # Hình ảnh
├── videos/                   # Video hướng dẫn
├── audio/                    # Âm thanh
└── data/                     # Dữ liệu tĩnh
```

## 🎨 Giao diện

- **Màu chủ đạo**: Xanh lá, xanh dương, trắng
- **Font**: Noto Sans (hỗ trợ tiếng Việt tốt)
- **Design**: Material Design 3
- **UX**: Thân thiện, dễ sử dụng, trực quan

## 📊 Database Schema

### Lessons (Bài học)
- id, title, content, category, imagePath, audioPath, videoPath, orderIndex

### Questions (Câu hỏi)
- id, lessonId, question, options, correctAnswer, explanation

### Challenges (Thử thách)
- id, title, description, points, icon, isCompleted

### Progress (Tiến độ)
- id, lessonId, score, completedAt

### Game Scores (Điểm game)
- id, gameName, score, playedAt

## 🌟 Hệ thống điểm

- **Hoàn thành bài học**: Điểm từ quiz
- **Thử thách xanh**: 5-30 điểm/thử thách
- **Mini game**: Điểm theo thành tích

### Cấp độ
- 0-99 điểm: **Người mới**
- 100-499 điểm: **Nhà Xanh**
- 500+ điểm: **Đại sứ Môi trường**

## 🚀 Tính năng sắp tới

- [ ] Thêm video hướng dẫn offline
- [ ] Hệ thống badge và achievement
- [ ] Xuất báo cáo tiến độ
- [ ] Chế độ tối (Dark mode)
- [ ] Đồng bộ dữ liệu với cloud (tùy chọn)
- [ ] Module dành cho doanh nghiệp

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Hãy tạo Pull Request hoặc Issue.

## 📄 License

MIT License - Xem file LICENSE để biết thêm chi tiết

## 📞 Liên hệ

- **Project**: Asia Green
- **Version**: 1.0.0
- **Author**: Your Team Name

---

**🌍 Cùng nhau bảo vệ Trái Đất! 🌱**
