import 'dart:math';
import "Item.dart";

class Customer {
  int id;
  Point position;
  Map<Item, int> orders;

  Customer({this.id, this.position, this.orders});
}
