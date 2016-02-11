import 'dart:io';

int main(List<String> arg) {
  print("Google HashCode 2016");
  if (arg.length < 1) {
    print("Error: you need to provide a file");
  }
  File data = new File(arg[0]);

  return 1;
}
