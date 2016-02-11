import 'dart:math';

class Drone {
  int id;
  int load;
  Point position;
  int actionDuration = 0;
  List<Item> items = [];

  Drone({this.id: 0, this.load: 200});

  bool isAvailable() => actionDuration == 0;
}
