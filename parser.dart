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

    Simulation();
}


Simulation parse(File input) {
    Simulation sim = new Simulation();
    List<String> lines = input.readAsLinesSync();
    List<String> mapParams = lines[0].split(' ');

    sim.grid = new Grid(int.parse(mapParams[1]), int.parse(mapParams[0]));

    print(sim.grid.width);

    return sim;
}
