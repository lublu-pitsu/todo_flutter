import 'package:flutter/material.dart';

class FormResult {
  final String title;
  final DateTime? deadline;

  FormResult({required this.title, this.deadline});
}

class TodoFormDialog extends StatefulWidget {
  final String? title;
  final DateTime? deadline;

  const TodoFormDialog({
    super.key,
    this.title,
    this.deadline,
  });

  @override
  State<TodoFormDialog> createState() => _TodoFormDialogState();
}

class _TodoFormDialogState extends State<TodoFormDialog> {
  final form = GlobalKey<FormState>();
  late final TextEditingController input;
  DateTime? date;

  @override
  void initState() {
    super.initState();
    input = TextEditingController(text: widget.title ?? '');
    date = widget.deadline;
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Выберите срок выполнения',
      cancelText: 'Отмена',
      confirmText: 'ОК',
    );

    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  String format(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.'
        '${value.month.toString().padLeft(2, '0')}.'
        '${value.year}';
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.title != null;

    return AlertDialog(
      title: Text(edit ? 'Редактировать задачу' : 'Новая задача'),
      content: SingleChildScrollView(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: input,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Название задачи',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Название не может быть пустым';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: pickDate,
                      child: Text(
                        date == null
                            ? 'Выбрать срок выполнения'
                            : 'Выполнить до: ${format(date!)}',
                      ),
                    ),
                  ),
                  if (date != null)
                    IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      tooltip: 'Убрать дату',
                      onPressed: () {
                        setState(() {
                          date = null;
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              Navigator.pop(
                context,
                FormResult(
                  title: input.text.trim(),
                  deadline: date,
                ),
              );
            }
          },
          child: Text('Сохранить'),
        ),
      ],
    );
  }
}
