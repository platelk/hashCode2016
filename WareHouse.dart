import 'dart:math';
import 'Item.dart';

class WareHouse {
  int id;
  Point position;
  Map<Item, int> stock = {};

  WareHouse(this.id, this.position, [this.stock = const {}]);

  String toString() {
    return "[WareHouse# id: $id, pos: $position, stock: $stock]";
  }
}
