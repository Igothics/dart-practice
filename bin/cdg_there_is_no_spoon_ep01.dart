import 'dart:io';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s ?? '';
}

/// Don't let the machines win. You are humanity's last hope...

void main() {
  int width = int.parse(readLineSync()); // the number of cells on the X axis
  int height = int.parse(readLineSync()); // the number of cells on the Y axis
  final matrix = <List<String>>[];

  for (int i = 0; i < height; i++) {
    final line = readLineSync().split(''); // width characters, each either 0 or .
    line.add('.'); // add empty sign after every end slot =))
    matrix.add(line);
  }
  matrix.add(List.filled(width, '.')); // add one more line with full empty sign =)). Because I don't want to use a lot of if-else

  for (int row = 0; row < matrix.length - 1; row++) {
    for (int col = 0; col < width; col++){
      if(matrix[row][col] == '.'){
        continue;
      }
      final result = ['$col $row'];

      for (int i = col + 1; i < width; i++){
        final rightNeighbor = matrix[row][i];
        if (rightNeighbor == '.'){
          continue;
        }
        if (rightNeighbor == '0'){
          result.add('$i $row');
          break;
        }
      }
      if (result.length < 2){
        result.add('-1 -1');
      }

      for (int i = row +1; i < matrix.length - 1; i++){
        final bottomNeighbor = matrix[i][col];
        if (bottomNeighbor == '.'){
          continue;
        }
        if (bottomNeighbor == '0'){
          result.add('$col $i');
          break;
        }
      }
      if (result.length < 3){
        result.add('-1 -1');
      }

      print(result.join(' '));
    }
  }

  // print('0 0 1 0 0 1');
}