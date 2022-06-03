import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hours_tracker/helper/help_file.dart';
import 'package:hours_tracker/models/daily_work_interval.dart';
import 'package:hours_tracker/models/hour_data.dart';
import 'package:provider/provider.dart';

import '../screens/add_working_hour_screens.dart';

class WorkingHourTile extends StatelessWidget {
  final DailyWorkInterval workInterval;
  final int numberOfInterval;
  const WorkingHourTile(
      {Key? key, required this.workInterval, required this.numberOfInterval})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 0.0, top: 8.0, right: 0.0),
      leading: CircleAvatar(
        backgroundColor: Colors.lightGreenAccent,
        child: Text("${numberOfInterval + 1}",),
      ),
      title: GestureDetector(
        onDoubleTap: () {
          if (kDebugMode) {
            print("$workInterval");
          }
          showModalBottomSheet(
            context: context,
            builder: (context) => AddWorkingHours(
              dailyWorkInterval: workInterval,
            ),
          );
        },
        child: Text(
          workingIntervalFormatter(workInterval),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          Provider.of<WorkingHoursData>(context, listen: false)
              .removeDailyWorkingInterval(workInterval);
        },
      ),
    );
  }
}
