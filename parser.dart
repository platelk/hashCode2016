import 'dart:io';
import 'dart:math';

import 'Grid.dart';
import 'Drone.dart';
import 'WareHouse.dart';
import 'Customer.dart';
import 'Item.dart';

class Candidate {
  Customer customers;
  WareHouse warehouse;
  Map<Item, int> items = {};
}

class Simulation {
  Grid grid;

  List<WareHouse> warehouses;
  List<Drone> drones;
  List<Customer> customers;

  List<String> actions;

  Simulation();

  void _oneDroneTurn() {
    for (var d in drones) {
      d.oneTurn();
    }
  }

  Map<Item, int> availableItemInWarehouse(WareHouse wh, Customer c, Drone d) {
    Map<Item, int> available = {};
    int weight = 0;

    for (var item in wh.stock.keys) {
      if (wh.stock[item] > 0 &&
          c.orders[item] > 0 &&
          (weight + item.weight) <= d.maxLoad) {
        var val = max(wh.stock[item], c.orders[item]);
        while (weight + (val * item.weight) > d.maxLoad) val--;
        available[item] = val;
      }
    }

    return available;
  }

  int score(Drone d, WareHouse wh, Customer c) {
    var dist = d.position.distanceTo(wh.position);
    dist += c.position.distanceTo(wh.position);

    return dist;
  }

  void _oneDroneLogic(Drone drone) {
    Map<int, Candidate> scores = {};

    for (var c in customers) {
      for (var wh in warehouses) {
        var candidate = new Candidate();
        candidate.customers = c;
        candidate.warehouse = wh;
        candidate.items = availableItemInWarehouse(wh, c);
        if (candidate.items.length > 0) {
          scores[score(drone, wh, c) - candidate.items.length * 5] = candidate;
        }
      }
    }
    if (scores.isNotEmpty) {
      List<int> finalScores = scores.keys;
      finalScores.sort();
      var c = scores[finalScores[0]];
      for (var item in c.items.keys) {
        drone.load(c.warehouse, item, c.items[item]);
      }
      for (var item in c.items.keys) {
        drone.deliver(c.customers, item, c.items[item]);
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
    int maxTurn = 50; // TODO : Change to normal value
    List<Drone> aDrone;

    for (int i = 0; i < maxTurn; i++) {
      _oneDroneTurn();
      aDrone = availableDrone();
      _dronesLogic(aDrone);
    }
  }
}

Simulation parse(File input) {
  Simulation sim = new Simulation();
  List<String> lines = input.readAsLinesSync();
  List<String> mapParams = lines[0].split(' ');

  sim.grid = new Grid(int.parse(mapParams[1]), int.parse(mapParams[0]));

  print(sim.grid.width);

  return sim;
}
