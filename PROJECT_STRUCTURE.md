# 📁 Cấu trúc Dự án Asia Green

## 🗂️ Tổng quan cấu trúc

```
asia_green/
├── lib/                          # Mã nguồn chính
│   ├── main.dart                 # Entry point của ứng dụng
│   ├── models/                   # Data models
│   │   ├── lesson.dart           # Model bài học
│   │   ├── question.dart         # Model câu hỏi
│   │   ├── challenge.dart        # Model thử thách
│   │   ├── progress.dart         # Model tiến độ học tập
│   │   └── game_score.dart       # Model điểm game
│   ├── screens/                  # Các màn hình UI
│   │   ├── dashboard_screen.dart           # Màn hình Dashboard
│   │   ├── lessons_screen.dart             # Danh sách bài học
│   │   ├── lesson_detail_screen.dart       # Chi tiết bài học
│   │   ├── quiz_list_screen.dart           # Danh sách quiz
│   │   ├── quiz_screen.dart                # Màn hình làm quiz
│   │   ├── games_screen.dart               # Danh sách game
│   │   ├── challenges_screen.dart          # Màn hình thử thách
│   │   └── games/                          # Thư mục mini games
│   │       ├── trash_sort_game.dart        # Game phân loại rác
│   │       ├── river_clean_game.dart       # Game làm sạch sông
│   │       └── tree_plant_game.dart        # Game trồng cây
│   ├── services/                 # Business logic & services
│   │   └── database_helper.dart  # SQLite database helper
│   ├── theme/                    # Giao diện & theme
│   │   └── app_theme.dart        # Cấu hình theme của app
│   └── utils/                    # Utilities & constants
│       └── constants.dart        # Các hằng số của app
├── assets/                       # Tài nguyên tĩnh
│   ├── images/                   # Hình ảnh
│   ├── videos/                   # Video hướng dẫn
│   ├── audio/                    # File âm thanh
│   └── data/                     # Dữ liệu tĩnh
├── test/                         # Unit tests
│   └── widget_test.dart          # Widget tests
├── android/                      # Cấu hình Android
├── ios/                          # Cấu hình iOS
├── pubspec.yaml                  # Dependencies & cấu hình
├── README.md                     # Tài liệu dự án
├── GUIDE.md                      # Hướng dẫn sử dụng
└── PROJECT_STRUCTURE.md          # File này
```

## 📦 Chi tiết các Package

### Dependencies chính (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Database
  sqflite: ^2.3.0           # SQLite database
  path: ^1.8.3              # Path utilities
  
  # Text to Speech
  flutter_tts: ^4.0.2       # Text-to-Speech
  
  # Local Storage
  shared_preferences: ^2.2.2 # Lưu cài đặt
  
  # UI
  google_fonts: ^6.1.0      # Fonts đẹp
  
  # Utils
  intl: ^0.18.1             # Internationalization
```

## 🎯 Chi tiết từng Module

### 1. Models (lib/models/)

#### lesson.dart
- Quản lý dữ liệu bài học
- Fields: id, title, content, category, imagePath, audioPath, videoPath, orderIndex
- Methods: toMap(), fromMap()

#### question.dart
- Quản lý câu hỏi trắc nghiệm
- Fields: id, lessonId, question, options[], correctAnswer, explanation
- Lưu options dưới dạng string với delimiter '|||'

#### challenge.dart
- Quản lý thử thách xanh
- Fields: id, title, description, points, icon, isCompleted
- Có thể đánh dấu hoàn thành

#### progress.dart
- Lưu tiến độ học tập của user
- Fields: id, lessonId, score, completedAt
- Tự động lưu khi hoàn thành quiz

#### game_score.dart
- Lưu điểm số từ các mini game
- Fields: id, gameName, score, playedAt
- Hỗ trợ xem high score

### 2. Screens (lib/screens/)

#### dashboard_screen.dart (Màn hình chính)
**Chức năng:**
- Hiển thị welcome message
- Thống kê: điểm xanh, cấp độ, bài học & thử thách hoàn thành
- 4 nút truy cập nhanh: Học, Kiểm tra, Chơi, Thử thách
- Card động lực ngẫu nhiên

**State Management:**
- Sử dụng StatefulWidget
- RefreshIndicator để tải lại dữ liệu
- Tự động cập nhật sau khi quay về từ màn hình khác

#### lessons_screen.dart
**Chức năng:**
- Danh sách tất cả bài học
- Filter theo category (Nước, Rác thải, Năng lượng, Khí hậu, Thiên nhiên)
- Navigate đến lesson_detail

**UI Components:**
- FilterChip cho categories
- Card với icon và title
- Empty state khi không có bài học

#### lesson_detail_screen.dart
**Chức năng:**
- Hiển thị nội dung chi tiết bài học
- Text-to-Speech để đọc nội dung
- Format nội dung: bold headings, bullet points
- Nút "Tóm tắt" hiển thị dialog

**Features:**
- FlutterTTS integration (tiếng Việt)
- Markdown-style formatting
- Gradient header
- FloatingActionButton cho tóm tắt

#### quiz_list_screen.dart
**Chức năng:**
- Danh sách các bài học có quiz
- Navigate đến quiz_screen với questions

**Logic:**
- Load questions từ database
- Check nếu không có questions → show snackbar

#### quiz_screen.dart
**Chức năng:**
- Hiển thị từng câu hỏi
- Progress bar
- Chọn đáp án và xem giải thích
- Kết quả cuối cùng với % và feedback
- Lưu progress vào database

**UI Elements:**
- Option cards với màu động (correct/incorrect)
- Explanation card
- Result screen với emoji và message
- Bottom navigation button

#### games_screen.dart
**Chức năng:**
- Danh sách 4 mini games
- Hiển thị high score từ database
- Navigate đến game tương ứng

**Games:**
1. Trash Sort - Phân loại rác
2. River Clean - Làm sạch sông
3. Tree Plant - Trồng cây
4. Energy Save - Tiết kiệm điện (coming soon)

#### challenges_screen.dart
**Chức năng:**
- Danh sách thử thách xanh
- Stats card: số thử thách hoàn thành, điểm tích lũy
- Dialog xác nhận khi hoàn thành thử thách
- Cập nhật trạng thái vào database

**Features:**
- Opacity effect cho completed challenges
- Point reward system
- SnackBar notification khi hoàn thành

#### games/trash_sort_game.dart
**Game logic:**
- 4 loại rác: Tái chế, Hữu cơ, Độc hại, Thường
- 60 giây, 3 mạng
- Random trash items
- +10 điểm cho mỗi câu đúng
- Lưu score vào database

**UI:**
- Start screen với instructions
- Game screen với trash card
- 4 bin buttons (GridView)
- Timer & score header

#### games/river_clean_game.dart
**Game logic:**
- Rác trôi từ trên xuống
- Chạm để loại bỏ
- 45 giây
- +5 điểm mỗi rác
- Spawn rác mỗi 1.5 giây

**UI:**
- Blue gradient background (river effect)
- Floating trash với animation
- HUD hiển thị time & score

#### games/tree_plant_game.dart
**Game logic:**
- Trồng tối đa 9 cây
- Tưới nước để cây phát triển
- Nước giảm dần theo thời gian
- Cây trưởng thành +20 điểm

**UI:**
- 3x3 grid
- Tree growth stages: 🌱 → 🌿 → 🌳
- Water & point indicators
- Action buttons

### 3. Services (lib/services/)

#### database_helper.dart
**Singleton pattern** để quản lý SQLite database

**Chức năng chính:**
- Tạo & quản lý database
- Seed data mẫu (5 lessons, câu hỏi, 10 challenges)
- CRUD operations cho tất cả models
- Query methods:
  - getLessons(), getLessonsByCategory()
  - getQuestionsByLesson()
  - getChallenges(), updateChallenge()
  - getTotalPoints(), getCompletedLessonsCount()
  - insertGameScore(), getHighScore()

**Database Schema:**
```sql
lessons (id, title, content, category, imagePath, audioPath, videoPath, orderIndex)
questions (id, lessonId, question, options, correctAnswer, explanation)
challenges (id, title, description, points, icon, isCompleted)
progress (id, lessonId, score, completedAt)
game_scores (id, gameName, score, playedAt)
```

**Seed Data:**
- 5 bài học về môi trường (đầy đủ nội dung tiếng Việt)
- 7 câu hỏi trắc nghiệm
- 10 thử thách xanh thực tế

### 4. Theme (lib/theme/)

#### app_theme.dart
**Material Design 3 Theme**

**Colors:**
- Primary: #2E7D32 (Green)
- Light: #66BB6A
- Accent: #0288D1 (Blue)
- Background: #F1F8E9

**Components:**
- Google Fonts (Noto Sans - hỗ trợ tiếng Việt)
- Card với border radius 16
- ElevatedButton style thống nhất
- AppBar với gradient

### 5. Utils (lib/utils/)

#### constants.dart
**App-wide constants:**
- App info: name, slogan
- Color palette
- Category constants
- User level thresholds
- Game names
- getUserLevel() helper method

## 🎨 Design System

### Color Palette
```dart
Primary Green:    #2E7D32
Light Green:      #66BB6A
Dark Green:       #1B5E20
Accent Blue:      #0288D1
Background:       #F1F8E9
Card:             #FFFFFF
```

### Typography
- Font Family: Noto Sans (Google Fonts)
- Headings: Bold, 18-28px
- Body: Regular, 14-16px
- Small: 12px

### Spacing
- Card padding: 16-20px
- Screen padding: 16-24px
- Item spacing: 8-16px

### Border Radius
- Cards: 16px
- Buttons: 12px
- Chips: 8px

## 🔄 Data Flow

### 1. App Start
```
main.dart 
  → AsiaGreenApp (MaterialApp)
    → DashboardScreen
      → DatabaseHelper.instance
        → Create/Open SQLite DB
        → Seed data if first run
```

### 2. Lessons Flow
```
DashboardScreen 
  → LessonsScreen
    → Load lessons from DB
    → Filter by category
  → LessonDetailScreen
    → Display content
    → Text-to-Speech
```

### 3. Quiz Flow
```
DashboardScreen 
  → QuizListScreen
    → Load lessons
  → QuizScreen
    → Load questions
    → User answers
    → Calculate score
    → Save to Progress table
```

### 4. Games Flow
```
DashboardScreen 
  → GamesScreen
    → Load high scores
  → Specific Game (e.g., TrashSortGame)
    → Play game
    → Calculate score
    → Save to GameScores table
```

### 5. Challenges Flow
```
DashboardScreen 
  → ChallengesScreen
    → Load challenges
    → User marks complete
    → Update isCompleted in DB
    → Notify user (+points)
```

## 📊 Database Relationships

```
lessons (1) ----< (N) questions
           ----< (N) progress

challenges (independent)

game_scores (grouped by gameName)
```

## 🎯 Key Features Implementation

### Offline-First
- Tất cả dữ liệu trong SQLite
- No network calls
- Assets bundled trong app

### Text-to-Speech
- FlutterTTS package
- Vietnamese language support
- Speed: 0.5, Volume: 1.0, Pitch: 1.0

### Gamification
- Point system từ nhiều nguồn
- User levels: Beginner → Green → Ambassador
- Achievements tracking

### User Experience
- Pull-to-refresh
- Loading states
- Empty states
- Success/Error feedback (SnackBar)
- Navigation flow mượt mà

## 🚀 Performance Considerations

### Database
- Singleton pattern cho DatabaseHelper
- Batch inserts cho seed data
- Indexed queries

### UI
- StatefulWidget cho reactive UI
- ListView.builder cho danh sách dài
- Cached fonts (Google Fonts)

### Memory
- Timer cleanup trong dispose()
- Giới hạn số items trong games
- Asset optimization

## 📱 Platform Support

### Android
- Min SDK: 21 (Android 5.0)
- Target SDK: Latest
- Permissions: None required

### iOS
- Min: iOS 11.0
- Text-to-Speech built-in

### Windows
- Flutter Desktop support
- All features functional

## 🔐 Data Privacy

- Không thu thập dữ liệu cá nhân
- Tất cả lưu local
- Không có analytics
- Không có ads

---

**Tài liệu này cung cấp cái nhìn tổng quan về cấu trúc dự án Asia Green. 
Để biết thêm chi tiết, xem README.md và GUIDE.md.**
