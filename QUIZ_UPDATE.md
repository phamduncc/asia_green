# 🎯 Cập nhật hệ thống Quiz

## ✨ Thay đổi chính

### Trước đây:
- ❌ Quiz theo **từng bài học**
- ❌ Mỗi bài học có 3 câu hỏi cố định
- ❌ Tổng 15 quiz nhỏ lẻ

### Bây giờ:
- ✅ Quiz theo **CHỦ ĐỀ** (5 chủ đề)
- ✅ Mỗi quiz có **10 câu random**
- ✅ Câu hỏi luôn thay đổi mỗi lần làm
- ✅ Nút "Làm lại" với câu hỏi mới

---

## 📋 Danh sách Quiz mới

### 1. 💧 Nước & Môi trường
- **3 bài học**: Ô nhiễm nước, Tiết kiệm nước, Nước ngầm
- **9 câu hỏi** → Random 10 câu/quiz
- Kiểm tra kiến thức về nguồn nước, ô nhiễm, tiết kiệm

### 2. ♻️ Rác thải & Tái chế
- **3 bài học**: Nhựa, Phân loại rác, Zero Waste
- **9 câu hỏi** → Random 10 câu/quiz
- Kiểm tra về rác thải, tái chế, 5R

### 3. ⚡ Năng lượng
- **3 bài học**: Tiết kiệm năng lượng, Năng lượng tái tạo, Tòa nhà xanh
- **9 câu hỏi** → Random 10 câu/quiz
- Kiểm tra về tiết kiệm điện, năng lượng sạch

### 4. 🌍 Biến đổi khí hậu
- **3 bài học**: Biến đổi khí hậu, Khí nhà kính, Thích ứng
- **9 câu hỏi** → Random 10 câu/quiz
- Kiểm tra về BĐKH, khí nhà kính, thích ứng

### 5. 🌳 Thiên nhiên & Sinh thái
- **3 bài học**: Cây xanh, Đa dạng sinh học, Rừng
- **9 câu hỏi** → Random 10 câu/quiz
- Kiểm tra về hệ sinh thái, đa dạng sinh học

---

## 🎮 Tính năng mới

### ✨ Random thông minh
```dart
// Mỗi lần làm quiz, hệ thống sẽ:
1. Lấy TẤT CẢ câu hỏi của chủ đề
2. Random 10 câu từ pool câu hỏi
3. Hiển thị quiz

// Khi bấm "Làm lại":
1. Shuffle lại thứ tự câu hỏi
2. Có thể có câu hỏi khác
3. Trải nghiệm mới mẻ
```

### 🔄 Nút "Làm lại"
- Sau khi xem kết quả, có thể làm lại ngay
- Câu hỏi được shuffle → Trải nghiệm khác
- Không cần quay lại màn hình danh sách

### 📊 Màn hình danh sách
- Hiển thị **5 chủ đề** (thay vì 15 bài học)
- Thông tin: Số bài học + Số câu hỏi
- Badge "10 câu" rõ ràng

---

## 🔧 Thay đổi kỹ thuật

### Database Helper
```dart
// Method mới
Future<List<Question>> getQuestionsByCategory(
  String category, 
  {int limit = 10}
)

Future<List<Map<String, dynamic>>> getCategories()
```

### Quiz List Screen
- Lấy danh sách categories thay vì lessons
- Hiển thị thông tin tổng hợp
- Gọi quiz với category

### Quiz Screen
- Nhận `categoryName` và `categoryIcon` thay vì `lesson`
- Hỗ trợ shuffle câu hỏi
- Nút "Làm lại" tích hợp

---

## 🎯 Lợi ích

### Cho người học:
- ✅ Tổng hợp kiến thức theo chủ đề
- ✅ Không lặp lại câu hỏi nhàm chán
- ✅ Luyện tập nhiều lần với câu hỏi khác nhau
- ✅ Đánh giá toàn diện kiến thức chủ đề

### Cho hệ thống:
- ✅ Tận dụng tốt 45 câu hỏi
- ✅ UX tốt hơn (5 quiz thay vì 15)
- ✅ Dễ mở rộng thêm câu hỏi
- ✅ Random tránh gian lận

---

## 📱 Cách sử dụng

1. **Vào màn Quiz:**
   - Dashboard → Trắc nghiệm Xanh
   - Hoặc menu → Quiz

2. **Chọn chủ đề:**
   - 5 chủ đề với icon rõ ràng
   - Xem số bài học + số câu hỏi
   - Badge "10 câu" bên phải

3. **Làm quiz:**
   - 10 câu random từ chủ đề
   - Chọn đáp án → Xem giải thích ngay
   - Câu tiếp → Xem kết quả

4. **Kết quả:**
   - Xem điểm + phần trăm
   - Icon chủ đề
   - "Quay lại" hoặc "Làm lại"

---

## 🔄 Migration

### Không cần xóa database!
- ✅ Tất cả 45 câu hỏi vẫn giữ nguyên
- ✅ Chỉ thay đổi cách hiển thị
- ✅ Chạy app → Tự động cập nhật

### Nếu muốn reset:
```bash
# Uninstall app
adb uninstall com.appdu.asiagreen

# Run lại
flutter run
```

---

## 📊 So sánh

| Tiêu chí | Trước | Sau |
|----------|-------|-----|
| Số quiz | 15 quiz | 5 quiz |
| Câu/quiz | 3 câu | 10 câu |
| Random | ❌ Không | ✅ Có |
| Làm lại | ❌ Không | ✅ Có |
| Tổng quan | ❌ Rời rạc | ✅ Theo chủ đề |

---

## 🎉 Kết luận

Hệ thống quiz mới:
- ✅ **Tổng hợp** kiến thức tốt hơn
- ✅ **Random** tránh nhàm chán
- ✅ **Linh hoạt** hơn cho người học
- ✅ **Dễ mở rộng** khi thêm câu hỏi

**🚀 Chạy app và trải nghiệm quiz mới ngay!**
