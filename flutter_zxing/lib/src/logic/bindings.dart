part of 'zxing.dart';

DynamicLibrary _openDynamicLibrary() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libflutter_zxing.so');
  }
  return DynamicLibrary.process();
}

generated_bindings.GeneratedBindings bindings =
    generated_bindings.GeneratedBindings(_openDynamicLibrary());
