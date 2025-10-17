import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../services/database_helper.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'lessons_screen.dart';
import 'quiz_list_screen.dart';
import 'games_screen.dart';
import 'challenges_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalPoints = 0;
  int _completedLessons = 0;
  int _completedChallenges = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final points = await db.getTotalPoints();
    final lessons = await db.getCompletedLessonsCount();
    final challenges = await db.getCompletedChallengesCount();

    setState(() {
      _totalPoints = points;
      _completedLessons = lessons;
      _completedChallenges = challenges;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
        actions: [
          // Language toggle
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return IconButton(
                icon: Text(
                  languageProvider.languageFlag,
                  style: const TextStyle(fontSize: 24),
                ),
                tooltip: languageProvider.currentLanguageName,
                onPressed: () {
                  languageProvider.toggleLanguage();
                  final l10n = AppLocalizations.of(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        languageProvider.locale.languageCode == 'vi'
                            ? 'Chuyển sang Tiếng Việt'
                            : 'Switched to English',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          // Theme toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(themeProvider.themeModeIcon),
                tooltip: 'Chế độ: ${themeProvider.themeModeLabel}',
                onPressed: () {
                  themeProvider.toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Chuyển sang chế độ ${themeProvider.themeModeLabel}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeCard(),
                      const SizedBox(height: 20),
                      _buildStatsCard(),
                      const SizedBox(height: 24),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildMotivationalCard(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final l10n = AppLocalizations.of(context)!;
    final userLevel = _getUserLevelText(_totalPoints, l10n);
    
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              AppConstants.primaryGreen,
              AppConstants.lightGreen,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.welcome} 🌱',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.slogan,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${l10n.yourLevel}: $userLevel',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.stars, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  '$_totalPoints ${l10n.greenPoints}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getUserLevelText(int points, AppLocalizations l10n) {
    if (points >= 1000) return l10n.levelEcoAmbassador;
    if (points >= 500) return l10n.levelGreenHouse;
    return l10n.levelBeginner;
  }

  Widget _buildStatsCard() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.yourLevel,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.school,
                  l10n.completedLessons,
                  _completedLessons.toString(),
                  AppConstants.lightGreen,
                ),
                _buildStatItem(
                  Icons.emoji_events,
                  l10n.completedChallenges,
                  _completedChallenges.toString(),
                  AppConstants.accentBlue,
                ),
                _buildStatItem(
                  Icons.eco,
                  l10n.greenPoints,
                  _totalPoints.toString(),
                  AppConstants.darkGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quickActions,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildActionCard(
              '📘',
              l10n.learn,
              l10n.lessons,
              AppConstants.lightGreen,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LessonsScreen()),
                ).then((_) => _loadData());
              },
            ),
            _buildActionCard(
              '🧠',
              l10n.quiz,
              l10n.quizzes,
              AppConstants.accentBlue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizListScreen()),
                ).then((_) => _loadData());
              },
            ),
            _buildActionCard(
              '🎮',
              l10n.games,
              l10n.educationalGames,
              Colors.orange,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GamesScreen()),
                ).then((_) => _loadData());
              },
            ),
            _buildActionCard(
              '🏆',
              l10n.challenges,
              l10n.greenChallenges,
              Colors.purple,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChallengesScreen()),
                ).then((_) => _loadData());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String emoji,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMotivationalCard() {
    final l10n = AppLocalizations.of(context)!;
    final messages = l10n.motivationalMessages;
    final randomMessage = messages[DateTime.now().day % messages.length];

    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppConstants.accentBlue.withOpacity(0.1),
        ),
        child: Text(
          randomMessage,
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.accentBlue,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asia Green',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('${l10n.version}: 1.0.0'),
            const SizedBox(height: 8),
            Text(l10n.slogan),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
