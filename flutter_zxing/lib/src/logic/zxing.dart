import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;

import '../extend/generated_bindings.dart' as generated_bindings;
import '../models/models.dart';
import '../utils/image_converter.dart';
import '../utils/isolate_utils.dart';

part 'bindings.dart';
part 'reader.dart';
part 'encoder.dart';
part 'camera_stream.dart';

/// ZXing-cpp version
String zxingVersion() => bindings.version().cast<Utf8>().toDartString();

/// Enables or disables the logging of the library
void setZxingLogEnabled(bool enabled) =>
    bindings.setLogEnabled(enabled ? 1 : 0);

/// Returns a readable barcode format name
String zxingBarcodeFormatName(Format format) => format.name;

extension Uint8ListBlobConversion on Uint8List {
  /// Allocates a pointer filled with the Uint8List data.
  Pointer<Uint8> allocatePointer() {
    final Pointer<Int8> blob = calloc<Int8>(length);
    final Int8List blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);
    return blob.cast<Uint8>();
  }
}
