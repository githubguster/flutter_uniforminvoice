import 'dart:typed_data';

import 'format.dart';
import 'position.dart';

class CodeResult {
  CodeResult(
    this.isValid,
    this.format,
    this.text,
    this.rawBytes,
    this.length,
    this.position,
    this.isInverted,
    this.isMirrored,
    this.duration,
    this.error,
  );

  bool isValid; // Whether the code is valid
  String? text; // The text of the code
  Uint8List? rawBytes; // The raw bytes of the code
  int? length; // The length of the raw bytes
  Format? format; // The format of the code
  Position? position; // The position of the code
  bool isInverted; // Whether the code is inverted
  bool isMirrored; // Whether the code is mirrored
  int duration; // The duration of the decoding in milliseconds
  String? error; // The error of the code
}

class EncodeResult {
  EncodeResult(
    this.isValid,
    this.format,
    this.text,
    this.data,
    this.length,
    this.error,
  );

  bool isValid; // Whether the code is valid
  Format? format; // The format of the code
  String? text; // The text of the code
  Uint32List? data; // The raw data of the code
  int? length; // The length of the data
  String? error; // The error message
}
