import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/game_score.dart';
import '../../services/database_helper.dart';
import '../../utils/constants.dart';

class TreePlantGame extends StatefulWidget {
  const TreePlantGame({super.key});

  @override
  State<TreePlantGame> createState() => _TreePlantGameState();
}

class _TreePlantGameState extends State<TreePlantGame> {
  int _trees = 0;
  int _water = 100;
  int _score = 0;
  Timer? _timer;
  bool _isPlaying = false;
  final List<int> _treeGrowth = [];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _trees = 0;
      _water = 100;
      _score = 0;
      _isPlaying = true;
      _treeGrowth.clear();
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _water = (_water - 5).clamp(0, 100);
        for (int i = 0; i < _treeGrowth.length; i++) {
          if (_water > 20 && _treeGrowth[i] < 100) {
            _treeGrowth[i] = (_treeGrowth[i] + 10).clamp(0, 100);
            if (_treeGrowth[i] == 100) _score += 20;
          }
        }
        if (_water <= 0) _endGame();
      });
    });
  }

  void _plantTree() {
    if (_treeGrowth.length >= 9) return;
    if (_water < 30) return;
    setState(() {
      _treeGrowth.add(0);
      _trees++;
      _water -= 20;
      _score += 10;
    });
  }

  void _addWater() {
    if (_score >= 5) {
      setState(() {
        _water = (_water + 30).clamp(0, 100);
        _score -= 5;
      });
    }
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _isPlaying = false);
    _saveScore();
    _showResultDialog();
  }

  Future<void> _saveScore() async {
    await DatabaseHelper.instance.insertGameScore(GameScore(
      gameName: AppConstants.gameTreePlant,
      score: _score,
      playedAt: DateTime.now(),
    ));
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Kết thúc!'),
        content: Text('Điểm: $_score\nCây: $_trees'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Thoát')),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
            _startGame();
          }, child: const Text('Chơi lại')),
        ],
      ),
    ).then((exit) => {if (exit == true) Navigator.pop(context)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trồng cây')),
      body: _isPlaying ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('💧 Nước: $_water%'),
                Text('⭐ Điểm: $_score'),
                Text('🌳 Cây: $_trees'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (c, i) {
                if (i < _treeGrowth.length) {
                  final growth = _treeGrowth[i];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(growth < 30 ? '🌱' : growth < 70 ? '🌿' : '🌳', style: const TextStyle(fontSize: 40)),
                        Text('$growth%'),
                      ],
                    ),
                  );
                }
                return Card(
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.add, size: 32),
                      onPressed: _plantTree,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addWater,
                    icon: const Icon(Icons.water_drop),
                    label: const Text('Tưới nước (-5 điểm)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _endGame,
                    child: const Text('Kết thúc'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌳', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            const Text('Trồng cây ảo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              child: const Text('Bắt đầu', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
