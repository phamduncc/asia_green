class GameScore {
  final int? id;
  final String gameName;
  final int score;
  final DateTime playedAt;

  GameScore({
    this.id,
    required this.gameName,
    required this.score,
    required this.playedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameName': gameName,
      'score': score,
      'playedAt': playedAt.toIso8601String(),
    };
  }

  factory GameScore.fromMap(Map<String, dynamic> map) {
    return GameScore(
      id: map['id'] as int?,
      gameName: map['gameName'] as String,
      score: map['score'] as int,
      playedAt: DateTime.parse(map['playedAt'] as String),
    );
  }
}
