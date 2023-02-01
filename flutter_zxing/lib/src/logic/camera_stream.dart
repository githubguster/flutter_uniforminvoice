part of 'zxing.dart';

IsolateUtils? isolateUtils;

/// Starts reading barcode from the camera
Future<void> zxingStartCameraProcessing() async {
  zxingStopCameraProcessing();
  isolateUtils = IsolateUtils();
  await isolateUtils?.startReadingBarcode();
}

/// Stops reading barcode from the camera
void zxingStopCameraProcessing() {
  isolateUtils?.stopReadingBarcode();
  isolateUtils = null;
}

Future<CodeResult> zxingProcessCameraImage(
  CameraImage image, {
  DecodeParams? params,
}) async {
  final IsolateData isolateData = IsolateData(image, params ?? DecodeParams());
  final CodeResult result = await _inference(isolateData);
  return result;
}

/// Runs inference in another isolate
Future<CodeResult> _inference(IsolateData isolateData) async {
  final ReceivePort responsePort = ReceivePort();
  isolateUtils?.sendPort
      ?.send(isolateData..responsePort = responsePort.sendPort);
  final dynamic results = await responsePort.first;
  return results;
}

Future<List<CodeResult>> zxingProcessCameraImages(
  CameraImage image, {
  DecodeParams? params,
}) async {
  final IsolateData isolateData = IsolateData(image, params ?? DecodeParams());
  final List<CodeResult> result = await _inferences(isolateData);
  return result;
}

/// Runs inference in another isolate
Future<List<CodeResult>> _inferences(IsolateData isolateData) async {
  final ReceivePort responsePort = ReceivePort();
  isolateUtils?.sendPort
      ?.send(isolateData..responsePort = responsePort.sendPort);
  final dynamic results = await responsePort.first;
  return results;
}
