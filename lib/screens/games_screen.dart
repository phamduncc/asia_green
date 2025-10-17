import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import 'games/trash_sort_game.dart';
import 'games/river_clean_game.dart';
import 'games/tree_plant_game.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final Map<String, int?> _highScores = {};

  List<GameInfo> _getGames(AppLocalizations l10n) {
    return [
      GameInfo(
        name: l10n.locale.languageCode == 'vi' ? 'Phân loại rác' : 'Sort Trash',
        description: l10n.locale.languageCode == 'vi' 
            ? 'Kéo thả rác vào đúng thùng để tái chế'
            : 'Drag and drop trash into correct bins',
        icon: '♻️',
        color: Colors.green,
        route: AppConstants.gameTrashSort,
      ),
      GameInfo(
        name: l10n.locale.languageCode == 'vi' ? 'Làm sạch dòng sông' : 'Clean the River',
        description: l10n.locale.languageCode == 'vi'
            ? 'Chạm để loại bỏ rác trôi nổi trên sông'
            : 'Tap to remove floating trash from river',
        icon: '💧',
        color: Colors.blue,
        route: AppConstants.gameRiverClean,
      ),
      GameInfo(
        name: l10n.locale.languageCode == 'vi' ? 'Trồng cây ảo' : 'Plant Trees',
        description: l10n.locale.languageCode == 'vi'
            ? 'Chăm sóc và trồng cây để tạo khu rừng xanh'
            : 'Care and plant trees to create green forest',
        icon: '🌳',
        color: Colors.teal,
        route: AppConstants.gameTreePlant,
      ),
      GameInfo(
        name: l10n.locale.languageCode == 'vi' ? 'Tiết kiệm năng lượng' : 'Save Energy',
        description: l10n.locale.languageCode == 'vi'
            ? 'Tắt các thiết bị điện không sử dụng'
            : 'Turn off unused electrical devices',
        icon: '💡',
        color: Colors.orange,
        route: AppConstants.gameEnergySave,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final db = DatabaseHelper.instance;
    final routes = [
      AppConstants.gameTrashSort,
      AppConstants.gameRiverClean,
      AppConstants.gameTreePlant,
      AppConstants.gameEnergySave,
    ];
    
    for (final route in routes) {
      final score = await db.getHighScore(route);
      setState(() {
        _highScores[route] = score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final games = _getGames(l10n);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.educationalGames),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _buildGameCard(game);
        },
      ),
    );
  }

  Widget _buildGameCard(GameInfo game) {
    final l10n = AppLocalizations.of(context)!;
    final highScore = _highScores[game.route];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _navigateToGame(game),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                game.color.withOpacity(0.1),
                game.color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: game.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    game.icon,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (highScore != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 16,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n.highScore}: $highScore',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.play_circle_filled,
                size: 40,
                color: game.color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGame(GameInfo game) {
    Widget screen;
    
    switch (game.route) {
      case AppConstants.gameTrashSort:
        screen = const TrashSortGame();
        break;
      case AppConstants.gameRiverClean:
        screen = const RiverCleanGame();
        break;
      case AppConstants.gameTreePlant:
        screen = const TreePlantGame();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trò chơi đang được phát triển')),
        );
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((_) => _loadHighScores());
  }
}

class GameInfo {
  final String name;
  final String description;
  final String icon;
  final Color color;
  final String route;

  GameInfo({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
}
