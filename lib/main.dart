import 'package:chart_builder/Screens/home.dart';
import 'package:chart_builder/Screens/Bar_Charts/simpleBar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: ThemeData(
          primaryColor: const Color(0xff262545),
          primaryColorDark: const Color(0xff201f39),
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.lightBlue[50]),
      home: Home(),
    );
  }
}
