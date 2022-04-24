import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hours_tracker/models/daily_work_interval.dart';
import 'package:hours_tracker/screens/add_working_hour_screens.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/help_file.dart';

class WorkingHoursData with ChangeNotifier {
  List<DailyWorkInterval> _workingHours = [];
  final _tax = 6.0;
  static const String _tableName = "working_interval";

  Future<Database>? _database;

  WorkingHoursData() {
    _init();
  }

  Future<void> _init() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    _database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'hours_tracker_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, start TEXT, end TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    notifyListeners();
  }

  UnmodifiableListView<DailyWorkInterval> get workingHours {
    return UnmodifiableListView(_workingHours);
  }

  int get workingIntervalCount {
    return _workingHours.length;
  }

  void addDailyWorkingInterval(DailyWorkInterval dailyWorkInterval) {
    insertWorkingInterval(dailyWorkInterval);
    loadData();
  }

  Future<void> loadData() async {
    dynamic list = await workingIntervals();
    _workingHours.clear();
    for (DailyWorkInterval interval in list) {
      _workingHours.add(interval);
    }
    notifyListeners();
  }

  void removeDailyWorkingInterval(DailyWorkInterval dailyWorkInterval) {
    int? id = dailyWorkInterval.id;
    if (kDebugMode) {
      print(" id : $id");
    }
    if (id != null) {
      deleteWorkingInterval(id);
    }
    loadData();

    /*_workingHours.remove(dailyWorkInterval);
    notifyListeners();*/
  }

  double get tax => _tax;

// Define a function that inserts DailyWorkingInterval into the database
  Future<void> insertWorkingInterval(DailyWorkInterval workInterval) async {
    // Get a reference to the database.
    final db = await _database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.

    await db?.insert(
      _tableName,
      workInterval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// A method that retrieves all the Working intervals from the hour table.
  Future<List<DailyWorkInterval>> workingIntervals() async {
    // Get a reference to the database.
    final db = await _database;

    // Query the table for all The Daily working interval.
    final List<Map<String, dynamic>>? maps = await db?.query(_tableName);

    // Convert the List<Map<String, dynamic> into a List<WorkingInterval>.
    if (maps != null) {
     return _workingHours = List.generate(maps.length, (i) {
        TimeOfDay startTime = stringToTimeOfDay(maps[i]['start']);
        TimeOfDay endTime = stringToTimeOfDay(maps[i]['end']);
        int id = maps[i]['id'];

        return DailyWorkInterval(
            startTime: startTime, endTime: endTime, id: id);
      });
    } else {
      return List.empty();
    }
  }

  Future<void> updateWorkingInterval(DailyWorkInterval interval) async {
    // Get a reference to the database.
    final db = await _database;

    // Update the given Dog.
    await db?.update(
      _tableName,
      interval.toMap(),
      // Ensure that the Interval has a matching id.
      where: 'id = ?',
      // Pass the Interval's id as a whereArg to prevent SQL injection.
       whereArgs: [interval.id],
    );
    loadData();
  }

  Future<void> deleteWorkingInterval(int id) async {
    // Get a reference to the database.
    final db = await _database;

    // Remove the Working Interval from the database.
    await db?.delete(
      _tableName,
      // Use a `where` clause to delete a specific interval.
      where: 'id = ?',
      // Pass the interval's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Future<void>removeAllDailyWorkingHour() async{
    final db = await _database;

    await db?.execute("delete from "+ _tableName);
    loadData();

  }

}
