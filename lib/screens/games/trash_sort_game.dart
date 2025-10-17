import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/game_score.dart';
import '../../services/database_helper.dart';
import '../../utils/constants.dart';

class TrashSortGame extends StatefulWidget {
  const TrashSortGame({super.key});

  @override
  State<TrashSortGame> createState() => _TrashSortGameState();
}

class _TrashSortGameState extends State<TrashSortGame> {
  int _score = 0;
  int _lives = 3;
  int _timeLeft = 60;
  Timer? _timer;
  bool _isPlaying = false;
  TrashItem? _currentTrash;
  final Random _random = Random();

  final List<TrashType> _trashTypes = [
    TrashType(name: 'Chai nhựa', icon: '🍾', category: TrashCategory.recyclable),
    TrashType(name: 'Vỏ lon', icon: '🥫', category: TrashCategory.recyclable),
    TrashType(name: 'Hộp giấy', icon: '📦', category: TrashCategory.recyclable),
    TrashType(name: 'Túi nilon', icon: '🛍️', category: TrashCategory.recyclable),
    TrashType(name: 'Vỏ chuối', icon: '🍌', category: TrashCategory.organic),
    TrashType(name: 'Thức ăn thừa', icon: '🍎', category: TrashCategory.organic),
    TrashType(name: 'Lá cây', icon: '🍂', category: TrashCategory.organic),
    TrashType(name: 'Pin', icon: '🔋', category: TrashCategory.hazardous),
    TrashType(name: 'Bóng đèn', icon: '💡', category: TrashCategory.hazardous),
    TrashType(name: 'Túi ni lông', icon: '🗑️', category: TrashCategory.general),
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _lives = 3;
      _timeLeft = 60;
      _isPlaying = true;
    });
    _generateNewTrash();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateNewTrash() {
    final trash = _trashTypes[_random.nextInt(_trashTypes.length)];
    setState(() {
      _currentTrash = TrashItem(type: trash);
    });
  }

  void _checkAnswer(TrashCategory selectedCategory) {
    if (_currentTrash == null) return;

    if (_currentTrash!.type.category == selectedCategory) {
      setState(() {
        _score += 10;
      });
      _showFeedback(true);
    } else {
      setState(() {
        _lives--;
        if (_lives <= 0) {
          _endGame();
          return;
        }
      });
      _showFeedback(false);
    }

    _generateNewTrash();
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? '✓ Chính xác! +10 điểm' : '✗ Sai rồi! -1 mạng'),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    _saveScore();
    _showResultDialog();
  }

  Future<void> _saveScore() async {
    final gameScore = GameScore(
      gameName: AppConstants.gameTrashSort,
      score: _score,
      playedAt: DateTime.now(),
    );
    await DatabaseHelper.instance.insertGameScore(gameScore);
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Kết thúc!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Điểm số: $_score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Thoát'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('Chơi lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân loại rác'),
      ),
      body: _isPlaying ? _buildGameScreen() : _buildStartScreen(),
    );
  }

  Widget _buildStartScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('♻️', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            const Text(
              'Phân loại rác',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kéo thả rác vào đúng thùng để ghi điểm!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildInstructions(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Bắt đầu',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionRow('♻️', 'Tái chế', 'Nhựa, giấy, lon'),
            const Divider(),
            _buildInstructionRow('🍃', 'Hữu cơ', 'Thức ăn, lá cây'),
            const Divider(),
            _buildInstructionRow('⚠️', 'Độc hại', 'Pin, bóng đèn'),
            const Divider(),
            _buildInstructionRow('🗑️', 'Thường', 'Rác khác'),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow(String icon, String title, String desc) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                desc,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameScreen() {
    return Column(
      children: [
        _buildGameHeader(),
        Expanded(
          child: Center(
            child: _currentTrash != null
                ? _buildTrashCard()
                : const CircularProgressIndicator(),
          ),
        ),
        _buildBinOptions(),
      ],
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppConstants.primaryGreen.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('⏱️', 'Thời gian', '$_timeLeft s'),
          _buildStatItem('⭐', 'Điểm', '$_score'),
          _buildStatItem('❤️', 'Mạng', '$_lives'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String label, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTrashCard() {
    return Card(
      elevation: 8,
      child: Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _currentTrash!.type.icon,
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 12),
            Text(
              _currentTrash!.type.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildBinButton('♻️', 'Tái chế', Colors.green, TrashCategory.recyclable),
          _buildBinButton('🍃', 'Hữu cơ', Colors.brown, TrashCategory.organic),
          _buildBinButton('⚠️', 'Độc hại', Colors.red, TrashCategory.hazardous),
          _buildBinButton('🗑️', 'Thường', Colors.grey, TrashCategory.general),
        ],
      ),
    );
  }

  Widget _buildBinButton(String icon, String label, Color color, TrashCategory category) {
    return ElevatedButton(
      onPressed: () => _checkAnswer(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.2),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

enum TrashCategory {
  recyclable,
  organic,
  hazardous,
  general,
}

class TrashType {
  final String name;
  final String icon;
  final TrashCategory category;

  TrashType({
    required this.name,
    required this.icon,
    required this.category,
  });
}

class TrashItem {
  final TrashType type;

  TrashItem({required this.type});
}
