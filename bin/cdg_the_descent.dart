import 'dart:io';
import 'dart:math';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s ?? '';
}

void main() {

  // game loop
  while (true) {
    int maxH = 0;
    int index = 0;
    for (int i = 0; i < 8; i++) {
      final mountainH = int.parse(readLineSync()); // represents the height of one mountain.
      if (mountainH > maxH){
        maxH = mountainH;
        index = i;
      }
    }
    print(index); // The index of the mountain to fire on.
  }
}