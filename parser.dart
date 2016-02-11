import 'dart:io';
import 'dart:math';

import 'Item.dart';
import 'Grid.dart';
import 'Drone.dart';
import 'WareHouse.dart';
import 'Order.dart';

class Simulation {
    Grid grid;

    List<WareHouse> warehouses;
    List<Drone> drones;
    List<Order> orders;

    int deadline;

    Simulation();
}


Simulation parse(File input) {
    Simulation sim = new Simulation();
    List<String> lines = input.readAsLinesSync();
    List<String> mapParams = lines[0].split(' ');

    // Map parameters
    sim.grid = new Grid(int.parse(mapParams[1]), int.parse(mapParams[0]));
    sim.drones = new List<Drone>.generate(int.parse(mapParams[2]), (int id) => new Drone(id: id, maxLoad: int.parse(mapParams[4])));
    sim.deadline = int.parse(mapParams[3]);

    // Available Products
    List<String> itemsDefinition = lines[2].split(' ');
    List<Item> items = new List<Item>.generate(int.parse(lines[1]), (int id) => new Item(id: id, weight: int.parse(itemsDefinition[id])));

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

    wareHouseLine++;

    sim.orders = new List<Order>.generate(int.parse(lines[wareHouseLine - 1]), (int id) {
        print(lines[wareHouseLine]);
        List<String> stringPos = lines[wareHouseLine].split(' ');
        Point pos = new Point(int.parse(stringPos[1]), int.parse(stringPos[0]));

        Map<Item, int> products = new Map();

        int i = 0;
        for (var productType in lines[wareHouseLine + 1].split(' ')) {
            if (products[items[int.parse(productType)]] != null) products[items[int.parse(productType)]] += 1;
            else products[items[int.parse(productType)]] = 1;
        }

        wareHouseLine += 3;
        return new Order(id: id, position: pos, orders: products);
    });


    return sim;
}
