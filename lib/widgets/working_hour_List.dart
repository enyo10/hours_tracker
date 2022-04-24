import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hours_tracker/models/daily_work_interval.dart';
import 'package:hours_tracker/models/hour_data.dart';
import 'package:hours_tracker/widgets/working_hour_tile.dart';
import 'package:provider/provider.dart';

class WorkingHourList extends StatelessWidget {
  const WorkingHourList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkingHoursData>(builder: (context, hoursData, child) {
      return FutureBuilder<List<DailyWorkInterval>>(
        future: hoursData.workingIntervals(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final interval = snapshot.data![index];
                  return WorkingHourTile(
                      workInterval: interval, numberOfInterval: index);
                });
          } else {
            return const Center(child: Text(" Il n'y pas de données"));
          }
        },
      );
    });
  }
}
