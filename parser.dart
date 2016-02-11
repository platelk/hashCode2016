import 'dart:io';

import 'Grid.dart';
import 'Drone.dart';
import 'WareHouse.dart';
import 'Customer.dart';

class Simulation {
    Grid grid;

    List<WareHouse> warehouses;
    List<Drone> drones;
    List<Customer> customers;

    int deadline;

    Simulation();
}


Simulation parse(File input) {
    Simulation sim = new Simulation();
    List<String> lines = input.readAsLinesSync();
    List<String> mapParams = lines[0].split(' ');

    sim.grid = new Grid(int.parse(mapParams[1]), int.parse(mapParams[0]));
    sim.drones = new List<Drone>.generate(int.parse(mapParams[2]), (int id) => new Drone(id: id, maxLoad: int.parse(mapParams[4])));
    sim.deadline = int.parse(mapParams[3]);

    print(sim.drones.length);

    return sim;
}
