import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_calander/views/alarm.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({Key? key}) : super(key: key);

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  final TextEditingController timeinput = TextEditingController();

  final int _oneShotAtTaskId = 1;

  static void _oneShotAtTaskCallback() {
    print("One Shot At Task Running");
  }

  // alarm
  void _scheduleOneShotAlarm(bool isTimed) async {
    if (isTimed) {
      DateTime chosenDate = await DateTime.now(); //_selectedDate!;
      await AndroidAlarmManager.periodic(
          Duration(seconds: 60), _oneShotAtTaskId, _oneShotAtTaskCallback);
    } else {}
  }

  @override
  void initState() {
    timeinput.text = "";
    // TODO: implement initState
    super.initState();
    _selectedDate = _focusedDay;
    loadPreviousEvents();
  }

  loadPreviousEvents() {
    mySelectedEvents = {
      "2023-04-13": [
        {"eventDescp": "11", "eventTitle": "111", "eventTime": "22:32"},
        {"eventDescp": "22", "eventTitle": "22", "eventTime": "10:55"},
      ],
      "2023-04-30": [
        {"eventDescp": "22", "eventTitle": "22", "eventTime": "12:12"}
      ],
      "2023-04-20": [
        {"eventTitle": "ss", "eventDescp": "ss", "eventTime": "01:42"}
      ]
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: timeinput, //editing controller of this TextField
              decoration: const InputDecoration(
                  icon: Icon(Icons.timer), //icon of text field
                  labelText: "Enter Time" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  initialTime: TimeOfDay.now(),
                  context: context,
                );

                if (pickedTime != null) {
                  print(pickedTime.format(context)); //output 10:51 PM
                  DateTime parsedTime = DateFormat.jm()
                      .parse(pickedTime.format(context).toString());
                  //converting to DateTime so that we can further format on different pattern.
                  print(parsedTime); //output 1970-01-01 22:53:00.000
                  String formattedTime = DateFormat('HH:mm').format(parsedTime);
                  print(formattedTime); //output 14:59:00
                  //DateFormat() is from intl package, you can format the time on any pattern you need.

                  setState(() {
                    timeinput.text =
                        formattedTime; //set the value of text field.
                  });
                } else {
                  print("Time is not selected");
                }
              },
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
              child: const Text('Add Event'),
              onPressed: () {
                if (titleController.text.isEmpty &&
                    descpController.text.isEmpty &&
                    timeinput.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Required title and description'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  //Navigator.pop(context);
                  return;
                } else {
                  // print(titleController.text);
                  // print(descpController.text);
                  // print(timeinput.text);
                  _scheduleOneShotAlarm(true);
                }
                setState(() {
                  if (mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(_selectedDate!)] !=
                      null) {
                    mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDate!)]
                        ?.add({
                      "eventTitle": titleController.text,
                      "eventDescp": descpController.text,
                      "eventIime": timeinput.text,
                    });
                  } else {
                    mySelectedEvents[
                        DateFormat('yyyy-MM-dd').format(_selectedDate!)] = [
                      {
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                        "eventTime": timeinput.text,
                      }
                    ];
                  }
                });

                print(
                    "New Event for backend developer ${json.encode(mySelectedEvents)}");
                titleController.clear();
                descpController.clear();
                timeinput.clear();
                Navigator.pop(context);
                return;
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Event Calendar Example'),
        ),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
              eventLoader: _listOfDayEvents,
            ),
            ..._listOfDayEvents(_selectedDate!).map(
              (myEvents) => Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.done,
                    color: Colors.teal,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Event Title:   ${myEvents['eventTitle']}'),
                  ),
                  subtitle: Text('Description:   ${myEvents['eventDescp']}'),
                  trailing: Text('Time: ${myEvents['eventTime']}'),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEventDialog(),
          label: const Text('Add Event'),
        ),
      ),
    );
  }
}
