part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();
}

class CameraControllerInitState extends ReaderState {
  const CameraControllerInitState({required this.cameras});

  @override
  List<Object?> get props => [cameras];

  final List<CameraDescription> cameras;
}

class CameraControllerFindCameraState extends ReaderState {
  const CameraControllerFindCameraState({required this.cameras});

  @override
  List<Object?> get props => [cameras];

  final List<CameraDescription> cameras;
}

class CameraControllerState extends ReaderState {
  const CameraControllerState({required this.controller});

  @override
  List<Object?> get props => [controller];

  final CameraController? controller;
}

class CameraRebuildOnMountState extends ReaderState {
  const CameraRebuildOnMountState({required this.on});

  @override
  List<Object> get props => [on];

  final bool on;
}

class CameraCodeState extends ReaderState {
  const CameraCodeState({required this.result});

  @override
  List<Object> get props => [result];

  final CodeResult result;
}

class CameraMultiCodeState extends ReaderState {
  const CameraMultiCodeState({required this.result});

  @override
  List<Object> get props => [result];

  final List<CodeResult> result;
}

class FileCodeState extends ReaderState {
  const FileCodeState({required this.result});

  @override
  List<Object?> get props => [result];

  final CodeResult? result;
}

class FileMultiCodeState extends ReaderState {
  const FileMultiCodeState({required this.result});

  @override
  List<Object> get props => [result];

  final List<CodeResult> result;
}

class CameraFlashModeState extends ReaderState {
  const CameraFlashModeState({required this.mode});

  @override
  List<Object> get props => [mode];

  final FlashMode mode;
}

class OpenGalleryState extends ReaderState {
  const OpenGalleryState({required this.file});

  @override
  List<Object?> get props => [file];

  final XFile? file;
}
