class Task {
  late String id;
  late String title;
  late String? description;
  late bool closed = false;
  late String date;
  late String createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.closed,
    required this.date,
    required this.createdAt,
  });

  Task.fromMap(Map<String, dynamic> map) {
    id = map["_id"] ?? "";
    title = map["title"] ?? "";
    date = map["date"] ?? "";
    closed = map["closed"] ?? false;
    description = map["description"] ?? "";
    createdAt = map["createdAt"] ?? "";
  }

  toMap() {
    return {
      "_id": id,
      "description": description,
      "title": title,
      "closed": closed,
      "date": date,
      "createdAt": createdAt,
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
