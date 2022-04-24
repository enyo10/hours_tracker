import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HourSelector extends StatefulWidget {
  const HourSelector({Key? key}) : super(key: key);

  @override
  _HourSelectorState createState()
  {
    return _HourSelectorState();
  }
}

class _HourSelectorState extends State<HourSelector> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Hour tracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: const Text("Choose Time"),
            ),
            Text("${selectedTime.hour}:${selectedTime.minute}"),
          ],
        ),
      ),
    );
  }
  _selectTime(BuildContext context) async {

    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });


    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}