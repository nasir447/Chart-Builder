import 'package:chart_builder/Screens/Bar_Charts/config.dart';
import 'package:flutter/material.dart';

class BarTypes extends StatefulWidget {
  @override
  _BarTypesState createState() => _BarTypesState();
}

class _BarTypesState extends State<BarTypes> {
  Widget tile(Color color, String data, double width) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Container(
        padding: EdgeInsets.all(20),
        width: width,
        child: Center(
          child: Text(
            data,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        decoration: BoxDecoration(
            color: color,
            //image:
            //  DecorationImage(image: AssetImage(file), fit: BoxFit.fill)),
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Bar Chart Types"),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Config(title: 'Simple Bar Chart')));
                },
                child: tile(Colors.blue, 'Simple', width * 0.9)),
            tile(Colors.brown, 'Sacked', width * 0.9),
            tile(Colors.green, 'Grouped', width * 0.9),
            InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Config(title: 'Horizontal Bar Chart')));
                },
                child: tile(Colors.indigo, 'Horizontal', width * 0.9)),
            tile(Colors.red, 'Horizontal Stacked', width * 0.9),
            tile(Colors.blueGrey, 'Horizontal Grouped', width * 0.9),
          ],
        ),
      ),
    );
  }
}
