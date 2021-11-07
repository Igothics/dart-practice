import 'dart:io';
import 'dart:math';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}
class Pos {
  int col;
  int row;
  Pos({required this.col, required this.row});

  int get nextCol => (col / 2).round();
  int get nextRow => (row / 2).round();

  @override
  String toString() => '$col $row';
}
class HeatTracker {
  final Pos remainArea; // a matrix of rest windows after every move U, D, UR, etc.
  final int maxTurn; // no need but still here
  final Pos batmanPos; // batman's position will be update turn by turn
  final Pos targetPos; // batman's position in remainArea matrix. It's necessary when calculate next position.

  HeatTracker({required this.remainArea, required this.maxTurn, required this.batmanPos, required this.targetPos});

  Pos calculate(String move){
    final moveList = move.split('').map((e) => e.toUpperCase());
    Pos result = Pos(col: batmanPos.col, row: batmanPos.row);

    for(String move in moveList){
      if(move == 'U'){
        remainArea.row = targetPos.row;

        result.row = batmanPos.row - remainArea.nextRow;

        targetPos.row = remainArea.row - remainArea.nextRow;
      }else if(move == 'D'){
        remainArea.row = remainArea.row - (targetPos.row + 1);

        result.row = batmanPos.row + remainArea.nextRow;

        targetPos.row = remainArea.nextRow - 1;
      }else if(move == 'L'){
        remainArea.col = targetPos.col;

        result.col = batmanPos.col - remainArea.nextCol;

        targetPos.col = remainArea.col - remainArea.nextCol;
      }else if(move == 'R'){
        remainArea.col = remainArea.col - (targetPos.col + 1);

        result.col = batmanPos.col + remainArea.nextCol;

        targetPos.col = remainArea.nextCol - 1;
      }
    }
    // print('remainArea: $remainArea');
    // print('batmanPos: $batmanPos');
    // print('targetPos: $targetPos');
    // print('shouldMoveTo: $result');
    return result;
  }
  void updateBatmanPos(Pos newPos){
    batmanPos.row = newPos.row;
    batmanPos.col = newPos.col;
  }
}
void main() {
  List inputs;
  inputs = readLineSync().split(' ');
  int W = int.parse(inputs[0]); // width of the building.
  int H = int.parse(inputs[1]); // height of the building.
  int N = int.parse(readLineSync()); // maximum number of turns before game over.
  inputs = readLineSync().split(' ');
  int X0 = int.parse(inputs[0]);
  int Y0 = int.parse(inputs[1]);

  final heatTracker = HeatTracker(
      remainArea: Pos(col: W, row: H),
      maxTurn: N, batmanPos: Pos(col: X0, row: Y0),
      targetPos: Pos(col: X0, row: Y0) // at the beginning targetPos = batmanPos. Imagine batman from outside of building and find to targetPos to start point
  );

  // game loop
  while (true) {
    String bombDir = readLineSync(); // the direction of the bombs from batman's current location (U, UR, R, DR, D, DL, L or UL)
    final pos = heatTracker.calculate(bombDir);
    print(pos);
    heatTracker.updateBatmanPos(pos);
  }
}