import 'dart:math';
import "Item.dart";

class Order {
  int id;
  Point position;
  Map<Item, int> orders;

  Order({this.id, this.position, this.orders});
}
