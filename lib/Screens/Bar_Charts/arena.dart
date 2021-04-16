import 'package:auto_size_text/auto_size_text.dart';
import 'package:chart_builder/Screens/Bar_Charts/horizontal_bar_chart.dart';
import 'package:chart_builder/Screens/Bar_Charts/simpleBar.dart';
import 'package:chart_builder/Screens/Bar_Charts/types_of_bar_chart.dart';
import 'package:chart_builder/Service/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:chart_builder/Service/data.dart' as data;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Arena extends StatefulWidget {
  @override
  _ArenaState createState() => _ArenaState();
}

class _ArenaState extends State<Arena> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  Future<List> simple;
  Future<List> horizontal;
  double height = 2000;
  bool spinner = false;

  @override
  void initState() {
    if (data.simple != null) {
      setState(() {
        //height = data.simple.toDouble();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bar Charts'),
          elevation: 0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: spinner,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(indicatorColor: Color(0xff262545), tabs: [
                      Tab(
                        child: Text(
                          'Simple',
                          style: TextStyle(
                            color: Color(0xff262545),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Horizontal',
                          style: TextStyle(
                            color: Color(0xff262545),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    margin: EdgeInsets.only(top: 20),

                    height: height,
                    //flex: 1,
                    child: TabBarView(children: [
                      Container(
                        child: FutureBuilder(
                            future: simple =
                                databaseHelper.getSimpleBarChartList(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              print('h ' + height.toString());
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();

                              return Container(
                                height: snapshot.data.length * 50.toDouble(),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        //padding: EdgeInsets.all(15),
                                        child: InkWell(
                                          onTap: () async {},
                                          child: Slidable(
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.5,
                                            actions: [
                                              IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: AlertDialog(
                                                            title:
                                                                Text("Warning"),
                                                            content: Text(
                                                                "Your Data will be deleted. Continue?"),
                                                            actions: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text("No"),
                                                              ),
                                                              RaisedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    spinner =
                                                                        true;
                                                                  });
                                                                  dynamic r = await databaseHelper.deleteTable(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .name,
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                      'Simple');
                                                                  setState(() {
                                                                    spinner =
                                                                        false;
                                                                  });
                                                                },
                                                                child:
                                                                    Text("Yes"),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            ],
                                            child: ListTile(
                                                //contentPadding:
                                                //EdgeInsets.all(10),
                                                onTap: () async {
                                                  dynamic result =
                                                      await databaseHelper
                                                          .getSimpleBarChart(
                                                              snapshot
                                                                  .data[index]
                                                                  .name);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SimpleBarChart(
                                                                chart: snapshot
                                                                    .data[index]
                                                                    .name,
                                                                xAxis: snapshot
                                                                    .data[index]
                                                                    .x,
                                                                yAxis: snapshot
                                                                    .data[index]
                                                                    .y,
                                                                update: true,
                                                                barSimple: data
                                                                    .barSimple,
                                                                id: snapshot
                                                                    .data[index]
                                                                    .id,
                                                              ))).then((value) {
                                                    setState(() {
                                                      simple = databaseHelper
                                                          .getSimpleBarChartList();
                                                      height = data.simple
                                                          .toDouble();
                                                    });
                                                  });
                                                },
                                                tileColor: Colors.white,
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      'Chart Name: ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff262545),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      '${snapshot.data[index].name}',
                                                      //maxLines: 3,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff262545),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }),
                      ),
                      Container(
                        child: FutureBuilder(
                            future: horizontal =
                                databaseHelper.getHorizontalBarChartList(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              return Container(
                                height: snapshot.data.length * 50.toDouble(),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        //padding: EdgeInsets.all(15),
                                        child: InkWell(
                                          onTap: () async {},
                                          child: Slidable(
                                            actionPane:
                                                SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.5,
                                            actions: [
                                              IconSlideAction(
                                                caption: 'Delete',
                                                color: Colors.red,
                                                icon: Icons.delete,
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: AlertDialog(
                                                            title:
                                                                Text("Warning"),
                                                            content: Text(
                                                                "Your Data will be deleted. Continue?"),
                                                            actions: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text("No"),
                                                              ),
                                                              RaisedButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
                                                                    spinner =
                                                                        true;
                                                                  });
                                                                  dynamic r = await databaseHelper.deleteTable(
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .name,
                                                                      snapshot
                                                                          .data[
                                                                              index]
                                                                          .id,
                                                                      'Horizontal');
                                                                  setState(() {
                                                                    spinner =
                                                                        false;
                                                                  });
                                                                },
                                                                child:
                                                                    Text("Yes"),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                            ],
                                            child: ListTile(
                                                //contentPadding:
                                                //EdgeInsets.all(10),
                                                onTap: () async {
                                                  dynamic result =
                                                      await databaseHelper
                                                          .getHorizontalBarChart(
                                                              snapshot
                                                                  .data[index]
                                                                  .name);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              HorizontalBarChart(
                                                                chart: snapshot
                                                                    .data[index]
                                                                    .name,
                                                                xAxis: snapshot
                                                                    .data[index]
                                                                    .y,
                                                                yAxis: snapshot
                                                                    .data[index]
                                                                    .x,
                                                                update: true,
                                                                data: data
                                                                    .barHorizontal,
                                                                id: snapshot
                                                                    .data[index]
                                                                    .id,
                                                              ))).then((value) {
                                                    setState(() {
                                                      horizontal = databaseHelper
                                                          .getHorizontalBarChartList();
                                                    });
                                                  });
                                                },
                                                tileColor: Colors.white,
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      'Chart Name: ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff262545),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      '${snapshot.data[index].name}',
                                                      //maxLines: 3,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff262545),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            }),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BarTypes()))
                .then((value) {})
                .then((value) {})
                .then((value) {
              setState(() {
                simple = databaseHelper.getSimpleBarChartList();
                //horizontal = databaseHelper.getHorizontalBarChartList();

                height = data.simple.toDouble();
              });
            });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xff262545),
        ),
      ),
    );
  }

  _refresh() {
    simple = databaseHelper.getSimpleBarChartList();
    horizontal = databaseHelper.getHorizontalBarChartList();
  }
}
