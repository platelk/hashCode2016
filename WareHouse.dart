import 'dart:math';
import 'Item.dart';

class WareHouse {
  int id;
  Point position;
  Map<Item, int> stock = {};

  WareHouse(this.position, [this.stock = const {}]);
}
