class TodoResponse {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoResponse({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoResponse.fromJson(Map<String, dynamic> json) {
    return TodoResponse(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
