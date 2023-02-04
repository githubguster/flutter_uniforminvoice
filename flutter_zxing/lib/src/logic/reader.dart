part of 'zxing.dart';

CodeResult _readBarcode(
  Uint8List bytes,
  int width,
  int height,
  DecodeParams? params,
) {
  generated_bindings.CodeResult codeResult = bindings.readBarcode(
    bytes.allocatePointer(),
    (params?.format ?? Format.any).value,
    width,
    height,
    params?.cropWidth ?? 0,
    params?.cropHeight ?? 0,
    params?.tryHarder ?? false ? 1 : 0,
    params?.tryRotate ?? true ? 1 : 0,
    params?.tryInverted ?? false ? 1 : 0,
  );
  CodeResult result = codeResult.toCodeResult();
  bindings.freeCodeResult(codeResult);
  return result;
}

List<CodeResult> _readBarcodes(
  Uint8List bytes,
  int width,
  int height,
  DecodeParams? params,
) {
  final generated_bindings.CodeResults result = bindings.readBarcodes(
    bytes.allocatePointer(),
    (params?.format ?? Format.any).value,
    width,
    height,
    params?.cropWidth ?? 0,
    params?.cropHeight ?? 0,
    params?.tryHarder ?? false ? 1 : 0,
    params?.tryRotate ?? true ? 1 : 0,
    params?.tryInverted ?? false ? 1 : 0,
  );
  final List<CodeResult> results = <CodeResult>[];
  for (int i = 0; i < result.count; i++) {
    results.add(result.results.elementAt(i).ref.toCodeResult());
  }
  bindings.freeCodeResults(result);
  return results;
}

/// Reads barcode from String image path
Future<CodeResult?> zxingReadBarcodeImagePathString(
  String path, {
  DecodeParams? params,
}) =>
    zxingReadBarcodeImagePath(
      XFile(path),
      params: params,
    );

/// Reads barcode from XFile image path
Future<CodeResult?> zxingReadBarcodeImagePath(
  XFile path, {
  DecodeParams? params,
}) async {
  final Uint8List imageBytes = await path.readAsBytes();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return null;
  }
  return zxingReadBarcode(
    image.getLuminanceBytes(),
    width: image.width,
    height: image.height,
    params: params,
  );
}

/// Reads barcode from image url
Future<CodeResult?> zxingReadBarcodeImageUrl(
  String url, {
  DecodeParams? params,
}) async {
  final Uint8List imageBytes =
      (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return null;
  }
  return zxingReadBarcode(
    image.getLuminanceBytes(),
    width: image.width,
    height: image.height,
    params: params,
  );
}

// Reads barcode from Uint8List image bytes
CodeResult zxingReadBarcode(
  Uint8List bytes, {
  required int width,
  required int height,
  DecodeParams? params,
}) {
  CodeResult result = _readBarcode(bytes, width, height, params);
  if (!result.isValid && params != null && params.tryInverted == true) {
    // try to invert the image and read again
    final Uint8List invertedBytes = ImageConvert.invertImage(bytes);
    result = _readBarcode(invertedBytes, width, height, params);
  }
  return result;
}

/// Reads barcodes from String image path
Future<List<CodeResult>> zxingReadBarcodesImagePathString(
  String path, {
  DecodeParams? params,
}) =>
    zxingReadBarcodesImagePath(
      XFile(path),
      params: params,
    );

/// Reads barcodes from XFile image path
Future<List<CodeResult>> zxingReadBarcodesImagePath(
  XFile path, {
  DecodeParams? params,
}) async {
  final Uint8List imageBytes = await path.readAsBytes();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return <CodeResult>[];
  }
  return zxingReadBarcodes(
    image.getLuminanceBytes(),
    width: image.width,
    height: image.height,
    params: params,
  );
}

/// Reads barcodes from image url
Future<List<CodeResult>> zxingReadBarcodesImageUrl(
  String url, {
  DecodeParams? params,
}) async {
  final Uint8List imageBytes =
      (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
  final imglib.Image? image = imglib.decodeImage(imageBytes);
  if (image == null) {
    return <CodeResult>[];
  }
  return zxingReadBarcodes(
    image.getLuminanceBytes(),
    width: image.width,
    height: image.height,
    params: params,
  );
}

/// Reads barcodes from Uint8List image bytes
List<CodeResult> zxingReadBarcodes(
  Uint8List bytes, {
  required int width,
  required int height,
  DecodeParams? params,
}) {
  List<CodeResult> results = _readBarcodes(bytes, width, height, params);
  if (results.isEmpty && params != null && params.tryInverted == true) {
    // try to invert the image and read again
    final Uint8List invertedBytes = ImageConvert.invertImage(bytes);
    results = _readBarcodes(invertedBytes, width, height, params);
  }
  return results;
}
