import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/blocs/schedule/bloc.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/models/todo_list.dart';
import 'package:my_todo_app/screens/calendar_page/skeleton_calendar.dart';
import 'package:my_todo_app/screens/widgets/task_card.dart';
import 'package:my_todo_app/utils/notifications.dart';
import 'package:my_todo_app/utils/snackbar_util.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoaded) {
            return HomePageView(todoLists: state.todoLists);
          } else if (state is ScheduleLoading) {
            return HomePageViewSkeleton();
          } else if (state is ScheduleError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            });
            return Center(child: Text('Failed to load data'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class HomePageViewSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Дела на сегодня',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(child: TaskListShimmerLoader()),
        ],
      ),
    );
  }
}

class HomePageView extends StatelessWidget {
  final List<ToDoList> todoLists;

  HomePageView({required this.todoLists});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        List<Task> todayTasks = [];
        if (state is ScheduleLoaded) {
          DateTime today = DateTime.now();
          for (var todoList in state.todoLists) {
            if (todoList.date != null && isSameDay(todoList.date!, today)) {
              todayTasks.addAll(todoList.tasks);
            }
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<ScheduleBloc>().add(LoadScheduleRequested());
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Дела на сегодня',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: todayTasks.isEmpty
                      ? Center(child: Text('Сегодня дел нет'))
                      : ListView.builder(
                          itemCount: todayTasks.length,
                          itemBuilder: (context, index) {
                            final task = todayTasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () {},
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
