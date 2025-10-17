class Lesson {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String? imagePath;
  final String? audioPath;
  final String? videoPath;
  final int orderIndex;

  Lesson({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    this.imagePath,
    this.audioPath,
    this.videoPath,
    required this.orderIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'videoPath': videoPath,
      'orderIndex': orderIndex,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      imagePath: map['imagePath'] as String?,
      audioPath: map['audioPath'] as String?,
      videoPath: map['videoPath'] as String?,
      orderIndex: map['orderIndex'] as int,
    );
  }
}
