class Task {
  late String id;
  late String title;
  late String? description;
  late bool closed = false;

  late String date;
  late String createdAt;
  late String closedAt;
  late int type;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.closed,
    required this.date,
    required this.createdAt,
    required this.closedAt,
    required this.type,
  });

  Task.fromMap(Map<String, dynamic> map) {
    id = map["_id"] ?? "";
    title = map["title"] ?? "";
    date = map["date"] ?? "";
    closed = map["closed"] ?? false;
    description = map["description"] ?? "";
    createdAt = map["createdAt"] ?? "";
    closedAt = map["closedAt"] ?? "";
    type = map["type"] ?? 0;
  }

  toMap() {
    return {
      "_id": id,
      "description": description,
      "title": title,
      "closed": closed,
      "date": date,
      "createdAt": createdAt,
      "closedAt": createdAt,
      "type": type,
    };
  }

  setClosedAt(String closedAt) {
    this.closedAt = closedAt;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
