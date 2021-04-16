class SimpleBarChartList {
  int id;
  String name, x, y;
  SimpleBarChartList(this.name, this.x, this.y, {this.id});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['x'] = x;
    map['y'] = y;
    return map;
  }

  SimpleBarChartList.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.x = map['x'];
    this.y = map['y'];
  }
}
