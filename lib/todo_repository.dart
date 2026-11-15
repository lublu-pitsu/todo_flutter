import 'todo.dart';

class TodoRepository {
  final List<Todo> list = [];

  List<Todo> getAll() {
    return List.unmodifiable(list);
  }

  void add(String title, {DateTime? deadline}) {
    list.add(
      Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        created: DateTime.now(),
        deadline: deadline,
      ),
    );
  }

  void update(String id, String title, {DateTime? deadline}) {
    final i = list.indexWhere((t) => t.id == id);
    if (i != -1) {
      list[i].title = title;
      list[i].deadline = deadline;
    }
  }

  void toggle(String id) {
    final i = list.indexWhere((t) => t.id == id);
    if (i != -1) {
      list[i].done = !list[i].done;
    }
  }

  void delete(String id) {
    list.removeWhere((t) => t.id == id);
  }
}
