import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../flutter_zxing.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc(
      {required this.context, required this.zxing, required this.isShowGallery})
      : super(const CameraFlashModeState(mode: FlashMode.off)) {
    on<CameraControllerInitEvent>(_readerCameraControllerInit);
    on<CameraControllerDisposeEvent>(_readerCameraControllerDispose);
    on<CameraControllerFindCameraEvent>(_readerCameraControllerFindCamera);
    on<CameraControllerSelectCameraEvent>(_readerCameraControllerSelectCamera);
    on<CameraControllerEvent>(_readerCameraController);
    on<CameraRebuildOnMountEvent>(_readerCameraRebuildOnMount);
    on<CameraCodeEvent>(_readerCameraCode);
    on<CameraMultiCodeEvent>(_readerCameraMultiCode);
    on<FileCodeEvent>(_readerFileCode);
    on<FileMultiCodeEvent>(_readerFileMultiCode);
    on<CameraFlashModeEvent>(_readerCameraFlashMode);
    on<OpenStreamEvent>(_readerStream);
    on<OpenGalleryEvent>(_readerOpenGallery);
  }

  bool isAndroid() => Theme.of(context).platform == TargetPlatform.android;

  Future<void> _readerCameraControllerInit(
      CameraControllerInitEvent event, Emitter<ReaderState> emit) async {
    await FlutterZXingPermission.checkPermission(
        enableGallery: isShowGallery,
        onSuccess: () {
          if (event.cameras == null) {
            availableCameras().then((List<CameraDescription> cameras) {
              add(CameraControllerInitEvent(
                  cameras: cameras,
                  direction: event.direction,
                  resolution: event.resolution,
                  listener: event.listener,
                  onAvailable: event.onAvailable,
                  permissionSetCallback: event.permissionSetCallback));
            });
          } else {
            _cameras = event.cameras!;
            emit(CameraControllerInitState(cameras: _cameras));
            add(CameraControllerFindCameraEvent(
                cameras: _cameras,
                direction: event.direction,
                resolution: event.resolution,
                onAvailable: event.onAvailable,
                listener: event.listener,
                permissionSetCallback: event.permissionSetCallback));
          }
        });
  }

  Future<void> _readerCameraControllerDispose(
      CameraControllerDisposeEvent event, Emitter<ReaderState> emit) async {
    if (event.listener != null) {
      _controller?.removeListener(event.listener!);
    }
    await _controller?.setFlashMode(FlashMode.off);
    await _controller?.dispose();
    _controller = null;
    bool on = false;
    add(CameraRebuildOnMountEvent(on: on));
    add(CameraControllerEvent(controller: _controller));
  }

  Future<void> _readerCameraControllerFindCamera(
      CameraControllerFindCameraEvent event, Emitter<ReaderState> emit) async {
    await FlutterZXingPermission.checkPermission(
        enableGallery: isShowGallery,
        onSuccess: () {
          List<CameraDescription> cameras = event.cameras ?? _cameras;
          if (cameras.isNotEmpty && !_cameraOn) {
            CameraDescription? cameraDescription = cameras.firstWhere(
                (element) => (element.lensDirection == event.direction),
                orElse: () => _cameras.first);
            add(CameraControllerSelectCameraEvent(
                cameraDescription: cameraDescription,
                resolution: event.resolution,
                onAvailable: event.onAvailable,
                listener: event.listener,
                permissionSetCallback: event.permissionSetCallback));
          }
        });
  }

  Future<void> _readerCameraControllerSelectCamera(
      CameraControllerSelectCameraEvent event,
      Emitter<ReaderState> emit) async {
    if (event.cameraDescription != null) {
      final CameraController? oldController = _controller;
      if (oldController != null) {
        if (event.listener != null) {
          oldController.removeListener(event.listener!);
        }
        _controller = null;
        await oldController.setFlashMode(FlashMode.off);
        await oldController.dispose();
        bool on = false;
        add(CameraRebuildOnMountEvent(on: on));
      }
      final CameraController cameraController = CameraController(
        event.cameraDescription!,
        event.resolution,
        enableAudio: false,
        imageFormatGroup:
            isAndroid() ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
      );
      if (event.listener != null) {
        cameraController.addListener(event.listener!);
      }

      try {
        await cameraController.initialize();
        await cameraController.setFlashMode(FlashMode.off);
        await cameraController.setFocusMode(FocusMode.auto);
        await cameraController.startImageStream(event.onAvailable);
        add(CameraControllerEvent(controller: cameraController));
        event.listener?.call();
        event.permissionSetCallback?.call(true, null);
      } on CameraException catch (e) {
        event.permissionSetCallback?.call(false, '${e.code}: ${e.description}');
      } catch (e) {
        event.permissionSetCallback?.call(true, 'Error: $e');
      }
    }
  }

  Future<void> _readerCameraController(
      CameraControllerEvent event, Emitter<ReaderState> emit) async {
    _controller = event.controller;
    emit(CameraControllerState(controller: _controller));
  }

  Future<void> _readerCameraCode(
      CameraCodeEvent event, Emitter<ReaderState> emit) async {
    final CodeResult result = await zxing.processCameraImage(
      event.image,
      params: event.params,
    );
    emit(CameraCodeState(result: result));
  }

  Future<void> _readerCameraRebuildOnMount(
      CameraRebuildOnMountEvent event, Emitter<ReaderState> emit) async {
    _cameraOn = event.on;
    emit(CameraRebuildOnMountState(on: event.on));
  }

  Future<void> _readerCameraMultiCode(
      CameraMultiCodeEvent event, Emitter<ReaderState> emit) async {
    final List<CodeResult> results = await zxing.processCameraImages(
      event.image,
      params: event.params,
    );
    emit(CameraMultiCodeState(result: results));
  }

  Future<void> _readerFileCode(
      FileCodeEvent event, Emitter<ReaderState> emit) async {
    final CodeResult result = await zxing.readBarcodeImagePath(
          event.file,
          params: DecodeParams(tryInverted: true),
        ) ??
        CodeResult(false, null, null, null, 0, null, false, false, 0,
            'No barcode found');
    emit(FileCodeState(result: result));
  }

  Future<void> _readerFileMultiCode(
      FileMultiCodeEvent event, Emitter<ReaderState> emit) async {
    final List<CodeResult> results = await zxing.readBarcodesImagePath(
        event.file,
        params: DecodeParams(tryInverted: true));
    emit(FileMultiCodeState(result: results));
  }

  Future<void> _readerCameraFlashMode(
      CameraFlashModeEvent event, Emitter<ReaderState> emit) async {
    await _controller?.setFlashMode(event.mode);
    emit(CameraFlashModeState(mode: event.mode));
  }

  Future<void> _readerStream(
      OpenStreamEvent event, Emitter<ReaderState> emit) async {
    if (event.isMultiScan) {
      add(CameraMultiCodeEvent(
        image: event.image,
        params: event.params,
      ));
    } else {
      add(CameraCodeEvent(
        image: event.image,
        params: event.params,
      ));
    }
  }

  Future<void> _readerOpenGallery(
      OpenGalleryEvent event, Emitter<ReaderState> emit) async {
    final XFile? file =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(OpenGalleryState(file: file));
    if (file != null) {
      if (event.isMultiScan) {
        add(FileMultiCodeEvent(
          file: file,
          params: event.params,
        ));
      } else {
        add(FileCodeEvent(
          file: file,
          params: event.params,
        ));
      }
    }
  }

  final BuildContext context;
  final FlutterZXing zxing;
  final bool isShowGallery;
  List<CameraDescription> _cameras = <CameraDescription>[];
  CameraController? _controller = null;
  bool _cameraOn = false;

  List<CameraDescription> get cameras => _cameras;
  CameraController? get controller => _controller;
  bool get cameraOn => _cameraOn;
}
