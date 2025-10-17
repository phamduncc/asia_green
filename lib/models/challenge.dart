class Challenge {
  final int? id;
  final String title;
  final String description;
  final int points;
  final String icon;
  bool isCompleted;

  Challenge({
    this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'icon': icon,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> map) {
    return Challenge(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      icon: map['icon'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
    );
  }
}
