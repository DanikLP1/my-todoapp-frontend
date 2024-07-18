import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/widgets/task_card.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/blocs/schedule/schedule_bloc.dart';

import '../../blocs/schedule/bloc.dart';


class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<ScheduleBloc>().add(LoadScheduleRequested());
            }, 
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoaded) {
            return CalendarPageView(toDoLists: state.todoLists);
          } else if (state is ScheduleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ScheduleError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            });
            return Center(child: Text('Failed to load user'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class CalendarPageView extends StatefulWidget {
  final List<ToDoList> toDoLists;

  CalendarPageView({required this.toDoLists});

  @override
  _CalendarPageViewState createState() => _CalendarPageViewState();
}

class _CalendarPageViewState extends State<CalendarPageView> with AutomaticKeepAliveClientMixin {
  late List<ToDoList> todoLists;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    todoLists = widget.toDoLists;
  }

  List<Task> _getTasksForDay(DateTime day, List<ToDoList> todoLists) {
    var selectedToDoList = todoLists.firstWhere(
      (todoList) =>
          todoList.date == null 
          ? DateTime(todoList.createdAt.year, todoList.createdAt.month, todoList.createdAt.day).isAtSameMomentAs(DateTime(day.year, day.month, day.day))
          : DateTime(todoList.date!.year, todoList.date!.month, todoList.date!.day).isAtSameMomentAs(DateTime(day.year, day.month, day.day)),
      orElse: () => ToDoList(id: -1, userId: -1, title: '', date: null, createdAt: day, updatedAt: day, tasks: []),
    );

    return selectedToDoList.tasks;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that super.build is called for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TableCalendar(
            locale: 'ru_RU',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) => _getTasksForDay(day, todoLists),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: theme.colorScheme.secondary,
              ),
              defaultTextStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.lightGreen,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 20.0,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: theme.colorScheme.primary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.primary,
              ),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                switch (day.weekday) {
                  case 1:
                    return Center(
                      child: Text('Пн', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  case 2:
                    return Center(
                      child: Text('Вт', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  case 3:
                    return Center(
                      child: Text('Ср', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  case 4:
                    return Center(
                      child: Text('Чт', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  case 5:
                    return Center(
                      child: Text('Пт', style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  case 6:
                    return Center(
                      child: Text('Сб', style: TextStyle(color: theme.colorScheme.secondary)),
                    );
                  case 7:
                    return Center(
                      child: Text('Вс', style: TextStyle(color: theme.colorScheme.secondary)),
                    );
                  default:
                    return SizedBox.shrink();
                }
              },
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: _buildEventsMarker(events.length, theme.colorScheme.secondary),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {}, 
            child: Text("Создать задание")
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _getTasksForDay(_selectedDay!, todoLists).isEmpty
                ? Center(child: Text('На этот день нет запланированных задач, отдыхайте!'))
                : ListView(
                    children: _getTasksForDay(_selectedDay!, todoLists).map((task) {
                      return TaskCard(task: task, onTap: () {});
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(int count, Color color) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _switchCalendarFormat() {
    setState(() {
      _calendarFormat = _getNextCalendarFormat();
    });
  }

  CalendarFormat _getNextCalendarFormat() {
    switch (_calendarFormat) {
      case CalendarFormat.month:
        return CalendarFormat.twoWeeks;
      case CalendarFormat.twoWeeks:
        return CalendarFormat.week;
      case CalendarFormat.week:
        return CalendarFormat.month;
      default:
        return CalendarFormat.month;
    }
  }

  String _getButtonText() {
    switch (_calendarFormat) {
      case CalendarFormat.month:
        return 'Месяц';
      case CalendarFormat.twoWeeks:
        return '2 Недели';
      case CalendarFormat.week:
        return 'Неделя';
      default:
        return 'Месяц';
    }
  }
}
