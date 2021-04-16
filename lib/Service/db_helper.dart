import 'package:chart_builder/Models/ordinate_for_simple_bar_chart.dart';
import 'package:chart_builder/Models/simple_bar_chart.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:chart_builder/Service/data.dart' as data;

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String simpleBarTable = 'barSimple';
  String horizontalBarTable = 'barHorizontal';
  String stackedBarTable = 'barStacked';
  String groupBarTable = 'barGroup';
  String horizontalSBarTable = 'barHorizontalS';
  String horizontalGBarTable = 'barHorizontalG';

  String colId = 'id';
  String colName = 'name';
  String colItem = 'items';
  String colX = 'x';
  String colY = 'y';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'ChartBuilder.db';
    var chartDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return chartDatabase;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }

  Future<List> getSimpleBarChartList() async {
    Database db = await this.database;

    var result = await db.query(simpleBarTable);
    List<SimpleBarChartList> simple = List();
    for (var r in result) {
      simple.add(SimpleBarChartList.fromMap(r));
    }
    print(simple.length);
    data.simple = simple.length * 120;
    print(data.simple);
    return simple;
  }

  Future<List> getHorizontalBarChartList() async {
    Database db = await this.database;

    var result = await db.query(horizontalBarTable);
    List<SimpleBarChartList> horizontal = List();
    for (var r in result) {
      horizontal.add(SimpleBarChartList.fromMap(r));
    }
    print(horizontal.length);
    data.horizontal = horizontal.length * 120;
    return horizontal;
  }

  Future getSimpleBarChart(String table) async {
    Database db = await this.database;

    var result = await db.query(table);
    List<BarChartClass> barSimple = List();
    for (var r in result) {
      barSimple.add(BarChartClass.fromMap(r));
    }
    data.barSimple = barSimple;
    return null;
  }

  Future getHorizontalBarChart(String table) async {
    Database db = await this.database;

    var result = await db.query(table);
    List<BarChartClass> barHorizontal = List();
    for (var r in result) {
      barHorizontal.add(BarChartClass.fromMap(r));
    }
    data.barHorizontal = barHorizontal;
    return null;
  }

  Future<int> insertSimpleBarOrHorizontalChart(
      SimpleBarChartList simpleBarChartList,
      List<BarChartClass> barChart,
      bool type) async {
    Database db = await this.database;
    print(type);
    if (type == true) {
      var result = await db.insert(simpleBarTable, simpleBarChartList.toMap());
      await db.execute('''
            CREATE TABLE IF NOT EXISTS ${simpleBarChartList.name}(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colX TEXT,
                $colY INTEGER
              )
        ''');
      List<Map<String, dynamic>> map = List();
      for (var bar in barChart) {
        map.add(bar.toMap());
      }

      for (var m in map) {
        var i = await db.insert(simpleBarChartList.name, m);
        print(i);
      }
      return result;
    } else {
      var result =
          await db.insert(horizontalBarTable, simpleBarChartList.toMap());
      await db.execute('''
            CREATE TABLE IF NOT EXISTS ${simpleBarChartList.name}(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colX TEXT,
                $colY INTEGER
              )
        ''');
      List<Map<String, dynamic>> map = List();
      for (var bar in barChart) {
        map.add(bar.toMap());
      }

      for (var m in map) {
        var i = await db.insert(simpleBarChartList.name, m);
        print(i);
      }
      return result;
    }
  }

  Future deleteTable(String name, int id, String type) async {
    Database db = await this.database;

    var result = db.rawDelete('''
        DROP TABLE IF EXISTS $name
    ''');
    if (type == 'Simple') {
      var result1 = db.rawDelete('''
        DELETE FROM $simpleBarTable WHERE id=$id      
    ''');
    } else if (type == 'Horizontal') {
      var result1 = db.rawDelete('''
        DELETE FROM $horizontalBarTable WHERE id=$id      
    ''');
    }
    return result;
  }

  /*Future<int> deleteTask(int id) async {
    Database db = await this.database;

    var result =
        await db.rawDelete('DELETE FROM $taskTable WHERE $colId = $id');
    return result;
  }*/

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
            CREATE TABLE $simpleBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
    await db.execute('''
            CREATE TABLE $horizontalBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
    await db.execute('''
            CREATE TABLE $stackedBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colItem TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
    await db.execute('''
            CREATE TABLE $groupBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colItem TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
    await db.execute('''
            CREATE TABLE $horizontalSBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colItem TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
    await db.execute('''
            CREATE TABLE $horizontalGBarTable(
                $colId INTEGER PRIMARY KEY AUTOINCREMENT,
                $colName TEXT,
                $colItem TEXT,
                $colX TEXT,
                $colY TEXT
              )
        ''');
  }

  /*Future<int> getCount(int id) async {
    Database db = await this.database;

    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $taskTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }*/

  /*Future<List<Source>> getSourceList() async {
    var taskMapList = await getLinks();
    int count = taskMapList.length;

    List<Source> task = List<Source>();
    for (int i = 0; i < count; ++i) {
      print(i);
      print(count);
      task.add(Source.fromMap(taskMapList[i]));
    }
    return task;
  }*/
}
