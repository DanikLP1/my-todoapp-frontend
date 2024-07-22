import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/blocs/schedule/bloc.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onTap;

  TaskCard({required this.task, required this.onTap});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late Color _cardColor;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Обновляем цвет карточки в зависимости от текущей темы
    final theme = Theme.of(context);
    _cardColor = theme.cardColor;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    String formattedDueTime = widget.task.dueDate != null
        ? DateFormat('HH:mm').format(widget.task.dueDate!)
        : 'Без времени';

    final cardHeight = height * 0.12;
    final iconSize = width * 0.05;
    final textSize = width * 0.04;
    final padding = width * 0.05;
    final backgroundHeight = cardHeight * 0.9;

    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state is ScheduleError) {
          SnackBarUtil.errorSnackBar(state.error);
        }
      },
      child: Dismissible(
        key: Key(widget.task.id.toString()),
        direction: DismissDirection.endToStart,
        dismissThresholds: {
          DismissDirection.endToStart: 0.5,
        },
        movementDuration: Duration(milliseconds: 500),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Подтвердите удаление'),
                content: Text('Вы уверены, что хотите удалить эту задачу?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Удалить'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          context.read<ScheduleBloc>().add(RemoveEventRequested(widget.task.listId, widget.task.id));
          SnackBarUtil.successSnackBar("Задача успешно удалена");
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Container(
            width: width * 0.125,
            height: backgroundHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.red[400],
            ),
            alignment: Alignment.center,
            child: Icon(Icons.delete, color: Colors.white, size: iconSize),
          ),
        ),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedOpacity(
                opacity: _opacityAnimation.value,
                duration: const Duration(milliseconds: 300),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: padding / 2, horizontal: padding),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: _cardColor, // Устанавливаем цвет карточки в зависимости от темы
                  child: InkWell(
                    onDoubleTap: !widget.task.completed
                        ? () {
                            _animationController.forward().then((_) {
                              context.read<ScheduleBloc>().add(CompleteTaskRequested(widget.task));
                              Future.delayed(Duration(milliseconds: 300), () {
                                _animationController.reverse();
                              });
                            });
                          }
                        : () {},
                    onTap: widget.onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: padding / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.access_time, color: Theme.of(context).colorScheme.secondary, size: iconSize),
                                SizedBox(width: width * 0.02),
                                Text(
                                  'Нужно сделать до $formattedDueTime',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: textSize * 0.9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Text(
                              widget.task.title,
                              style: TextStyle(fontSize: textSize),
                            ),
                            subtitle: Text(
                              widget.task.description,
                              style: TextStyle(fontSize: textSize * 0.6),
                            ),
                            leading: Icon(Icons.event, color: Theme.of(context).colorScheme.primary, size: iconSize),
                            trailing: Text(
                              widget.task.completed ? 'Выполнено' : 'Не выполнено',
                              style: TextStyle(
                                color: widget.task.completed ? Colors.greenAccent : Colors.redAccent,
                                fontSize: textSize * 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
