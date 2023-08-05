import 'package:flutter/material.dart';
import 'package:google_calander/views/alarm.dart';
import 'package:google_calander/views/event_calendar.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {
  runApp(const MyApp());
  await AndroidAlarmManager.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SafeArea(child: EventCalendarScreen()),
    );
  }
}
