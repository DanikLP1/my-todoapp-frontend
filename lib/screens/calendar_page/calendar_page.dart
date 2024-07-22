import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/screens/calendar_page/skeleton_calendar.dart';
import 'package:my_todo_app/screens/crud_tasks/task_creation_page.dart';
import 'package:my_todo_app/screens/error_screen.dart';
import 'package:my_todo_app/screens/widgets/task_card.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/models/task.dart';
import '../../blocs/schedule/bloc.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state is ScheduleError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBarUtil.errorSnackBar(state.error),
            );
          }
        },
        builder: (context, state) {
          if (state is ScheduleLoaded) {
            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ScheduleBloc>().add(LoadScheduleRequested());
                    },
                    child: CalendarPageView(
                      toDoLists: state.todoLists,
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ScheduleLoading) {
            return Column(
              children: [
                CalendarShimmerLoader(),
                Expanded(
                  child: TaskListShimmerLoader(),
                ),
              ],
            );
          } else if (state is ScheduleError) {
            return ErrorScreen(
              errorMessage: "Не удалось загрузить данные, проверьте ваше интернет соединение", 
              onRetry: () {
                context.read<ScheduleBloc>().add(LoadScheduleRequested());
              }
            );
          } else {
            return Column(
              children: [
                CalendarShimmerLoader(),
                Expanded(
                  child: TaskListShimmerLoader(),
                ),
              ],
            );
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

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that super.build is called for AutomaticKeepAliveClientMixin
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoaded) {
          todoLists = state.todoLists; // Обновление списка задач
        }
        return Padding(
          padding: EdgeInsets.all(16),
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
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: (day) => _getTasksForDay(day, todoLists),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle().copyWith(color: Theme.of(context).colorScheme.secondary), // Цвет выходных
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                      final text = DateFormat.E('ru_RU').format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                      );
                    }
                    return null;
                  },
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: _buildEventsMarker(events.length, Theme.of(context).colorScheme.secondary),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TaskCreationPage(
                        selectedDate: _selectedDay,
                      ),
                    ),
                  );
                },
                child: Text('Создать задачу'),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: _getTasksForDay(_selectedDay ?? DateTime.now(), todoLists)
                      .map((task) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: TaskCard(task: task, onTap: () {}),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Widget _buildEventsMarker(int count, Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
