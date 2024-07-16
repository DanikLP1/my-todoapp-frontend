import 'package:flutter/material.dart';
import 'package:my_todo_app/models/task.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  CalendarPage({required this.events});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar<Event>(
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
              eventLoader: _getEventsForDay,
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
                  color: theme.textTheme.bodySmall?.color,
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
              calendarBuilders: CalendarBuilders<Event>(
                dowBuilder: (context, day) {
                  switch (day.weekday) {
                    case 1:
                      return Center(
                          child: Text('Пн', style: TextStyle(color: theme.textTheme.bodySmall?.color)));
                    case 2:
                      return Center(
                          child: Text('Вт', style: TextStyle(color: theme.textTheme.bodySmall?.color)));
                    case 3:
                      return Center(
                          child: Text('Ср', style: TextStyle(color: theme.textTheme.bodySmall?.color)));
                    case 4:
                      return Center(
                          child: Text('Чт', style: TextStyle(color: theme.textTheme.bodySmall?.color)));
                    case 5:
                      return Center(
                          child: Text('Пт', style: TextStyle(color: theme.textTheme.bodySmall?.color)));
                    case 6:
                      return Center(
                          child: Text('Сб', style: TextStyle(color: theme.colorScheme.secondary)));
                    case 7:
                      return Center(
                          child: Text('Вс', style: TextStyle(color: theme.colorScheme.secondary)));
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
              onPressed: _switchCalendarFormat,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                _getButtonText(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _selectedDay == null
                  ? Center(child: Text('Выберите дату'))
                  : ListView(
                      children: _getEventsForDay(_selectedDay!).map((event) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {},
                            child: ListTile(
                              title: Text(event.title),
                              subtitle: Text(event.description),
                              leading: Icon(Icons.event, color: theme.colorScheme.primary),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
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
