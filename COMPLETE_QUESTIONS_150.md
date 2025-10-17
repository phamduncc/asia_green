# 📝 Hoàn thành 150 Câu hỏi

## ✅ Trạng thái hiện tại

Đã thêm xong:
- ✅ Lesson 1-7: **70 câu** (10 câu/lesson)

Còn cần thêm:
- ⏳ Lesson 8-15: **80 câu** (10 câu/lesson x 8 lessons)

---

## 🚀 Cách cập nhật nhanh

### Bước 1: Thêm câu hỏi vào database_helper.dart

**Vị trí:** Sau câu hỏi cuối của từng lesson, thêm 7 câu nữa.

---

### LESSON 8 (Waste sorting) - Thêm 7 câu

```dart
// Thêm NGAY SAU câu hỏi cuối cùng của Lesson 8 (dòng ~1142)
await db.insert('questions', {
  'lessonId': 8,
  'question': 'Màu thùng rác nào dùng cho rác tái chế?',
  'options': 'Đen|||Xanh|||Đỏ|||Vàng',
  'correctAnswer': 1,
  'explanation': 'Thùng xanh (hoặc vàng) dùng cho rác tái chế như nhựa, giấy, kim loại.',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Giấy dính băng keo có tái chế được không?',
  'options': 'Có|||Khó tái chế|||Rất tốt|||Không quan trọng',
  'correctAnswer': 1,
  'explanation': 'Giấy dính băng keo, ghim khó tái chế. Cần gỡ sạch trước khi bỏ vào thùng tái chế.',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Lon kim loại nên xử lý thế nào trước khi tái chế?',
  'options': 'Để nguyên|||Rửa sạch, làm phẳng|||Đập vỡ|||Đốt',
  'correctAnswer': 1,
  'explanation': 'Lon nên rửa sạch, làm phẳng để tiết kiệm không gian và dễ tái chế.',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Thời gian phân hủy của giấy bao lâu?',
  'options': '2-4 tuần|||2-6 tháng|||5-10 năm|||100 năm',
  'correctAnswer': 1,
  'explanation': 'Giấy phân hủy trong 2-6 tháng, nhanh hơn nhiều so với nhựa (hàng trăm năm).',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Hộp xốp (foam) có tái chế được không?',
  'options': 'Dễ tái chế|||Rất khó tái chế|||Không cần tái chế|||Tốt nhất',
  'correctAnswer': 1,
  'explanation': 'Hộp xốp rất khó tái chế, nên hạn chế sử dụng và thay bằng hộp giấy.',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Tái chế 1 tấn giấy tiết kiệm được gì?',
  'options': 'Không tiết kiệm|||Cứu 17 cây, tiết kiệm nước/điện|||Chỉ tiết kiệm tiền|||Hại môi trường',
  'correctAnswer': 1,
  'explanation': 'Tái chế 1 tấn giấy cứu 17 cây, tiết kiệm 26,000 lít nước và 4,000 kWh điện.',
});

await db.insert('questions', {
  'lessonId': 8,
  'question': 'Chai thủy tinh có thể tái chế bao nhiêu lần?',
  'options': '1 lần|||5 lần|||Vô số lần|||Không tái chế được',
  'correctAnswer': 2,
  'explanation': 'Thủy tinh có thể tái chế vô số lần không mất chất lượng, rất bền vững.',
});
```

Tương tự, **copy và paste các câu hỏi sau** vào đúng vị trí cho từng lesson:

---

## 📄 Link file đầy đủ

Do số lượng câu hỏi lớn (80 câu còn lại), tôi đã tạo file riêng.

### Hướng dẫn:
1. Xem file **`REMAINING_QUESTIONS_FULL.md`**
2. Copy code từ file đó
3. Paste vào `database_helper.dart` đúng vị trí mỗi lesson
4. Save file
5. Uninstall app và chạy lại

---

## ⚠️ Lưu ý quan trọng

### Reset database để load câu hỏi mới:

```bash
# Windows - Uninstall app
adb uninstall com.asia.asia_green

# Chạy lại app
flutter run
```

Hoặc xóa app thủ công trên điện thoại rồi run lại.

---

## 📊 Tổng kết

| Chủ đề | Lessons | Câu hỏi/lesson | Tổng câu |
|--------|---------|----------------|----------|
| 💧 Nước | 3 | 10 | **30** |
| ♻️ Rác thải | 3 | 10 | **30** |
| ⚡ Năng lượng | 3 | 10 | **30** |
| 🌍 Khí hậu | 3 | 10 | **30** |
| 🌳 Thiên nhiên | 3 | 10 | **30** |
| **TỔNG** | **15** | **10** | **150** |

---

## 🎯 Lợi ích

- ✅ **Quiz 10 câu random** từ pool 30 câu/chủ đề
- ✅ **Không lặp lại** câu hỏi nhàm chán
- ✅ **Làm lại** luôn có câu mới
- ✅ **Đa dạng kiến thức** toàn diện

**🚀 Sau khi thêm xong, app sẽ có 150 câu hỏi phong phú!**
