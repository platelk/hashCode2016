import 'dart:math';
import "Item.dart";

class Order {
  int id;
  Point position;
  Map<Item, int> orders;

  Order({this.id, this.position, this.orders});

  int leftToDeliver() {
    int tot = 0;
    for (var v in orders.values) {
      tot += v;
    }
    return tot;
  }
}
