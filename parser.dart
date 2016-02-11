import 'dart:io';
import 'dart:math';

import 'Grid.dart';
import 'Drone.dart';
import 'WareHouse.dart';
import 'Order.dart';
import 'Item.dart';

class Candidate {
  Order customers;
  WareHouse warehouse;
  Map<Item, int> items = {};
}

class Simulation {
  Grid grid;
  int deadline;

  List<WareHouse> warehouses;
  List<Drone> drones;
  List<Order> orders;
  List<String> actions = [];

  Simulation();

  void _oneDroneTurn() {
    for (var d in drones) {
      d.oneTurn();
    }
  }

  Map<Item, int> availableItemInWarehouse(WareHouse wh, Order c, Drone d) {
    Map<Item, int> available = {};
    int weight = 0;

    for (var item in wh.stock.keys) {
      if (wh.stock[item] != null &&
          c.orders[item] != null &&
          wh.stock[item] > 0 &&
          c.orders[item] > 0 &&
          (weight + item.weight) <= d.maxLoad) {
        var val = max(wh.stock[item], c.orders[item]);
        while (weight + (val * item.weight) > d.maxLoad) val--;
        available[item] = val;
      }
    }

    return available;
  }

  int score(Drone d, WareHouse wh, Order c) {
    var dist = d.position.distanceTo(wh.position);
    dist += c.position.distanceTo(wh.position);

    return dist;
  }

  void _oneDroneLogic(Drone drone) {
    Map<int, Candidate> scores = {};

    for (var c in orders) {
      for (var wh in warehouses) {
        var candidate = new Candidate();
        candidate.customers = c;
        candidate.warehouse = wh;
        candidate.items = availableItemInWarehouse(wh, c, drone);
        if (candidate.items.length > 0) {
          scores[score(drone, wh, c) - candidate.items.length * 5] = candidate;
        }
      }
    }
    if (scores.isNotEmpty) {
      List<int> finalScores = new List.from(scores.keys);
      finalScores.sort();
      var c = scores[finalScores[0]];
      for (var item in c.items.keys) {
        actions.add(drone.load(c.warehouse, item, c.items[item]));
      }
      for (var item in c.items.keys) {
        actions.add(drone.deliver(c.customers, item, c.items[item]));
      }
    }
  }

  void _dronesLogic(List<Drone> availableDrone) {
    for (var d in availableDrone) {
      _oneDroneLogic(d);
    }
  }

  List<Drone> availableDrone() => drones.where((d) => d.isAvailable());

  void mainLoop() {
    List<Drone> aDrone;

    // deadline = 50;
    for (int i = 0; i < deadline; i++) {
      // print("Turn [$i] --");
      _oneDroneTurn();
      aDrone = availableDrone();
      _dronesLogic(aDrone);
      int length = 0;
      for (var o in orders) {
        length = o.leftToDeliver();
      }
      if (length == 0) return;
    }
  }
}

Simulation parse(File input) {
  Simulation sim = new Simulation();
  List<String> lines = input.readAsLinesSync();
  List<String> mapParams = lines[0].split(' ');

  // Map parameters
  sim.grid = new Grid(int.parse(mapParams[1]), int.parse(mapParams[0]));
  sim.drones = new List<Drone>.generate(int.parse(mapParams[2]),
      (int id) => new Drone(id: id, maxLoad: int.parse(mapParams[4])));
  sim.deadline = int.parse(mapParams[3]);

  // Available Products
  List<String> itemsDefinition = lines[2].split(' ');
  List<Item> items = new List<Item>.generate(int.parse(lines[1]),
      (int id) => new Item(id: id, weight: int.parse(itemsDefinition[id])));

  // WareHouses
  int wareHouseLine = 4;
  sim.warehouses = new List<WareHouse>.generate(int.parse(lines[3]), (int id) {
    List<String> stringPos = lines[wareHouseLine].split(' ');
    Point pos = new Point(int.parse(stringPos[1]), int.parse(stringPos[0]));

    Map<Item, int> stock = new Map();
    int i = 0;
    for (var qty in lines[wareHouseLine + 1].split(' ')) {
      stock[items[i]] = int.parse(qty);
      i++;
    }

    wareHouseLine += 2;
    return new WareHouse(id, pos, stock);
  });

  for (var d in sim.drones) {
    d.position = sim.warehouses[0].position;
  }

  wareHouseLine++;

  sim.orders =
      new List<Order>.generate(int.parse(lines[wareHouseLine - 1]), (int id) {
    List<String> stringPos = lines[wareHouseLine].split(' ');
    Point pos = new Point(int.parse(stringPos[1]), int.parse(stringPos[0]));

    Map<Item, int> products = new Map();

    int i = 0;
    for (var productType in lines[wareHouseLine + 1].split(' ')) {
      if (products[items[int.parse(productType)]] != null) products[
          items[int.parse(productType)]] += 1;
      else products[items[int.parse(productType)]] = 1;
    }

    wareHouseLine += 3;
    return new Order(id: id, position: pos, orders: products);
  });

  return sim;
}
