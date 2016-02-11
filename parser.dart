import 'dart:io';

import 'Map.dart';
import 'Drone.dart';

class Simulation {
    Map map;

    List<WareHouse> warehouses;
    List<Drone> drones;
    List<Customers> customers;

    Simulation();
}

void createMap(Simulation sim, List<String> lines) {
    sim.map = new Map();
}

Simulation parse(File input) {
    Simultation sim = new Simulation();
    List<String> lines = input.readAsLinesSync();
    List<String> mapParams = lines[0].split(' ');

    sim.map = new Map(int.parse(mapParams[1]), int.parse(mapParams[0]));

    print(sim.map.width);

    return sim;
}
