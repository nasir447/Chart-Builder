import 'package:chart_builder/Screens/Bar_Charts/arena.dart';
import 'package:chart_builder/Screens/Bar_Charts/types_of_bar_chart.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget tile(
      String file, Color color, String data, double height, double width) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Container(
        padding: EdgeInsets.all(20),
        width: width,
        child: Column(
          children: [
            Text(
              data,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
              file,
              width: width,
              height: height * 0.9,
            ),
          ],
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Chart Builder"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: height * 0.025,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Arena()));
                },
                child: tile('images/graph-bar.png', Colors.indigo, "Bar Chart",
                    height * 0.3, width * 0.9),
              ),
              tile('images/pie-chart.png', Colors.blue[900], "Pie Chart",
                  height * 0.3, width * 0.9),
              tile('images/statistics.png', Colors.green[900], "Line Chart",
                  height * 0.3, width * 0.9),
            ],
          ),
        ),
      ),
    );
  }
}
