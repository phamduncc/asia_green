class Progress {
  final int? id;
  final int lessonId;
  final int score;
  final DateTime completedAt;

  Progress({
    this.id,
    required this.lessonId,
    required this.score,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'score': score,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'] as int?,
      lessonId: map['lessonId'] as int,
      score: map['score'] as int,
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }
}
