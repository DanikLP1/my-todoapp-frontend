import 'package:flutter/material.dart';
import 'package:my_todo_app/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          leading: Icon(Icons.event, color: theme.colorScheme.primary),
          trailing: Text(
            task.completed 
            ? 'Выполнено' 
            : 'Не выполнено', 
            style: TextStyle(
              color: task.completed
              ? Colors.greenAccent
              : Colors.redAccent 
            ),
          ),
        ),
      ),
    );
  }
}
