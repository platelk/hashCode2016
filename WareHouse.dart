import 'dart:math';

class WareHouse {
  Point position;
  List<Item> stock = [];

  WareHouse(this.position, [this.stock = const []]);
}
