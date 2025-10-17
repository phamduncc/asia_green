import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../services/database_helper.dart';
import '../utils/constants.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  List<Challenge> _challenges = [];
  bool _isLoading = true;
  int _totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadChallenges();
  }

  Future<void> _loadChallenges() async {
    setState(() => _isLoading = true);
    
    final db = DatabaseHelper.instance;
    final challenges = await db.getChallenges();
    
    int points = 0;
    for (final challenge in challenges) {
      if (challenge.isCompleted) {
        points += challenge.points;
      }
    }

    setState(() {
      _challenges = challenges;
      _totalPoints = points;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _challenges.where((c) => c.isCompleted).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thử thách Xanh'),
      ),
      body: Column(
        children: [
          _buildStatsCard(completedCount),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildChallengesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(int completedCount) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.purple[400]!,
              Colors.purple[600]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              '🏆',
              'Hoàn thành',
              '$completedCount/${_challenges.length}',
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            _buildStatColumn(
              '⭐',
              'Điểm tích lũy',
              _totalPoints.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String emoji, String label, String value) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengesList() {
    if (_challenges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🏆',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có thử thách nào',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _challenges.length,
      itemBuilder: (context, index) {
        final challenge = _challenges[index];
        return _buildChallengeCard(challenge);
      },
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: challenge.isCompleted ? null : () => _showChallengeDialog(challenge),
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: challenge.isCompleted ? 0.6 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: challenge.isCompleted
                        ? Colors.grey[300]
                        : AppConstants.lightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      challenge.icon,
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
                        challenge.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: challenge.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.eco,
                            size: 16,
                            color: AppConstants.lightGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${challenge.points} điểm',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (challenge.isCompleted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 24,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.lightGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: AppConstants.primaryGreen,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChallengeDialog(Challenge challenge) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(challenge.icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                challenge.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.lightGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.eco,
                    color: AppConstants.lightGreen,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Phần thưởng: +${challenge.points} điểm xanh',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bạn đã hoàn thành thử thách này chưa?',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chưa'),
          ),
          ElevatedButton(
            onPressed: () {
              _completeChallenge(challenge);
              Navigator.pop(context);
            },
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }

  Future<void> _completeChallenge(Challenge challenge) async {
    challenge.isCompleted = true;
    await DatabaseHelper.instance.updateChallenge(challenge);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Bạn đã nhận được ${challenge.points} điểm xanh!'),
        backgroundColor: Colors.green,
      ),
    );
    
    _loadChallenges();
  }
}
