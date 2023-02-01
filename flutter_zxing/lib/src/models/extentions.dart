import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../extend/generated_bindings.dart' as generated_bindings;
import 'code.dart';
import 'format.dart';
import 'position.dart';

extension PositionExtention on generated_bindings.Position {
  Position toPosition() => Position(
        topLeftX,
        topLeftY,
        topRightX,
        topRightY,
        bottomLeftX,
        bottomLeftY,
        bottomRightX,
        bottomRightY,
      );
}

extension CodeResultExtention on generated_bindings.CodeResult {
  CodeResult toCodeResult() => CodeResult(
        isValid == 1,
        CodeFormat.formats[format],
        text == nullptr ? null : text.cast<Utf8>().toDartString(),
        bytes == nullptr
            ? null
            : Uint8List.fromList(bytes.cast<Int8>().asTypedList(length)),
        length,
        position == nullptr ? null : position.ref.toPosition(),
        isInverted == 1,
        isMirrored == 1,
        duration,
        error == nullptr ? null : error.cast<Utf8>().toDartString(),
      );
}

extension EncodeExtention on generated_bindings.EncodeResult {
  EncodeResult toEncode() => EncodeResult(
        isValid == 1,
        CodeFormat.formats[format],
        text == nullptr ? null : text.cast<Utf8>().toDartString(),
        data == nullptr
            ? null
            : Uint32List.fromList(data.cast<Int8>().asTypedList(length)),
        length,
        error == nullptr ? null : error.cast<Utf8>().toDartString(),
      );
}
