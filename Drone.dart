import 'dart:math';
import "Item.dart";
import "WareHouse.dart";
import "Customer.dart";

class Drone {
  int id;
  int maxLoad;
  Point position;
  int actionDuration = 0;
  Map<Item, int> items = {};
  var _action;

  Drone({this.id: 0, this.maxLoad: 200});

  bool isAvailable() => actionDuration == 0;

  String toString() {
    return "[Drone# id: $id, maxLoad: $maxLoad, pos: $position, d: $actionDuration]";
  }

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
    _action();
    return "${id} L ${wh.id} ${item.id} ${nb}";
  }

  String deliver(Customer customer, Item item, int nb) {
    _action = () {
      items[item] -= nb;
      customer.orders[item] -= nb;
    };
    _setWaitTime(customer.position);
    _action();
    return "${id} D ${customer.id} ${item.id} ${nb}";
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
    _action();
    return "${id} U ${wh.id} ${item.id} ${nb}";
  }

  void oneTurn() {
    if (actionDuration == 1 && _action != null) {
      // _action();
      _action = null;
    }
    if (actionDuration > 0) actionDuration -= 1;
  }
}
