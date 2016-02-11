class Item {
  int id;
  int weight;

  Item({this.id, this.weight});

  bool operator ==(Item i) {
    return id == i.id && weight == i.weight;
  }

  int compateTo(Item i) {
    return id - id + weight - weight;
  }
}
