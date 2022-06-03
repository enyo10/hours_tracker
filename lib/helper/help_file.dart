import 'package:flutter/material.dart';
import 'package:hours_tracker/models/daily_work_interval.dart';

String timeOfDayToString(TimeOfDay timeOfDay) {
  return "${timeOfDay.hour}h ${timeOfDay.minute}";
}

TimeOfDay stringToTimeOfDay(String stringTimeOfDay) {
  List<String> parts = stringTimeOfDay.toString().split('h');

  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String workingIntervalFormatter(DailyWorkInterval dailyWorkInterval) {
  var startTime = dailyWorkInterval.startTime;
  var endTime = dailyWorkInterval.endTime;
  return timeOfDayToString(startTime) + " - " + timeOfDayToString(endTime);
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      " Erreur",
      style: TextStyle(fontSize: 20, color: Colors.red),
    ),
    content:
        const Text(" Heure du début doit être inférieur à l'heure de fin.."),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

double timeOfDayToDouble(TimeOfDay myTime) =>
    myTime.hour + myTime.minute / 60.0;
int timeOfDayToInt(TimeOfDay timeOfDay) =>
    timeOfDay.hour * 60 + timeOfDay.minute;

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);

  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}

// double calculateHour( int hour, int minutes )=> (hour + minutes / 60.0)*3;
