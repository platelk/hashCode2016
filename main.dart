import 'dart:io';

import 'parser.dart';

int main(List<String> arg) {
  // print("Google HashCode 2016");
  if (arg.length < 1) {
    print("Error: you need to provide a file");
  }

  var sim = parse(new File(arg[0]));

  sim.mainLoop();
  String res = "" + sim.actions.length.toString() + "\n";
  for (var s in sim.actions) {
    res += s + "\n";
  }

  File result = new File(arg[0] + ".result");
  result.writeAsStringSync(res);

  return 1;
}
