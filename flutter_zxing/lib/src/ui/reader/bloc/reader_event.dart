part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();
}

class CameraControllerInitEvent extends ReaderEvent {
  const CameraControllerInitEvent(
      {required this.cameras,
      required this.direction,
      required this.resolution,
      required this.onAvailable,
      this.listener,
      this.permissionSetCallback});

  @override
  List<Object?> get props =>
      [cameras, direction, resolution, onAvailable, listener, permissionSetCallback];

  final List<CameraDescription>? cameras;
  final CameraLensDirection direction;
  final ResolutionPreset resolution;
  final onLatestImageAvailable onAvailable;
  final VoidCallback? listener;
  final PermissionSetCallback? permissionSetCallback;
}

class CameraControllerDisposeEvent extends ReaderEvent {
  const CameraControllerDisposeEvent({
    this.listener,
  });

  @override
  List<Object?> get props => [listener];

  final VoidCallback? listener;
}

class CameraControllerFindCameraEvent extends ReaderEvent {
  const CameraControllerFindCameraEvent(
      {required this.cameras,
      required this.direction,
      required this.resolution,
      required this.onAvailable,
      this.listener,
      this.permissionSetCallback});

  @override
  List<Object?> get props =>
      [cameras, direction, resolution, onAvailable, listener, permissionSetCallback];

  final List<CameraDescription>? cameras;
  final CameraLensDirection direction;
  final ResolutionPreset resolution;
  final onLatestImageAvailable onAvailable;
  final VoidCallback? listener;
  final PermissionSetCallback? permissionSetCallback;
}

class CameraControllerSelectCameraEvent extends ReaderEvent {
  const CameraControllerSelectCameraEvent(
      {required this.cameraDescription,
      required this.resolution,
      required this.onAvailable,
      this.listener,
      this.permissionSetCallback});

  @override
  List<Object?> get props =>
      [cameraDescription, resolution, onAvailable, listener, permissionSetCallback];

  final CameraDescription? cameraDescription;
  final ResolutionPreset resolution;
  final onLatestImageAvailable onAvailable;
  final VoidCallback? listener;
  final PermissionSetCallback? permissionSetCallback;
}

class CameraControllerEvent extends ReaderEvent {
  const CameraControllerEvent({required this.controller});

  @override
  List<Object?> get props => [controller];

  final CameraController? controller;
}

class CameraRebuildOnMountEvent extends ReaderEvent {
  const CameraRebuildOnMountEvent({required this.on});

  @override
  List<Object> get props => [on];

  final bool on;
}

class CameraCodeEvent extends ReaderEvent {
  const CameraCodeEvent({required this.image, this.params});

  @override
  List<Object?> get props => [image, params];

  final CameraImage image;
  final DecodeParams? params;
}

class CameraMultiCodeEvent extends ReaderEvent {
  const CameraMultiCodeEvent({required this.image, this.params});

  @override
  List<Object?> get props => [image, params];

  final CameraImage image;
  final DecodeParams? params;
}

class FileCodeEvent extends ReaderEvent {
  const FileCodeEvent({required this.file, this.params});

  @override
  List<Object?> get props => [file, params];

  final XFile file;
  final DecodeParams? params;
}

class FileMultiCodeEvent extends ReaderEvent {
  const FileMultiCodeEvent({required this.file, this.params});

  @override
  List<Object?> get props => [file, params];

  final XFile file;
  final DecodeParams? params;
}

class CameraFlashModeEvent extends ReaderEvent {
  const CameraFlashModeEvent({required this.mode});

  @override
  List<Object> get props => [mode];

  final FlashMode mode;
}

class OpenStreamEvent extends ReaderEvent {
  const OpenStreamEvent(
      {required this.isMultiScan, required this.image, this.params});

  @override
  List<Object?> get props => [isMultiScan, image, params];

  final bool isMultiScan;
  final CameraImage image;
  final DecodeParams? params;
}

class OpenGalleryEvent extends ReaderEvent {
  const OpenGalleryEvent({required this.isMultiScan, this.params});

  @override
  List<Object?> get props => [isMultiScan, params];

  final bool isMultiScan;
  final DecodeParams? params;
}
