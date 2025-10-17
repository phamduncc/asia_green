import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/lesson.dart';
import '../utils/constants.dart';

class LessonDetailScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("vi-VN");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  Future<void> _speak() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      
      // Remove markdown formatting for better speech
      final cleanContent = widget.lesson.content
          .replaceAll('**', '')
          .replaceAll('•', '')
          .replaceAll('  ', ' ');
      
      await _flutterTts.speak(cleanContent);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài học'),
        actions: [
          IconButton(
            icon: Icon(_isSpeaking ? Icons.stop : Icons.volume_up),
            onPressed: _speak,
            tooltip: _isSpeaking ? 'Dừng đọc' : 'Đọc nội dung',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildContent(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showSummary();
        },
        icon: const Icon(Icons.lightbulb_outline),
        label: const Text('Tóm tắt'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
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
            widget.lesson.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getCategoryName(widget.lesson.category),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormattedContent(widget.lesson.content),
        ],
      ),
    );
  }

  Widget _buildFormattedContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      if (line.startsWith('**') && line.endsWith('**')) {
        // Bold heading
        final text = line.replaceAll('**', '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryGreen,
              ),
            ),
          ),
        );
      } else if (line.trim().startsWith('•')) {
        // Bullet point
        final text = line.trim().substring(1).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Regular text
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  String _getCategoryName(String category) {
    const categories = {
      'water': 'Nước',
      'waste': 'Rác thải',
      'energy': 'Năng lượng',
      'climate': 'Khí hậu',
      'nature': 'Thiên nhiên',
    };
    return categories[category] ?? category;
  }

  void _showSummary() {
    final summaries = {
      'water': 'Bảo vệ nguồn nước bằng cách không xả rác, xử lý nước thải đúng cách, và tiết kiệm nước.',
      'waste': 'Giảm rác thải nhựa, tái chế đúng cách, sử dụng sản phẩm tái sử dụng.',
      'energy': 'Tiết kiệm điện, sử dụng thiết bị hiệu quả, tắt nguồn khi không dùng.',
      'climate': 'Giảm phát thải CO2, trồng cây, sử dụng giao thông xanh, tiêu thụ bền vững.',
      'nature': 'Trồng và bảo vệ cây xanh, bảo vệ đa dạng sinh học, không săn bắt động vật hoang dã.',
    };

    final summary = summaries[widget.lesson.category] ?? 
        'Hãy áp dụng kiến thức đã học để bảo vệ môi trường!';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lightbulb, color: AppConstants.primaryGreen),
            SizedBox(width: 8),
            Text('Tóm tắt nhanh'),
          ],
        ),
        content: Text(
          summary,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
