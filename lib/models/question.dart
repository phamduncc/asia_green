class Question {
  final int? id;
  final int lessonId;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  Question({
    this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lessonId': lessonId,
      'question': question,
      'options': options.join('|||'), // Delimiter for storing list as string
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      lessonId: map['lessonId'] as int,
      question: map['question'] as String,
      options: (map['options'] as String).split('|||'),
      correctAnswer: map['correctAnswer'] as int,
      explanation: map['explanation'] as String,
    );
  }
}
