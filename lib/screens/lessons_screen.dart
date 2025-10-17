import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  List<Lesson> _lessons = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  final Map<String, String> _categories = {
    'all': 'Tất cả',
    'water': 'Nước',
    'waste': 'Rác thải',
    'energy': 'Năng lượng',
    'climate': 'Khí hậu',
    'nature': 'Thiên nhiên',
  };

  final Map<String, String> _categoryIcons = {
    'all': '📚',
    'water': '💧',
    'waste': '♻️',
    'energy': '⚡',
    'climate': '🌍',
    'nature': '🌳',
  };

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    setState(() => _isLoading = true);
    
    final db = DatabaseHelper.instance;
    final lessons = _selectedCategory == 'all'
        ? await db.getLessons()
        : await db.getLessonsByCategory(_selectedCategory);

    setState(() {
      _lessons = lessons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.lessons),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _lessons.isEmpty
                    ? _buildEmptyState()
                    : _buildLessonsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final l10n = AppLocalizations.of(context)!;
    final categories = _getCategoriesMap(l10n);
    
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories.keys.elementAt(index);
          final label = categories[category]!;
          final icon = _categoryIcons[category]!;
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(icon),
                  const SizedBox(width: 4),
                  Text(label),
                ],
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = category);
                  _loadLessons();
                }
              },
              selectedColor: AppConstants.lightGreen,
              checkmarkColor: Colors.white,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📚',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.lessons,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> _getCategoriesMap(AppLocalizations l10n) {
    return {
      'all': l10n.allCategories,
      'water': l10n.water,
      'waste': l10n.waste,
      'energy': l10n.energy,
      'climate': l10n.climate,
      'nature': l10n.nature,
    };
  }

  Widget _buildLessonsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      itemBuilder: (context, index) {
        final lesson = _lessons[index];
        return _buildLessonCard(lesson);
      },
    );
  }

  Widget _buildLessonCard(Lesson lesson) {
    final l10n = AppLocalizations.of(context)!;
    final categories = _getCategoriesMap(l10n);
    final categoryIcon = _categoryIcons[lesson.category] ?? '📘';
    final categoryName = categories[lesson.category] ?? lesson.category;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailScreen(lesson: lesson),
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
                  color: AppConstants.lightGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categoryIcon,
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
                      lesson.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
