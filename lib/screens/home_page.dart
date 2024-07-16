import 'package:flutter/material.dart';
import '../models/task.dart';

class HomePage extends StatelessWidget {
  final List<Event> events;

  HomePage({required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Дела на сегодня',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: events.isEmpty
                  ? Center(child: Text('Сегодня дел нет'))
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(event.title),
                            subtitle: Text(event.description),
                            leading: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
