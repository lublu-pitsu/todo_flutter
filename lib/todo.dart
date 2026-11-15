class Todo {
  String id;
  String title;
  bool done;
  DateTime created;
  DateTime? deadline;

  Todo({
    required this.id,
    required this.title,
    this.done = false,
    required this.created,
    this.deadline,
  });
}
