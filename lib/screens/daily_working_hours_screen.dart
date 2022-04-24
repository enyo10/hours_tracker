import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hours_tracker/screens/add_working_hour_screens.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../models/daily_work_interval.dart';
import '../models/hour_data.dart';
import '../widgets/working_hour_List.dart';

class DailWorkingHoursScreens extends StatefulWidget {
  const DailWorkingHoursScreens({Key? key}) : super(key: key);

  @override
  State<DailWorkingHoursScreens> createState() => _DailWorkingHoursScreensState();
}

class _DailWorkingHoursScreensState extends State<DailWorkingHoursScreens> {
  final _myController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(" Suivi du temps de travail"),
        actions:<Widget> [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _showSettingsDialog(context);
                },
                child: const Icon(
                    Icons.settings
                ),
              )
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(onPressed: () {
          _showResultDialog(context);
        },
          style:  ElevatedButton.styleFrom(
          //  primary: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle:
            const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          child:const Text( " Calculer"),
        autofocus: true,),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const AddWorkingHours(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const WorkingHourList(
              ),
            ),
          )
        ],
      ),


    );
  }

  double _calculateAmount(BuildContext context){
    var totalDurationMin=0;

    UnmodifiableListView<DailyWorkInterval>list =
        Provider.of<WorkingHoursData>(context, listen: false).workingHours ;
    for (var element in list) {

      totalDurationMin += element.workDuration;
    }
    return totalDurationMin /60;

  }

  double roundDouble(double val, int places){
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  _saveTax(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('tax', value);
  }
  _getTax() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble('tax') ?? 6.0;
    return intValue;
  }

  _deleteAllWorkingHour(BuildContext context)async{
    var provider =  Provider.of<WorkingHoursData>(context, listen: false);
   await provider.removeAllDailyWorkingHour();

  }

  Future<void> _showResultDialog(BuildContext context) async {

   double totalHour = _calculateAmount(context);

   var roundedTotalHour = roundDouble(totalHour, 5);

   var tax = await _getTax();
   if (kDebugMode) {
     print("---- tax $tax");
   }

   double amount = totalHour * tax;

   print(" ---- Amount $amount");

   var roundedAmount = roundDouble(amount, 2);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text(' Resultat de calcul'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Heures: $roundedTotalHour "),
                ),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Text('Montant: $roundedAmount CHF'),
                 ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSettingsDialog(BuildContext context) async {
    double tax = await _getTax();
    _myController.text = " $tax";


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text(' Ajouter le taux horaire'),
          content: SingleChildScrollView(
            child: Column(
              children:  <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                    controller: _myController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Taux actuel ',
                    ),
                  ),
                ),
            
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                double tax = double.parse(_myController.text);
                _saveTax(tax);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
