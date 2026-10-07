// Stub implementation of tflite_flutter and tflite_flutter_helper for Flutter Web where dart:ffi is unsupported.

class Interpreter {
  static Future<Interpreter> fromAsset(
    String assetName, {
    dynamic options,
  }) async {
    return Interpreter();
  }

  static Future<Interpreter> fromFile(
    dynamic file, {
    dynamic options,
  }) async {
    return Interpreter();
  }

  Tensor getInputTensor(int index) => Tensor();
  Tensor getOutputTensor(int index) => Tensor();

  void run(Object input, Object output) {
    // No-op on web
  }

  void runForMultipleInputs(List<Object> inputs, Map<int, Object> outputs) {
    // No-op on web
  }

  void close() {}
}

class Tensor {
  final List<int> shape;
  final dynamic type;

  Tensor({this.shape = const [1, 224, 224, 3], this.type = 'float32'});
}

class TensorBuffer {
  static TensorBuffer createFixedSize(List<int> shape, dynamic type) {
    return TensorBuffer();
  }

  dynamic get buffer => [];
  List<double> getDoubleList() => [];
}
