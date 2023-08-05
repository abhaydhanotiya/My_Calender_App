import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _oneShotAtTaskId = 1;

  static void _oneShotAtTaskCallback() {
    print("One Shot At Task Running");
  }

  void _scheduleOneShotAlarm(bool isTimed) async {
    if (isTimed) {
      DateTime chosenDate = await _chooseDate();
      await AndroidAlarmManager.oneShotAt(
          chosenDate, _oneShotAtTaskId, _oneShotAtTaskCallback);
    } else {}
  }

  Future<DateTime> _chooseDate() async {
    DateTime? chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022, 7),
        lastDate: DateTime(2101));

    if (chosenDate != null) {
      return chosenDate;
    }

    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            "appName",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          SizedBox(
            width: 120,
            height: 50,
            child: ElevatedButton.icon(
                onPressed: () {
                  _scheduleOneShotAlarm(true);
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text("oneShotAtAlarm")),
          ),
        ],
      )),
    );
  }
}
