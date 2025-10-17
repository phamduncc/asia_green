import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/game_score.dart';
import '../../services/database_helper.dart';
import '../../utils/constants.dart';

class RiverCleanGame extends StatefulWidget {
  const RiverCleanGame({super.key});

  @override
  State<RiverCleanGame> createState() => _RiverCleanGameState();
}

class _RiverCleanGameState extends State<RiverCleanGame> {
  int _score = 0;
  int _timeLeft = 45;
  Timer? _timer;
  Timer? _spawnTimer;
  bool _isPlaying = false;
  final List<TrashInRiver> _trashItems = [];
  final Random _random = Random();

  final List<String> _trashIcons = ['🍾', '🥫', '🛍️', '📦', '🗑️', '🧴', '👟', '⚽'];

  @override
  void dispose() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _score = 0;
      _timeLeft = 45;
      _isPlaying = true;
      _trashItems.clear();
    });
    _startTimer();
    _startSpawning();
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

  void _startSpawning() {
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_isPlaying && _trashItems.length < 8) {
        _spawnTrash();
      }
    });
  }

  void _spawnTrash() {
    final icon = _trashIcons[_random.nextInt(_trashIcons.length)];
    final left = _random.nextDouble() * 0.8;
    
    setState(() {
      _trashItems.add(
        TrashInRiver(
          icon: icon,
          left: left,
          top: -0.1,
        ),
      );
    });

    _animateTrash(_trashItems.length - 1);
  }

  void _animateTrash(int index) {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isPlaying || index >= _trashItems.length) {
        timer.cancel();
        return;
      }

      setState(() {
        _trashItems[index].top += 0.01;
        
        if (_trashItems[index].top > 1.1) {
          _trashItems.removeAt(index);
          timer.cancel();
        }
      });
    });
  }

  void _removeTrash(int index) {
    setState(() {
      _score += 5;
      _trashItems.removeAt(index);
    });
  }

  void _endGame() {
    _timer?.cancel();
    _spawnTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });

    _saveScore();
    _showResultDialog();
  }

  Future<void> _saveScore() async {
    final gameScore = GameScore(
      gameName: AppConstants.gameRiverClean,
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
            const Text('💧', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Điểm số: $_score',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _score >= 100
                  ? 'Dòng sông sạch! Xuất sắc!'
                  : _score >= 50
                      ? 'Tốt lắm! Tiếp tục cố gắng!'
                      : 'Hãy cố gắng hơn nữa!',
              textAlign: TextAlign.center,
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
        title: const Text('Làm sạch dòng sông'),
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
            const Text('💧', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            const Text(
              'Làm sạch dòng sông',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chạm để loại bỏ rác trôi nổi trên sông!\nCàng nhiều rác bạn dọn, điểm càng cao!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Cách chơi:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTipRow('👆', 'Chạm vào rác để dọn sạch'),
                    _buildTipRow('⏱️', 'Hoàn thành trong 45 giây'),
                    _buildTipRow('⭐', 'Mỗi rác = 5 điểm'),
                  ],
                ),
              ),
            ),
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

  Widget _buildTipRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildGameScreen() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue[100]!,
                Colors.blue[200]!,
                Colors.blue[400]!,
              ],
            ),
          ),
        ),
        // River waves effect
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[400]!.withOpacity(0.5),
                  Colors.blue[600]!,
                ],
              ),
            ),
          ),
        ),
        // Trash items
        ...List.generate(_trashItems.length, (index) {
          final trash = _trashItems[index];
          return Positioned(
            left: MediaQuery.of(context).size.width * trash.left,
            top: MediaQuery.of(context).size.height * trash.top,
            child: GestureDetector(
              onTap: () => _removeTrash(index),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  trash.icon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          );
        }),
        // HUD
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildHudItem('⏱️', '$_timeLeft s'),
                  _buildHudItem('⭐', '$_score'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHudItem(String icon, String value) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class TrashInRiver {
  final String icon;
  final double left;
  double top;

  TrashInRiver({
    required this.icon,
    required this.left,
    required this.top,
  });
}
