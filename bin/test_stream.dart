import 'dart:async';

void main() {
  final controller = StreamController();
  int i = 0;

  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);
  addLessThanFive(controller, i++);

  controller.close();
  // addLessThanFive(controller, i++); // can't add anything after stream closed

  controller.stream.listen((value) {
    print(value);
  }, onError: (error) {
    print(error);
  }, onDone: () {
    print("Done!");
  });
}

void addLessThanFive(StreamController controller, int value) {
  if (value < 5) {
    controller.sink.add(value);
  } else {
    controller.sink.addError(StateError("$value not less than 5!"));
  }
}
