import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hours_tracker/screens/daily_working_hours_screen.dart';
import 'package:provider/provider.dart';

import 'hour_selector.dart';
import 'models/hour_data.dart';

void main()
{
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkingHoursData(),
      child: const MaterialApp(

        home: DailWorkingHoursScreens(),
      ),
    );
  }
}

