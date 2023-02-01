import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

// https://gist.github.com/Alby-o/fe87e35bc21d534c8220aed7df028e03

class ImageConvert {
  static Future<Uint8List> convertImage(CameraImage image) async {
    try {
      debugPrint('IMAGE FORMAT: ${image.format.group}');
      late imglib.Image img;
      if (image.format.group == ImageFormatGroup.yuv420) {
        return image.planes.first.bytes;
      } else if (image.format.group == ImageFormatGroup.bgra8888) {
        img = convertBGRA8888(image);
      }
      return img.getBytes();
    } catch (e) {
      debugPrint('>>>>>>>>>>>> ERROR: $e');
    }
    return Uint8List(0);
  }

  static imglib.Image convertBGRA8888(CameraImage image) {
    return imglib.Image.fromBytes(
        width: image.width,
        height: image.height,
        bytes: image.planes[0].bytes.buffer,
        format: imglib.Format.uint32,
        order: imglib.ChannelOrder.bgra);
  }

  static Uint8List invertImage(Uint8List bytes) {
    final Uint8List invertedBytes = Uint8List.fromList(bytes);
    for (int i = 0; i < invertedBytes.length; i++) {
      invertedBytes[i] = 255 - invertedBytes[i];
    }
    return invertedBytes;
  }
}
