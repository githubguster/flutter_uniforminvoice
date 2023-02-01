import 'dart:ffi' as ffi;

class GeneratedBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  GeneratedBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  GeneratedBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  late final _setLogEnabledPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>('setLogEnabled');
  late final _setLogEnabled =
      _setLogEnabledPtr.asFunction<void Function(int)>();

  /// @brief Enables or disables the logging of the library.
  /// @param enable Whether to enable or disable the logging.
  /// @param enabled
  void setLogEnabled(int enable) {
    return _setLogEnabled(enable);
  }

  late final _versionPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Char> Function()>>('version');
  late final _version =
      _versionPtr.asFunction<ffi.Pointer<ffi.Char> Function()>();

  /// Returns the version of the zxing-cpp library.
  /// @return The version of the zxing-cpp library.
  ffi.Pointer<ffi.Char> version() {
    return _version();
  }

  late final _readBarcodePtr = _lookup<
      ffi.NativeFunction<
          CodeResult Function(ffi.Pointer<ffi.Uint8>, ffi.Int, ffi.Int, ffi.Int,
              ffi.Int, ffi.Int, ffi.Int, ffi.Int, ffi.Int)>>('readBarcode');
  late final _readBarcode = _readBarcodePtr.asFunction<
      CodeResult Function(
          ffi.Pointer<ffi.Uint8>, int, int, int, int, int, int, int, int)>();

  /// @brief Read barcode from image bytes.
  /// @param bytes Image bytes.
  /// @param format Specify a set of BarcodeFormats that should be searched for.
  /// @param width Image width in pixels.
  /// @param height Image height in pixels.
  /// @param cropWidth Crop width.
  /// @param cropHeight Crop height.
  /// @param tryHarder Spend more time to try to find a barcode; optimize for accuracy, not speed.
  /// @param tryRotate Also try detecting code in 90, 180 and 270 degree rotated images.
  /// @param tryInvert invert images.
  /// @return The barcode result.
  CodeResult readBarcode(
      ffi.Pointer<ffi.Uint8> bytes,
      int format,
      int width,
      int height,
      int cropWidth,
      int cropHeight,
      int tryHarder,
      int tryRotate,
      int tryInvert) {
    return _readBarcode(bytes, format, width, height, cropWidth, cropHeight,
        tryHarder, tryRotate, tryInvert);
  }

  late final _readBarcodesPtr = _lookup<
      ffi.NativeFunction<
          CodeResults Function(
              ffi.Pointer<ffi.Uint8>,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Int,
              ffi.Int)>>('readBarcodes');
  late final _readBarcodes = _readBarcodesPtr.asFunction<
      CodeResults Function(
          ffi.Pointer<ffi.Uint8>, int, int, int, int, int, int, int, int)>();

  /// @brief Read barcodes from image bytes.
  /// @param bytes Image bytes.
  /// @param format Specify a set of BarcodeFormats that should be searched for.
  /// @param width Image width in pixels.
  /// @param height Image height in pixels.
  /// @param cropWidth Crop width.
  /// @param cropHeight Crop height.
  /// @param tryHarder Spend more time to try to find a barcode, optimize for accuracy, not speed.
  /// @param tryRotate Also try detecting code in 90, 180 and 270 degree rotated images.
  /// @param tryInvert invert images.
  /// @return The barcode results.
  CodeResults readBarcodes(
      ffi.Pointer<ffi.Uint8> bytes,
      int format,
      int width,
      int height,
      int cropWidth,
      int cropHeight,
      int tryHarder,
      int tryRotate,
      int tryInvert) {
    return _readBarcodes(bytes, format, width, height, cropWidth, cropHeight,
        tryHarder, tryRotate, tryInvert);
  }

  late final _encodeBarcodePtr = _lookup<
      ffi.NativeFunction<
          EncodeResult Function(ffi.Pointer<ffi.Char>, ffi.Int, ffi.Int,
              ffi.Int, ffi.Int, ffi.Int)>>('encodeBarcode');
  late final _encodeBarcode = _encodeBarcodePtr.asFunction<
      EncodeResult Function(ffi.Pointer<ffi.Char>, int, int, int, int, int)>();

  /// @brief Encode a string into a barcode
  /// @param contents The string to encode
  /// @param width The width of the barcode in pixels.
  /// @param height The height of the barcode in pixels.
  /// @param format The format of the barcode
  /// @param margin The margin of the barcode
  /// @param eccLevel The error correction level of the barcode. Used for Aztec, PDF417, and QRCode only, [0-8].
  /// @return The barcode data
  EncodeResult encodeBarcode(ffi.Pointer<ffi.Char> contents, int width,
      int height, int format, int margin, int eccLevel) {
    return _encodeBarcode(contents, width, height, format, margin, eccLevel);
  }

  /// @brief free menory
  /// @param result The barcode result.
  late final _freeCodeResultPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(CodeResult)>>(
          'freeCodeResult');

  late final _freeCodeResult =
      _freeCodeResultPtr.asFunction<void Function(CodeResult)>();

  void freeCodeResult(CodeResult result) {
    _freeCodeResult(result);
  }

  /// @brief free menory
  /// @param result The barcode results.
  late final _freeCodeResultsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(CodeResults)>>(
          'freeCodeResults');

  late final _freeCodeResults =
      _freeCodeResultsPtr.asFunction<void Function(CodeResults)>();

  void freeCodeResults(CodeResults results) {
    _freeCodeResults(results);
  }

  /// @brief free menory
  /// @param result The barcode result.
  late final _freeEncodeResultPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(EncodeResult)>>(
          'freeEncodeResult');

  late final _freeEncodeResult =
      _freeEncodeResultPtr.asFunction<void Function(EncodeResult)>();

  void freeEncodeResult(EncodeResult result) {
    _freeEncodeResult(result);
  }
}

/// @brief The CodeResult class encapsulates the result of decoding a barcode within an image.
class Position extends ffi.Struct {
  /// < The width of the image
  @ffi.Int()
  external int imageWidth;

  /// < The height of the image
  @ffi.Int()
  external int imageHeight;

  /// < x coordinate of top left corner of barcode
  @ffi.Int()
  external int topLeftX;

  /// < y coordinate of top left corner of barcode
  @ffi.Int()
  external int topLeftY;

  /// < x coordinate of top right corner of barcode
  @ffi.Int()
  external int topRightX;

  /// < y coordinate of top right corner of barcode
  @ffi.Int()
  external int topRightY;

  /// < x coordinate of bottom left corner of barcode
  @ffi.Int()
  external int bottomLeftX;

  /// < y coordinate of bottom left corner of barcode
  @ffi.Int()
  external int bottomLeftY;

  /// < x coordinate of bottom right corner of barcode
  @ffi.Int()
  external int bottomRightX;

  /// < y coordinate of bottom right corner of barcode
  @ffi.Int()
  external int bottomRightY;
}

/// @brief The CodeResult class encapsulates the result of decoding a barcode within an image.
class CodeResult extends ffi.Struct {
  /// < Whether the barcode was successfully decoded
  @ffi.Int()
  external int isValid;

  /// < The format of the barcode
  @ffi.Int()
  external int format;

  /// < The decoded text
  external ffi.Pointer<ffi.Char> text;

  /// < The bytes is the raw / standard content without any modifications like character set conversions
  external ffi.Pointer<ffi.UnsignedChar> bytes;

  /// < The length of the bytes
  @ffi.Int()
  external int length;

  /// < The position of the barcode within the image
  external ffi.Pointer<Position> position;

  /// < Whether the barcode was inverted
  @ffi.Int()
  external int isInverted;

  /// < Whether the barcode was mirrored
  @ffi.Int()
  external int isMirrored;

  /// < The duration of the decoding in milliseconds
  @ffi.Int()
  external int duration;

  /// < The error message
  external ffi.Pointer<ffi.Char> error;
}

/// @brief The CodeResults class encapsulates the result of decoding multiple barcodes within an image.
class CodeResults extends ffi.Struct {
  /// < The number of barcodes detected
  @ffi.Int()
  external int count;

  /// < The results of the barcode decoding
  external ffi.Pointer<CodeResult> results;
}

/// @brief EncodeResult encapsulates the result of encoding a barcode.
class EncodeResult extends ffi.Struct {
  /// < Whether the barcode was successfully encoded
  @ffi.Int()
  external int isValid;

  /// < The format of the barcode
  @ffi.Int()
  external int format;

  /// < The encoded text
  external ffi.Pointer<ffi.Char> text;

  /// < The encoded data
  external ffi.Pointer<ffi.SignedChar> data;

  /// < The length of the encoded data
  @ffi.Int()
  external int length;

  /// < The error message
  external ffi.Pointer<ffi.Char> error;
}
