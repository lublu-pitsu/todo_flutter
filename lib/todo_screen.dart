import 'package:flutter/material.dart';
import 'todo.dart';
import 'todo_repository.dart';
import 'todo_form_dialog.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final repo = TodoRepository();
  final search = TextEditingController();

  String filter = 'all';
  String query = '';

  List<Todo> get filtered {
    var list = repo.getAll();

    if (filter == 'active') {
      list = list.where((t) => !t.done).toList();
    } else if (filter == 'done') {
      list = list.where((t) => t.done).toList();
    }

    if (query.isNotEmpty) {
      list = list
          .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return list;
  }

  Future<void> openForm({Todo? todo}) async {
    final res = await showDialog<FormResult>(
      context: context,
      builder: (_) {
        return TodoFormDialog(
          title: todo?.title,
          deadline: todo?.deadline,
        );
      },
    );

    if (res != null) {
      setState(() {
        if (todo == null) {
          repo.add(res.title, deadline: res.deadline);
        } else {
          repo.update(todo.id, res.title, deadline: res.deadline);
        }
      });
    }
  }

  String formatTwo(int number) {
    return number.toString().padLeft(2, '0');
  }

  String formatDateTime(DateTime value) {
    return '${value.day}.${value.month}.${value.year}, ${formatTwo(value.hour)}:${formatTwo(value.minute)}';
  }

  String formatDate(DateTime value) {
    return '${formatTwo(value.day)}.${formatTwo(value.month)}.${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final list = filtered;

    return Scaffold(
      appBar: AppBar(
        title: Text('Мои задачи'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: 'Поиск задач...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                chip('Все', 'all'),
                chip('Активные', 'active'),
                chip('Выполненные', 'done'),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text('Задач нет'),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return item(list[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openForm();
        },
        tooltip: 'Добавить задачу',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget item(Todo todo) {
    final overdue = !todo.done &&
        todo.deadline != null &&
        todo.deadline!.isBefore(DateTime.now());

    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (_) {
          setState(() {
            repo.toggle(todo.id);
          });
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.done ? TextDecoration.lineThrough : TextDecoration.none,
          color: todo.done ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Создано: ${formatDateTime(todo.created)}'),
          if (todo.deadline != null)
            Text(
              'Выполнить до: ${formatDate(todo.deadline!)}',
              style: TextStyle(
                color: overdue ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              openForm(todo: todo);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                repo.delete(todo.id);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget chip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: filter == value,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            filter = value;
          });
        }
      },
    );
  }
}
