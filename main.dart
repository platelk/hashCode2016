import 'dart:io';

import 'parser.dart';

int main(List<String> arg) {
  print("Google HashCode 2016");
  if (arg.length < 1) {
    print("Error: you need to provide a file");
  }

  parse(new File(arg[0]));

  return 1;
}
