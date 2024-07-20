import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/blocs/schedule/bloc.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  TaskCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    // Форматирование времени выполнения задачи в 24-часовом формате
    String formattedDueTime = task.dueDate != null
        ? DateFormat('HH:mm').format(task.dueDate!)
        : 'Без времени';

    // Адаптивные размеры
    final cardHeight = height * 0.12;
    final iconSize = width * 0.05;
    final textSize = width * 0.04;
    final padding = width * 0.05;
    final backgroundHeight = cardHeight * 0.9;

    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleError) {
          // Обработка ошибок
          SnackBarUtil.errorSnackBar(state.error);
        }
      },
      child: Dismissible(
        key: Key(task.id.toString()), // Уникальный ключ для элемента
        direction: DismissDirection.endToStart,
        dismissThresholds: {
          DismissDirection.endToStart: 0.5,
        },
        movementDuration: Duration(milliseconds: 500),
        confirmDismiss: (direction) async {
          // Показываем диалог подтверждения удаления
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Подтвердите удаление'),
                content: Text('Вы уверены, что хотите удалить эту задачу?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Отменить удаление
                    },
                    child: Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Подтвердить удаление
                    },
                    child: Text('Удалить'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          // Удаление задачи после подтверждения
          context.read<ScheduleBloc>().add(RemoveEventRequested(task.listId, task.id));
          SnackBarUtil.successSnackBar("Задача успешно удалена");
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Container(
            width: width * 0.125, // Адаптивная ширина фона
            height: backgroundHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red[400],
            ),
            alignment: Alignment.center,
            child: Icon(Icons.delete, color: Colors.white, size: iconSize), // Адаптивный размер иконки
          ),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: padding / 2, horizontal: padding),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onDoubleTap: !task.completed
                ? () {
                    // Обработка завершения задачи при двойном нажатии
                    context.read<ScheduleBloc>().add(CompleteTaskRequested(task));
                  }
                : () {},
            onTap: onTap,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: padding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, color: theme.colorScheme.secondary, size: iconSize),
                      SizedBox(width: width * 0.02),
                      Text(
                        'Нужно сделать до $formattedDueTime',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: textSize * 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(fontSize: textSize),
                  ),
                  subtitle: Text(
                    task.description,
                    style: TextStyle(fontSize: textSize * 0.6),
                  ),
                  leading: Icon(Icons.event, color: theme.colorScheme.primary, size: iconSize),
                  trailing: Text(
                    task.completed ? 'Выполнено' : 'Не выполнено',
                    style: TextStyle(
                      color: task.completed ? Colors.greenAccent : Colors.redAccent,
                      fontSize: textSize * 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
