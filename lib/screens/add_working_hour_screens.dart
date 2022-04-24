import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hours_tracker/helper/help_file.dart';
import 'package:hours_tracker/models/daily_work_interval.dart';
import 'package:provider/provider.dart';

import '../models/hour_data.dart';

class AddWorkingHours extends StatefulWidget {
  final DailyWorkInterval? dailyWorkInterval;

  const AddWorkingHours({Key? key, this.dailyWorkInterval}) : super(key: key);

  @override
  State<AddWorkingHours> createState() => _AddWorkingHoursState();
}

class _AddWorkingHoursState extends State<AddWorkingHours> {
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();


  @override
  void initState() {
    super.initState();
    startTime = widget.dailyWorkInterval?.startTime ?? startTime;
    endTime = widget.dailyWorkInterval?.endTime ?? endTime;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        color: const Color(0xff757575),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _addDailyWorkingTimeInterval(context);
              },
              icon: const Icon(Icons.send),
              label: const Text(' Ajouter'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      ' Ajouter les heures de début et de fin',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.0, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _selectStartTime(context);
                          },
                          child: Text(
                            "Début: " + timeOfDayToString(startTime),
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: TextButton(
                        onPressed: () {
                          _selectEndTime(context);
                        },
                        child: Text(
                          "Fin: " + timeOfDayToString(endTime),
                          style: const TextStyle(
                            fontSize: 20.0,

                            //  color: Colors.blue
                          ),
                        ),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _addDailyWorkingTimeInterval(BuildContext context) async {
    if (timeOfDayToDouble(startTime) < timeOfDayToDouble(endTime)) {
      DailyWorkInterval dailyWorkInterval =
          DailyWorkInterval(startTime: startTime, endTime: endTime);
      var provider =  Provider.of<WorkingHoursData>(context, listen: false);
      if(widget.dailyWorkInterval == null){
        provider.addDailyWorkingInterval(dailyWorkInterval);
      } else{
        dailyWorkInterval.id = widget.dailyWorkInterval?.id;
        provider.updateWorkingInterval(dailyWorkInterval);
      }
     /* Provider.of<WorkingHoursData>(context, listen: false)
          .addDailyWorkingInterval(dailyWorkInterval);*/

      Navigator.of(context).pop();
    } else {
      showAlertDialog(context);
    }
  }

  _selectStartTime(BuildContext context) async {
   // startTime = widget.dailyWorkInterval?.startTime ?? startTime;


    final TimeOfDay? start = await showTimePicker(
        context: context,
        initialTime: startTime,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });

    if (start != null && start != startTime) {
      setState(() {
        startTime = start;
      });
    }
  }

  _selectEndTime(BuildContext context) async {
  //  endTime = widget.dailyWorkInterval?.endTime ?? endTime;

    final TimeOfDay? end = await showTimePicker(
        context: context,
        initialTime: endTime,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });

    if (end != null && end != endTime) {
      setState(() {
        endTime = end;
      });
    }
  }



}
