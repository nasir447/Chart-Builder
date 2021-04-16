class BarChartClass {
  String x_axis;
  int y_axis;

  BarChartClass(this.x_axis, this.y_axis);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['x'] = x_axis;
    map['y'] = y_axis;
    return map;
  }

  BarChartClass.fromMap(Map<String, dynamic> map) {
    x_axis = map['x'];
    y_axis = map['y'];
  }
}
