# 🧪 Test Language Switch - Hướng dẫn

## ✅ Đã sửa lỗi!

Dashboard screen đã được cập nhật để sử dụng AppLocalizations thay vì hardcoded strings.

---

## 🚀 Chạy test

### Bước 1: Run app
```bash
flutter pub get
flutter run
```

### Bước 2: Test chuyển ngôn ngữ

**Tiếng Việt (Default):**
```
🌱 Asia Green    🇻🇳  🌙  ℹ️

Xin chào! 🌱
Mỗi hành động nhỏ, thay đổi lớn!

Cấp độ của bạn: Người mới
⭐ 0 Điểm xanh

Cấp độ của bạn
📚 Bài học hoàn thành: 0
🏆 Thử thách hoàn thành: 0
🌿 Điểm xanh: 0

Truy cập nhanh
[Học] [Kiểm tra]
[Trò chơi] [Thử thách]

💪 Mỗi hành động nhỏ đều tạo nên sự thay đổi lớn!
```

**Nhấn flag 🇻🇳 → Chuyển sang 🇺🇸:**
```
🌱 Asia Green    🇺🇸  🌙  ℹ️

Welcome! 🌱
Small actions, big changes!

Your Level: Beginner
⭐ 0 Green Points

Your Level
📚 Completed Lessons: 0
🏆 Completed Challenges: 0
🌿 Green Points: 0

Quick Actions
[Learn] [Quiz]
[Games] [Challenges]

🌱 You're doing great!
```

---

## 📋 Checklist Test

### Dashboard:
- [ ] Welcome message thay đổi (Xin chào! → Welcome!)
- [ ] Slogan thay đổi
- [ ] "Cấp độ của bạn" → "Your Level"
- [ ] "Điểm xanh" → "Green Points"
- [ ] "Bài học hoàn thành" → "Completed Lessons"
- [ ] "Thử thách hoàn thành" → "Completed Challenges"
- [ ] "Truy cập nhanh" → "Quick Actions"
- [ ] Buttons: Học→Learn, Kiểm tra→Quiz, Trò chơi→Games, Thử thách→Challenges
- [ ] Motivational message thay đổi
- [ ] About dialog thay đổi

### Persistence:
- [ ] Chuyển sang English
- [ ] Close app (không force stop)
- [ ] Mở lại → Vẫn là English ✅

### Theme + Language:
- [ ] Chuyển Dark mode + English → Both work
- [ ] Restart app → Both settings preserved ✅

---

## 🔍 Debug nếu vẫn lỗi

### Nếu text không thay đổi:

**1. Check console:**
```bash
flutter run --verbose
# Xem có error không
```

**2. Hot reload:**
```bash
# Trong terminal Flutter:
r   # Hot reload
R   # Hot restart
```

**3. Clear cache:**
```bash
flutter clean
flutter pub get
flutter run
```

**4. Uninstall & reinstall:**
```bash
# Trên điện thoại: Giữ icon → Gỡ cài đặt
# Hoặc:
adb uninstall com.appdu.asiagreen
flutter run
```

---

## 📊 What Changed

### Files updated:
1. `lib/screens/dashboard_screen.dart` ✅
   - _buildWelcomeCard() → Uses l10n
   - _buildStatsCard() → Uses l10n
   - _buildQuickActions() → Uses l10n  
   - _buildMotivationalCard() → Uses l10n
   - _showAboutDialog() → Uses l10n

2. `lib/l10n/app_localizations.dart` ✅ (Already had translations)

3. `lib/providers/language_provider.dart` ✅ (Already working)

4. `lib/main.dart` ✅ (Already configured)

---

## ✨ Expected Behavior

### When you tap 🇻🇳:
1. Flag changes to 🇺🇸
2. All text changes to English instantly
3. SnackBar: "Switched to English"
4. Preference saved

### When you tap 🇺🇸:
1. Flag changes to 🇻🇳
2. All text changes to Vietnamese instantly  
3. SnackBar: "Chuyển sang Tiếng Việt"
4. Preference saved

### On app restart:
- Language setting is preserved ✅
- Theme setting is preserved ✅

---

## 🎯 Success Criteria

✅ Language toggle works instantly
✅ All dashboard text changes
✅ No hardcoded Vietnamese strings
✅ Persistence works
✅ No crashes
✅ SnackBar feedback shows

---

## 💡 Tips

### For Vietnamese:
- All text should be in Vietnamese
- Numbers stay the same (0, 5, 10)
- Icons stay the same (🌱, ⭐, 📚)

### For English:
- All text should be in English
- Numbers stay the same
- Icons stay the same

### Mixed content is OK:
- "5 Green Points" (English)
- "5 Điểm xanh" (Vietnamese)
- Both are correct!

---

## 🚀 Ready to Test!

```bash
flutter run

# Then:
# 1. Tap 🇻🇳 → Should switch to 🇺🇸
# 2. All text changes to English
# 3. Tap 🇺🇸 → Should switch to 🇻🇳
# 4. All text changes to Vietnamese
# 5. Close & reopen → Settings preserved ✅
```

**🌍 Language switching should work perfectly now!**
