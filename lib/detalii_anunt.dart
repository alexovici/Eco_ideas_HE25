// filepath: /c:/Users/alexg/AppData/Local/Temp/FirstApp/flutter_application_4/lib/detalii_anunt.dart
import 'package:flutter/material.dart';

class DetaliiAnunt extends StatelessWidget {
  final Map<String, dynamic> post;

  const DetaliiAnunt({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text('Description: ${post['description']}'),
            Text('Pay: ${post['pay']}'),
            Text('Duration: ${post['duration']}'),
            Text('Location: ${post['location']}'),
            Text('Pay Period: ${post['payPeriod']}'),
            Text('Work Period: ${post['workPeriod']}'),
          ],
        ),
      ),
    );
  }
}