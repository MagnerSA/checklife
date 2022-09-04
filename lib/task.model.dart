class Task {
  String title;
  String? description;
  bool? closed = false;

  Task({
    required this.title,
    this.description,
    this.closed,
  });
}
