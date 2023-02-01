import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'src/logic/zxing.dart';
import 'src/models/models.dart';

export 'src/models/models.dart';
export 'src/ui/models.dart';

class FlutterZXing with ZXingCamera, ZXingReader, ZXingEncoder {
  const FlutterZXing();

  String version() => zxingVersion();

  void setLogEnabled(bool enabled) => setZxingLogEnabled(enabled);

  String barcodeFormatName(Format format) => zxingBarcodeFormatName(format);
}

class FlutterZXingPermission {
  static Future<void> checkPermission(
      {required bool enableGallery,
      VoidCallback? onSuccess,
      VoidCallback? onFailed,
      VoidCallback? goSetting}) async {
    List<Permission> permissions = enableGallery
        ? [Permission.camera, Permission.storage]
        : [Permission.camera];
    List<Permission> requestPermissions = [];
    for (Permission permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        requestPermissions.add(permission);
      }
    }
    if (requestPermissions.isNotEmpty) {
      PermissionStatus permissionStatus =
          await _requestPermission(requestPermissions);
      switch (permissionStatus) {
        case PermissionStatus.denied:
          onFailed != null
              ? onFailed()
              : await checkPermission(
                  enableGallery: enableGallery,
                  onSuccess: onSuccess,
                  onFailed: onFailed,
                  goSetting: goSetting);
          break;
        case PermissionStatus.granted:
          onSuccess?.call();
          break;
        case PermissionStatus.restricted:
        case PermissionStatus.limited:
        case PermissionStatus.permanentlyDenied:
          goSetting != null ? goSetting() : openAppSettings();
          break;
      }
    } else {
      onSuccess?.call();
    }
  }

  static Future<PermissionStatus> _requestPermission(
      List<Permission> permissions) async {
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    for (Permission permission in permissions) {
      PermissionStatus status = await permission.request();
      if (!status.isGranted) {
        currentPermissionStatus = status;
        break;
      }
    }
    return currentPermissionStatus;
  }
}

mixin ZXingCamera {
  Future<void> startCameraProcessing() => zxingStartCameraProcessing();

  void stopCameraProcessing() => zxingStopCameraProcessing();

  Future<CodeResult> processCameraImage(
    CameraImage image, {
    DecodeParams? params,
  }) =>
      zxingProcessCameraImage(image, params: params);

  Future<List<CodeResult>> processCameraImages(
    CameraImage image, {
    DecodeParams? params,
  }) =>
      zxingProcessCameraImages(image, params: params);
}

mixin ZXingReader {
  Future<CodeResult?> readBarcodeImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImagePathString(path, params: params);

  Future<CodeResult?> readBarcodeImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImagePath(path, params: params);

  Future<CodeResult?> readBarcodeImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodeImageUrl(url, params: params);

  CodeResult readBarcode(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      zxingReadBarcode(bytes, width: width, height: height, params: params);

  Future<List<CodeResult>> readBarcodesImagePathString(
    String path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImagePathString(path, params: params);

  Future<List<CodeResult>> readBarcodesImagePath(
    XFile path, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImagePath(path, params: params);

  Future<List<CodeResult>> readBarcodesImageUrl(
    String url, {
    DecodeParams? params,
  }) =>
      zxingReadBarcodesImageUrl(url, params: params);

  List<CodeResult> readBarcodes(
    Uint8List bytes, {
    required int width,
    required int height,
    DecodeParams? params,
  }) =>
      zxingReadBarcodes(bytes, width: width, height: height, params: params);
}

mixin ZXingEncoder {
  EncodeResult encodeBarcode({
    required String contents,
    required EncodeParams params,
  }) =>
      zxingEncodeBarcode(contents: contents, params: params);
}
