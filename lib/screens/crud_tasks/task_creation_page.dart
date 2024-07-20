import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_app/blocs/schedule/schedule_bloc.dart';
import 'package:my_todo_app/blocs/schedule/schedule_event.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:my_todo_app/utils/notifications.dart';

class TaskCreationPage extends StatefulWidget {
  final DateTime? selectedDate;

  TaskCreationPage({this.selectedDate});

  @override
  _TaskCreationPageState createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  late TimeOfDay _selectedTime;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('d MMMM y', 'ru_RU');
    return dateFormat.format(date);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final padding = width * 0.05;
    final spacing = height * 0.02;
    final textSize = width * 0.04;
    final fieldHeight = height * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: Text('Создание задачи'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _createTask();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.selectedDate != null)
                Text(
                  'Выбранная дата: ${_formatDate(widget.selectedDate!)}',
                  style: TextStyle(
                    fontSize: textSize * 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(height: spacing),
              Text(
                'Выберите время:',
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing / 2),
              ListTile(
                title: Text(
                  _formatTime(_selectedTime),
                  style: TextStyle(fontSize: textSize * 1.2),
                ),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: true,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null && time != _selectedTime) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
              ),
              SizedBox(height: spacing),
              Text(
                'Название задачи:',
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing / 2),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Введите название задачи',
                ),
                maxLines: 1,
                style: TextStyle(fontSize: textSize),
              ),
              SizedBox(height: spacing),
              Text(
                'Описание задачи:',
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing / 2),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: 'Введите описание задачи',
                ),
                maxLines: 3,
                style: TextStyle(fontSize: textSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTask() {
    if (widget.selectedDate != null && _titleController.text.isNotEmpty) {
      final DateTime selectedDateTime = DateTime(
        widget.selectedDate!.year,
        widget.selectedDate!.month,
        widget.selectedDate!.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      log(_selectedTime.toString());

      final task = Task(
        id: 0, // Замените на реальный ID
        listId: 0, // Замените на реальный ID списка
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: selectedDateTime,
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<ScheduleBloc>().add(AddEventRequested(task));

      NotificationService.scheduleNotification(task.title, task.description, selectedDateTime);

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, введите название задачи')),
      );
    }
  }
}
