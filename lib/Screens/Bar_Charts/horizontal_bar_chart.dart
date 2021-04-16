import 'package:chart_builder/Models/ordinate_for_simple_bar_chart.dart';
import 'package:chart_builder/Models/simple_bar_chart.dart';
import 'package:chart_builder/Service/db_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class HorizontalBarChart extends StatefulWidget {
  String chart;
  String yAxis;
  String xAxis;
  bool update;
  List<BarChartClass> data;
  int id;
  HorizontalBarChart(
      {@required this.chart,
      @required this.xAxis,
      @required this.yAxis,
      @required this.update,
      this.data,
      this.id});
  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
  List<BarChartClass> data = List();
  TextEditingController x_axis = TextEditingController();
  TextEditingController y_axis = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();
  File _image;
  DatabaseHelper databaseHelper = DatabaseHelper();

  Widget _makeChart() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.8,
      child: new charts.BarChart(
        _createSampleData(),
        animate: true,
        vertical: false,
      ),
    );
  }

  _saveScreenShot() async {
    _image = null;
    final directory = (await getApplicationDocumentsDirectory())
        .path; //from path_provide package
    print(directory);
    String fileName = DateTime.now().toIso8601String();
    var path = '$directory/$fileName.jpeg';
    print(path);

    screenshotController
        .capture(pixelRatio: 1.5, path: path)
        .then((File image) async {
      setState(() {
        _image = image;
      });
      final result = await ImageGallerySaver.saveImage(image
          .readAsBytesSync()); // Save image to gallery,  Needs plugin  https://pub.dev/packages/image_gallery_saver
      print(image.path);
      ShareExtend.share(path, 'file', subject: widget.chart);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    if (widget.update == true) {
      setState(() {
        data = widget.data;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Simple Bar Chart'),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '1',
                child: Text(
                  "Share Chart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem(
                value: '2',
                child: Text(
                  "Clear Chart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              PopupMenuItem(
                value: '3',
                child: Text(
                  "Save Chart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == '1') {
                _saveScreenShot();
              } else if (value == '2') {
                setState(() {
                  data = List();
                  _makeChart();
                });
              } else if (value == '3') {
                if (widget.update == false) {
                  dynamic result =
                      await databaseHelper.insertSimpleBarOrHorizontalChart(
                          SimpleBarChartList(
                              widget.chart, widget.xAxis, widget.yAxis),
                          data,
                          false);
                  print(result);
                } else if (widget.update == true) {
                  dynamic r = await databaseHelper.deleteTable(
                      widget.chart, widget.id, 'Horizontal');
                  print(r);
                  dynamic result =
                      await databaseHelper.insertSimpleBarOrHorizontalChart(
                          SimpleBarChartList(
                              widget.chart, widget.xAxis, widget.yAxis),
                          data,
                          false);
                  print(result);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          widget.xAxis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        _makeChart(),
                        Text(
                          widget.yAxis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.chart,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: x_axis,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Y-Axis',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: y_axis,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'X-Axis',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (x_axis.text.isEmpty || y_axis.text.isEmpty) {
                      if (x_axis.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Y-Axis was not given'),
                          backgroundColor: Colors.black,
                        ));
                      } else if (y_axis.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('X-Axis was not given'),
                          backgroundColor: Colors.black,
                        ));
                      }
                    } else {
                      int y = int.tryParse(y_axis.text);
                      if (y == null) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content:
                              Text('X-Axis should only be given in integer'),
                          backgroundColor: Colors.black,
                        ));
                        return;
                      }
                      setState(() {
                        data.add(BarChartClass(x_axis.text, y));
                        y_axis = TextEditingController();
                        x_axis = TextEditingController();
                      });
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
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: data.length * 60.toDouble(),
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Text('Y-Axis: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                    Text(data[index].x_axis,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Text('X-Axis: ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18)),
                                    Text(data[index].y_axis.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    x_axis.text = data[index].x_axis;
                                    y_axis.text = data[index].y_axis.toString();
                                  });
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: AlertDialog(
                                            title: Text("Edit"),
                                            content: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    child: TextFormField(
                                                      controller: x_axis,
                                                      //initialValue: x_axis.text,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      keyboardType:
                                                          TextInputType.name,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'Y-Axis',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    child: TextFormField(
                                                      controller: y_axis,
                                                      //initialValue: y_axis.text,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: 'X-Axis',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                onPressed: () {
                                                  if (x_axis.text.isEmpty ||
                                                      y_axis.text.isEmpty) {
                                                    if (x_axis.text.isEmpty) {
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          'Y-Axis was not given',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ));
                                                    } else if (y_axis
                                                        .text.isEmpty) {
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          'X-Axis was not given',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ));
                                                    }
                                                  } else {
                                                    int y = int.tryParse(
                                                        y_axis.text);
                                                    if (y == null) {
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(
                                                          'X-Axis should only be given in integer',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        backgroundColor:
                                                            Colors.black,
                                                      ));
                                                      return;
                                                    }
                                                    setState(() {
                                                      print(data[index].x_axis);
                                                      data[index].x_axis =
                                                          x_axis.text;
                                                      data[index].y_axis =
                                                          int.parse(
                                                              y_axis.text);
                                                      x_axis =
                                                          TextEditingController();
                                                      y_axis =
                                                          TextEditingController();
                                                    });

                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: Text("Ok"),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    x_axis =
                                                        TextEditingController();
                                                    y_axis =
                                                        TextEditingController();
                                                  });
                                                },
                                                child: Text("Cancel"),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.green,
                                  ),
                                  child: Text('Edit'),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<BarChartClass, String>> _createSampleData() {
    return [
      new charts.Series<BarChartClass, String>(
        id: widget.chart,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (BarChartClass x, _) => x.x_axis,
        measureFn: (BarChartClass y, int x) {
          return y.y_axis;
        },
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
