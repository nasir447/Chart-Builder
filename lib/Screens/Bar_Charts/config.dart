import 'package:chart_builder/Screens/Bar_Charts/horizontal_bar_chart.dart';
import 'package:chart_builder/Screens/Bar_Charts/simpleBar.dart';
import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  String title;
  Config({@required this.title});
  @override
  _ConfigState createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  TextEditingController x_axis = TextEditingController();
  TextEditingController y_axis = TextEditingController();
  TextEditingController name = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name of Chart',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                style: TextStyle(color: Colors.black),
                controller: name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.title == 'Simple Bar Chart'
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Label of Y-Axis',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: y_axis,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Label of Y-Axis',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Label of X-Axis',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: x_axis,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Label of X-Axis',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Label of X-Axis',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: x_axis,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Label of X-Axis',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Label of Y-Axis',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: y_axis,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Label of Y-Axis',
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    if (widget.title == 'Simple Bar Chart' ||
                        widget.title == 'Horizontal Bar Chart') {
                      if (name.text.isEmpty ||
                          y_axis.text.isEmpty ||
                          x_axis.text.isEmpty) {
                        if (name.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Enter the Name of Chart'),
                            backgroundColor: Colors.black,
                          ));
                        } else if (y_axis.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Enter the label for Y-Axis'),
                            backgroundColor: Colors.black,
                          ));
                        } else if (x_axis.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Enter the label for Y-Axis'),
                            backgroundColor: Colors.black,
                          ));
                        }
                      } else {
                        if (widget.title == 'Horizontal Bar Chart') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HorizontalBarChart(
                                        chart: name.text,
                                        xAxis: x_axis.text,
                                        yAxis: y_axis.text,
                                        update: false,
                                      )));
                        } else if (widget.title == 'Simple Bar Chart') {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SimpleBarChart(
                                        chart: name.text,
                                        xAxis: y_axis.text,
                                        yAxis: x_axis.text,
                                        update: false,
                                      )));
                        }
                      }
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'Create Chart',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
