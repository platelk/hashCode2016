import 'dart:math';
import 'dart:io';

class Map {
  int width;
  int height;

  Map(this.width, this.height);
}

class WareHouse {
  Point position;
  List<Item> stock = [];

  WareHouse(this.position, [this.stock = const []]);
}

class Customer {
  int id;
  Point position;
  List<Item> orders;

  Customer({this.id, this.position, this.orders});
}

class Item {
  int id;
  int weight;

  Item({this.id, this.weight});
}

class Drone {
  int id;
  int load;
  Point position;
  int actionDuration = 0;
  List<Item> items = [];

  Drone({this.id: 0, this.load: 200});

  bool isAvailable() => actionDuration == 0;
}

int main(List<String> arg) {
  if (arg.length < 2) {
    print("Error: you need to provide a file");
  }
  File data = new File(arg[1]);

  print("Hello world");
  return 1;
}
