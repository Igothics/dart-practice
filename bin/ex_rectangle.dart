import 'dart:io';
import 'dart:math';

class Point{
  const Point(this.x, this.y);
  final double x;
  final double y;

  @override
  String toString() => '(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
}

class Vector{
  Vector.from2Points(Point p1, Point p2) : a = p2.x - p1.x, b = p2.y - p1.y;
  Vector(this.a, this.b);
  final double a;
  final double b;

  double get length => sqrt(pow(a, 2) + pow(b, 2));
  Vector get reverse => Vector(a * -1, b * -1);
}

class Triangle {
  const Triangle(this.pA, this.pB, this.pC);
  final Point pA;
  final Point pB;
  final Point pC;

  Vector get vecAB => Vector.from2Points(pA, pB);
  Vector get vecAC => Vector.from2Points(pA, pC);
  Vector get vecBA => vecAB.reverse;
  Vector get vecBC => Vector.from2Points(pB, pC);
  Vector get vecCB => vecBC.reverse;
  Vector get vecCA => vecAC.reverse;

  double get aEdge => vecBC.length ;
  double get bEdge => vecAC.length ;
  double get cEdge => vecAB.length ;

  double get angleA => getAngleFrom(vecAB, vecAC);
  double get angleB => getAngleFrom(vecBA, vecBC);
  double get angleC => getAngleFrom(vecCB, vecCA);

  List<double> get angleList => [angleA, angleB, angleC];
  List<double> get edgeList => [aEdge, bEdge, cEdge];
  List<Point> get pointList => [pA, pB, pC];

  bool get isTriangle => ((cEdge - bEdge).abs() < aEdge) && (cEdge + bEdge > aEdge);
  bool get isRightTriangle => angleList.any((angle) => angle == 90.0);
  bool get isObtuseTriangle => angleList.any((angle) => angle > 90.0);
  bool get isPointedTriangle => angleList.every((angle) => angle < 90.0); // may be necessary later

  bool get isNormalTriangle => edgeList.toSet().length == 3;
  bool get isIsoscelesTriangle => edgeList.toSet().length == 2;
  bool get isEquilateralTriangle => edgeList.toSet().length == 1;
  bool get isIsoscelesRightTriangle => isIsoscelesTriangle && isRightTriangle; // may be necessary later

  get lengthAH => cEdge * sin(angleB);
  get lengthBH => cEdge * sin(angleA);
  get lengthCH => bEdge * sin(angleA);

  double get perimeter => aEdge + bEdge + cEdge;
  double get area => (((pB.x - pA.x) * (pC.y - pA.y) - (pC.x - pA.x) * (pB.y -pA.y)) / 2).abs();
  Point get centroid => Point((pA.x + pB.x + pC.x) / 3, (pA.y + pB.y + pC.y) / 3);
  Point get inCenter => Point((aEdge * pA.x + bEdge * pB.x + cEdge * pC.x) / perimeter, (aEdge * pA.y + bEdge * pB.y + cEdge * pC.y) / perimeter);

  void printDescription(){
    print('-' * 40);
    print('Triangle ABC with:');
    print('A$pA');
    print('B$pB');
    print('C$pC');
    print('-' * 40);

    if (isTriangle) {
      print(" - It's a triangle! then..");
      print('');
      print(" - Length of a edge is: ${aEdge.toStringAsFixed(2)}");
      print(" - Length of b edge is: ${bEdge.toStringAsFixed(2)}");
      print(" - Length of c edge is: ${cEdge.toStringAsFixed(2)}");
      print('');
      print(" - Degree of angle A: ${angleA.toStringAsFixed(2)}");
      print(" - Degree of angle B: ${angleB.toStringAsFixed(2)}");
      print(" - Degree of angle C: ${angleC.toStringAsFixed(2)}");
      print('');

      if (isRightTriangle) {
        print(" - It's a Right Triangle!");
      } else if (isObtuseTriangle) {
        print(" - It's a Obtuse Triangle!");
      } else {
        print(" - It's a Pointed Triangle!");
      }

      if (isIsoscelesTriangle) {
        print(" - And it's a Isosceles Triangle also!");
      } else if (isEquilateralTriangle) {
        print(" - And it's a Equilateral Triangle also!");
      } else {
        print(" - And it's a Normal Triangle also!");
      }

      print('');
      print(" - It's area is: ${area.toStringAsFixed(2)}");
      print(" - Length of AH edge is: ${lengthAH.toStringAsFixed(2)}");
      print(" - Length of BH edge is: ${lengthBH.toStringAsFixed(2)}");
      print(" - Length of CH edge is: ${lengthCH.toStringAsFixed(2)}");
      print('');
      print(" - It's Centroid point is: G$centroid");
      print(" - It's inCenter point is: H$inCenter");
    }else{
      print(" - It's not a triangle! So.. quit here");
    }
  }
}

void main(){
  const triangleABC = Triangle(Point(0, 5), Point(0, 0), Point(5, 0));
  triangleABC.printDescription();
}

double getAngleFrom(Vector n1, Vector n2) => rad2Deg(acos((n1.a * n2.a + n1.b * n2.b) / (n1.length * n2.length)));
double rad2Deg(double rad) => rad * 180 / pi;