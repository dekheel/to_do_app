class Task {
  String? id;
  String? title;
  String? details;
  DateTime? date;

  bool? isDone;

  static String taskCollection = "Tasks";

  Task(
      {this.id = '',
      this.isDone = false,
      required this.title,
      required this.details,
      required this.date});

  Map<String, dynamic> toFirebase() {
    return {
      "id": id,
      "title": title,
      "details": details,
      "date": date?.millisecondsSinceEpoch,
      "isDone": isDone
    };
  }

  Task.fromFirebase(Map<String, dynamic> data)
      : this(
            id: data["id"] as String,
            isDone: data["isDone"] as bool,
            date: DateTime.fromMillisecondsSinceEpoch(data["date"]),
            details: data["details"] as String,
            title: data["title"] as String);
}
