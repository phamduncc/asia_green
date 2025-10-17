import 'package:flutter/material.dart';
import '../models/question.dart';
import '../utils/constants.dart';

class QuizScreen extends StatefulWidget {
  final String categoryName;
  final String categoryIcon;
  final List<Question> questions;

  const QuizScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _isAnswered = false;
  bool _isQuizComplete = false;

  Question get _currentQuestion => widget.questions[_currentQuestionIndex];

  @override
  Widget build(BuildContext context) {
    if (_isQuizComplete) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Câu ${_currentQuestionIndex + 1}/${widget.questions.length}'),
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionCard(),
                  const SizedBox(height: 24),
                  _buildOptions(),
                  if (_isAnswered) ...[
                    const SizedBox(height: 24),
                    _buildExplanation(),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQuestionIndex + 1) / widget.questions.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Điểm: $_score/${widget.questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(_currentQuestionIndex + 1)}/${widget.questions.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppConstants.lightGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          _currentQuestion.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(
        _currentQuestion.options.length,
        (index) => _buildOptionCard(index),
      ),
    );
  }

  Widget _buildOptionCard(int index) {
    final isSelected = _selectedAnswer == index;
    final isCorrect = index == _currentQuestion.correctAnswer;
    
    Color? backgroundColor;
    Color? borderColor;
    
    if (_isAnswered) {
      if (isCorrect) {
        backgroundColor = Colors.green[50];
        borderColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red[50];
        borderColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = AppConstants.lightGreen.withOpacity(0.1);
      borderColor = AppConstants.lightGreen;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: _isAnswered ? null : () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? (_isAnswered
                          ? (isCorrect ? Colors.green : Colors.red)
                          : AppConstants.lightGreen)
                      : Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _currentQuestion.options[index],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (_isAnswered && isCorrect)
                const Icon(Icons.check_circle, color: Colors.green),
              if (_isAnswered && isSelected && !isCorrect)
                const Icon(Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanation() {
    final isCorrect = _selectedAnswer == _currentQuestion.correctAnswer;
    
    return Card(
      color: isCorrect ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.info,
                  color: isCorrect ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  isCorrect ? 'Chính xác!' : 'Giải thích',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _currentQuestion.explanation,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isAnswered ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: Text(
              _currentQuestionIndex < widget.questions.length - 1
                  ? 'Câu tiếp theo'
                  : 'Xem kết quả',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (_score / widget.questions.length * 100).toInt();
    String message;
    String emoji;
    
    if (percentage >= 80) {
      message = 'Xuất sắc! Bạn hiểu rất rõ về môi trường!';
      emoji = '🌟';
    } else if (percentage >= 60) {
      message = 'Tốt lắm! Tiếp tục học hỏi nhé!';
      emoji = '👍';
    } else {
      message = 'Cố gắng hơn nhé! Hãy đọc lại kiến thức.';
      emoji = '💪';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kết quả'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.categoryIcon,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 24),
              Text(
                'Điểm của bạn',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_score/${widget.questions.length}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Restart quiz with new random questions
                    setState(() {
                      _currentQuestionIndex = 0;
                      _score = 0;
                      _selectedAnswer = null;
                      _isAnswered = false;
                      _isQuizComplete = false;
                    });
                    // Shuffle questions for variety
                    widget.questions.shuffle();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Làm lại'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      
      if (index == _currentQuestion.correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _saveProgress();
      setState(() {
        _isQuizComplete = true;
      });
    }
  }

  Future<void> _saveProgress() async {
    // Progress saved per category quiz completion
    // Can be extended to save category-specific progress if needed
  }
}
