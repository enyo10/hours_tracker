import 'package:flutter/material.dart';
import 'package:hours_tracker/helper/help_file.dart';

class DailyWorkInterval {
  final TimeOfDay startTime, endTime;
  int? id;

  DailyWorkInterval({this.id, required this.startTime, required this.endTime});

  int get workDuration =>
      (endTime.hour * 60 + endTime.minute) -
      (startTime.hour * 60 + startTime.minute);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': timeOfDayToString(startTime),
      'end': timeOfDayToString(endTime),
    };
  }

  DailyWorkInterval.fromMap(Map map)
      : id = map['id'],
        startTime = stringToTimeOfDay(map['start']),
        endTime = stringToTimeOfDay(map['end']);

  @override
  String toString() {
    return 'DailyWorkInterval{' 'id: $id, '
        ' startTime: ${timeOfDayToString(startTime)}, '
        'endTime: ${timeOfDayToString(endTime)}}';
  }
}
