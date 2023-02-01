part of 'zxing.dart';

// Encode a string into a barcode
EncodeResult zxingEncodeBarcode({
  required String contents,
  required EncodeParams params,
}) {
  generated_bindings.EncodeResult encodeResult = bindings.encodeBarcode(
    contents.toNativeUtf8().cast<Char>(),
    params.width,
    params.height,
    params.format.value,
    params.margin,
    params.eccLevel.value,
  );
  EncodeResult result = encodeResult.toEncode();
  bindings.freeEncodeResult(encodeResult);
  return result;
}
