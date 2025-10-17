import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('vi', 'VN'), // Tiếng Việt
    Locale('en', 'US'), // English
  ];

  // App name & general
  String get appName => locale.languageCode == 'vi' ? 'Asia Green' : 'Asia Green';
  String get welcome => locale.languageCode == 'vi' ? 'Xin chào!' : 'Welcome!';
  String get slogan => locale.languageCode == 'vi' 
      ? 'Mỗi hành động nhỏ, thay đổi lớn!' 
      : 'Small actions, big changes!';

  // Navigation
  String get learn => locale.languageCode == 'vi' ? 'Học' : 'Learn';
  String get quiz => locale.languageCode == 'vi' ? 'Kiểm tra' : 'Quiz';
  String get games => locale.languageCode == 'vi' ? 'Trò chơi' : 'Games';
  String get challenges => locale.languageCode == 'vi' ? 'Thử thách' : 'Challenges';

  // Dashboard
  String get yourLevel => locale.languageCode == 'vi' ? 'Cấp độ của bạn' : 'Your Level';
  String get greenPoints => locale.languageCode == 'vi' ? 'Điểm xanh' : 'Green Points';
  String get completedLessons => locale.languageCode == 'vi' ? 'Bài học hoàn thành' : 'Completed Lessons';
  String get completedChallenges => locale.languageCode == 'vi' ? 'Thử thách hoàn thành' : 'Completed Challenges';
  String get quickActions => locale.languageCode == 'vi' ? 'Truy cập nhanh' : 'Quick Actions';
  String get motivation => locale.languageCode == 'vi' ? 'Động lực' : 'Motivation';

  // Levels
  String get levelBeginner => locale.languageCode == 'vi' ? 'Người mới' : 'Beginner';
  String get levelGreenHouse => locale.languageCode == 'vi' ? 'Nhà Xanh' : 'Green House';
  String get levelEcoAmbassador => locale.languageCode == 'vi' ? 'Đại sứ Môi trường' : 'Eco Ambassador';

  // Lessons
  String get lessons => locale.languageCode == 'vi' ? 'Bài học' : 'Lessons';
  String get allCategories => locale.languageCode == 'vi' ? 'Tất cả' : 'All';
  String get water => locale.languageCode == 'vi' ? 'Nước' : 'Water';
  String get waste => locale.languageCode == 'vi' ? 'Rác thải' : 'Waste';
  String get energy => locale.languageCode == 'vi' ? 'Năng lượng' : 'Energy';
  String get climate => locale.languageCode == 'vi' ? 'Khí hậu' : 'Climate';
  String get nature => locale.languageCode == 'vi' ? 'Thiên nhiên' : 'Nature';
  String get readMore => locale.languageCode == 'vi' ? 'Đọc thêm' : 'Read more';
  String get quickSummary => locale.languageCode == 'vi' ? 'Tóm tắt nhanh' : 'Quick Summary';
  String get listen => locale.languageCode == 'vi' ? 'Nghe' : 'Listen';
  String get pause => locale.languageCode == 'vi' ? 'Tạm dừng' : 'Pause';

  // Quiz
  String get quizzes => locale.languageCode == 'vi' ? 'Kiểm tra' : 'Quizzes';
  String get questions => locale.languageCode == 'vi' ? 'câu hỏi' : 'questions';
  String get startQuiz => locale.languageCode == 'vi' ? 'Bắt đầu' : 'Start Quiz';
  String get next => locale.languageCode == 'vi' ? 'Tiếp theo' : 'Next';
  String get submit => locale.languageCode == 'vi' ? 'Nộp bài' : 'Submit';
  String get yourScore => locale.languageCode == 'vi' ? 'Điểm của bạn' : 'Your Score';
  String get correct => locale.languageCode == 'vi' ? 'Đúng' : 'Correct';
  String get incorrect => locale.languageCode == 'vi' ? 'Sai' : 'Incorrect';
  String get explanation => locale.languageCode == 'vi' ? 'Giải thích' : 'Explanation';
  String get tryAgain => locale.languageCode == 'vi' ? 'Thử lại' : 'Try Again';
  String get backToList => locale.languageCode == 'vi' ? 'Về danh sách' : 'Back to List';

  // Games
  String get educationalGames => locale.languageCode == 'vi' ? 'Trò chơi Giáo dục' : 'Educational Games';
  String get highScore => locale.languageCode == 'vi' ? 'Kỷ lục' : 'High Score';
  String get score => locale.languageCode == 'vi' ? 'Điểm' : 'Score';
  String get level => locale.languageCode == 'vi' ? 'Level' : 'Level';
  String get timeLeft => locale.languageCode == 'vi' ? 'Thời gian' : 'Time';
  String get gameOver => locale.languageCode == 'vi' ? 'Kết thúc' : 'Game Over';
  String get playAgain => locale.languageCode == 'vi' ? 'Chơi lại' : 'Play Again';
  String get exit => locale.languageCode == 'vi' ? 'Thoát' : 'Exit';

  // Challenges
  String get greenChallenges => locale.languageCode == 'vi' ? 'Thử thách Xanh' : 'Green Challenges';
  String get points => locale.languageCode == 'vi' ? 'điểm' : 'points';
  String get complete => locale.languageCode == 'vi' ? 'Hoàn thành' : 'Complete';
  String get completed => locale.languageCode == 'vi' ? 'Đã hoàn thành' : 'Completed';
  String get earnedPoints => locale.languageCode == 'vi' ? 'Điểm đạt được' : 'Earned Points';

  // Settings & Others
  String get settings => locale.languageCode == 'vi' ? 'Cài đặt' : 'Settings';
  String get language => locale.languageCode == 'vi' ? 'Ngôn ngữ' : 'Language';
  String get theme => locale.languageCode == 'vi' ? 'Giao diện' : 'Theme';
  String get light => locale.languageCode == 'vi' ? 'Sáng' : 'Light';
  String get dark => locale.languageCode == 'vi' ? 'Tối' : 'Dark';
  String get system => locale.languageCode == 'vi' ? 'Hệ thống' : 'System';
  String get about => locale.languageCode == 'vi' ? 'Giới thiệu' : 'About';
  String get version => locale.languageCode == 'vi' ? 'Phiên bản' : 'Version';

  // Motivational messages
  List<String> get motivationalMessages => locale.languageCode == 'vi' 
      ? [
          'Bạn đang làm rất tốt! 🌱',
          'Mỗi bước nhỏ đều quan trọng! 🌍',
          'Cảm ơn vì đã bảo vệ Trái Đất! 💚',
          'Bạn là người hùng môi trường! 🦸',
          'Tiếp tục phát huy nhé! ⭐',
        ]
      : [
          'You\'re doing great! 🌱',
          'Every small step matters! 🌍',
          'Thanks for protecting Earth! 💚',
          'You\'re an eco hero! 🦸',
          'Keep up the good work! ⭐',
        ];

  // Common
  String get yes => locale.languageCode == 'vi' ? 'Có' : 'Yes';
  String get no => locale.languageCode == 'vi' ? 'Không' : 'No';
  String get ok => locale.languageCode == 'vi' ? 'OK' : 'OK';
  String get cancel => locale.languageCode == 'vi' ? 'Hủy' : 'Cancel';
  String get loading => locale.languageCode == 'vi' ? 'Đang tải...' : 'Loading...';
  String get error => locale.languageCode == 'vi' ? 'Lỗi' : 'Error';
  String get success => locale.languageCode == 'vi' ? 'Thành công' : 'Success';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['vi', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
