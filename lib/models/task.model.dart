class Task {
  late String id;
  late String title;
  late String? description;
  late bool? closed = false;
  late String date;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.closed,
    required this.date,
  });

  Task.fromMap(Map<String, dynamic> map) {
    id = map["_id"] ?? "";
    title = map["title"] ?? "";
    date = map["date"] ?? "";
    closed = map["closed"] ?? false;
    description = map["description"] ?? "";
  }

  toMap() {
    return {
      "_id": id,
      "description": description,
      "title": title,
      "closed": closed,
      "date": date,
    };
  }
}
