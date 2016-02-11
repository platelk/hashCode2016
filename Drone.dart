import 'dart:math';
import "Item.dart";
import "WareHouse.dart";
import "Order.dart";

class Drone {
  int id;
  int maxLoad;
  Point position;
  int actionDuration = 0;
  Map<Item, int> items = {};
  var _action;

  Drone({this.id: 0, this.maxLoad: 200});

  bool isAvailable() => actionDuration == 0;

  void _setWaitTime(Point p, {int base: 1}) {
    actionDuration += base;
    var dist = this.position.distanceTo(p);
    if (dist > 0.0) actionDuration += dist.ceil();
  }

  String load(WareHouse wh, Item item, int nb) {
    _action = () {
      wh.stock[item] -= nb;
      items[item] += nb;
    };
    _setWaitTime(wh.position);
    return "${id} L ${wh.id} ${item.id} ${nb}";
  }

  String deliver(Order Order, Item item, int nb) {
    _action = () {
      items[item] -= nb;
      Order.orders[item] -= nb;
    };
    _setWaitTime(Order.position);
    return "${id} D ${Order.id} ${item.id} ${nb}";
  }

  String wait(int nb) {
    actionDuration += nb;
    return "${id} W ${nb}";
  }

  String unLoad(WareHouse wh, Item item, int nb) {
    _action = () {
      items[item] -= nb;
      wh.stock[item] += nb;
    };
    _setWaitTime(wh.position);
    return "${id} U ${wh.id} ${item.id} ${nb}";
  }

  void oneTurn() {
    if (actionDuration == 1 && _action != null) {
      _action();
      _action = null;
    }
    if (actionDuration > 0) actionDuration -= 1;
  }
}
