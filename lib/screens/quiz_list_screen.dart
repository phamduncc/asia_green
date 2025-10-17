import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import 'quiz_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  final Map<String, String> _categoryNames = {
    'water': 'Nước & Môi trường',
    'waste': 'Rác thải & Tái chế',
    'energy': 'Năng lượng',
    'climate': 'Biến đổi khí hậu',
    'nature': 'Thiên nhiên & Sinh thái',
  };

  final Map<String, String> _categoryIcons = {
    'water': '💧',
    'waste': '♻️',
    'energy': '⚡',
    'climate': '🌍',
    'nature': '🌳',
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final db = DatabaseHelper.instance;
    final categories = await db.getCategories();

    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.quizzes),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? _buildEmptyState()
              : _buildQuizList(),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🧠',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.quizzes,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getCategoryNames(AppLocalizations l10n) {
    return {
      'water': l10n.water,
      'waste': l10n.waste,
      'energy': l10n.energy,
      'climate': l10n.climate,
      'nature': l10n.nature,
    };
  }

  Widget _buildQuizList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return _buildQuizCard(category);
      },
    );
  }

  Widget _buildQuizCard(Map<String, dynamic> category) {
    final l10n = AppLocalizations.of(context)!;
    final categoryNames = _getCategoryNames(l10n);
    final categoryKey = category['category'] as String;
    final questionCount = category['questionCount'] as int;
    final lessonCount = category['lessonCount'] as int;
    
    final icon = _categoryIcons[categoryKey] ?? '📝';
    final title = categoryNames[categoryKey] ?? categoryKey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final db = DatabaseHelper.instance;
          final questions = await db.getQuestionsByCategory(categoryKey, limit: 10);

          if (!context.mounted) return;

          if (questions.isEmpty) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.questions),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                categoryName: title,
                categoryIcon: icon,
                questions: questions,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.accentBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$lessonCount ${l10n.lessons} • $questionCount ${l10n.questions}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '10 ${l10n.questions}',
                  style: const TextStyle(
                    color: AppConstants.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
