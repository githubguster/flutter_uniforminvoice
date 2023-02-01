import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'bloc/reader_bloc.dart';
import '../../../flutter_zxing.dart';

typedef ScanCallBack = void Function(CodeResult);
typedef MultiScanCallBack = void Function(List<CodeResult>);
typedef CameraCallBack = void Function(CameraController?);
typedef PermissionSetCallback = void Function(bool isPermission, String? error);

class PositioneRect {
  const PositioneRect({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
}

class ZXingReaderWidget extends StatefulWidget {
  const ZXingReaderWidget({
    super.key,
    this.zxing = const FlutterZXing(),
    this.onScan,
    this.onScanFailure,
    this.onMultiScan,
    this.onMultiScanFailure,
    this.onControllerCreated,
    this.onPermissionSet,
    this.cameraFacing = CameraFacing.back,
    this.isMultiScan = false,
    this.codeFormat = Format.any,
    this.tryHarder = false,
    this.tryInverted = false,
    this.isShowScannerOverlay = true,
    this.scannerOverlay,
    this.isShowFlashlight = true,
    this.flashlightPosition = const PositioneRect(
      bottom: 20,
      left: 20,
    ),
    this.galleryPosition = const PositioneRect(
      bottom: 20,
      right: 20,
    ),
    this.isShowGallery = true,
    this.allowPinchZoom = true,
    this.scanDelay = const Duration(milliseconds: 1000), // 1000ms delay
    this.scanDelaySuccess = const Duration(milliseconds: 1000), // 1000ms delay
    this.cropPercent = 0.5, // 50% of the screen
    this.resolution = ResolutionPreset.high,
    this.loading,
  });

  @override
  State<StatefulWidget> createState() => _ZXingReaderWidgetState();

  /// ZXing-C++ library
  final FlutterZXing zxing;

  /// Called when a code is detected
  final ScanCallBack? onScan;

  /// Called when a code is not detected
  final ScanCallBack? onScanFailure;

  /// Called when a code is detected
  final MultiScanCallBack? onMultiScan;

  /// Called when a code is not detected
  final MultiScanCallBack? onMultiScanFailure;

  /// Called when the camera controller is created
  final CameraCallBack? onControllerCreated;

  /// Called when the permission is set
  final PermissionSetCallback? onPermissionSet;

  /// Can either be CameraFacing.front or CameraFacing.back
  final CameraFacing cameraFacing;

  /// Allow multiple scans
  final bool isMultiScan;

  /// Code format to scan
  final Format codeFormat;

  /// Try harder to detect a code
  final bool tryHarder;

  /// Try to detect inverted code
  final bool tryInverted;

  /// Show cropping rect
  final bool isShowScannerOverlay;

  /// Custom scanner overlay
  final ScannerOverlayShape? scannerOverlay;

  /// Show flashlight button
  final bool isShowFlashlight;
  final PositioneRect flashlightPosition;

  /// Show gallery button
  final bool isShowGallery;
  final PositioneRect galleryPosition;

  /// Allow pinch zoom
  final bool allowPinchZoom;

  /// Delay between scans when no code is detected
  final Duration scanDelay;

  /// Crop percent of the screen
  final double cropPercent;

  /// Camera resolution
  final ResolutionPreset resolution;

  /// Delay between scans when a code is detected
  final Duration scanDelaySuccess;

  /// Loading widget while camera is initializing. Default is a black screen
  final Widget? loading;
}

class _ZXingReaderWidgetState extends State<ZXingReaderWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  ReaderBloc? bloc;

  double _zoom = 1.0;
  double _scaleFactor = 1.0;
  double _maxZoomLevel = 1.0;
  double _minZoomLevel = 1.0;

  // true when code detecting is ongoing
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initStateAsync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        bloc?.add(CameraControllerFindCameraEvent(
            cameras: null,
            direction: widget.cameraFacing == CameraFacing.front
                ? CameraLensDirection.front
                : CameraLensDirection.back,
            resolution: widget.resolution,
            onAvailable: processImageStream,
            listener: rebuildOnMount,
            permissionSetCallback: permissionSetCallback));
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        bloc?.add(CameraControllerDisposeEvent(listener: rebuildOnMount));
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) =>
                  bloc = ReaderBloc(context: context, zxing: widget.zxing, isShowGallery: widget.isShowGallery))
        ],
        child: BlocBuilder<ReaderBloc, ReaderState>(builder: (context, state) {
          final bool isCameraReady = bloc!.cameras.isNotEmpty &&
              bloc!.cameraOn &&
              bloc!.controller != null &&
              bloc!.controller!.value.isInitialized;
          debugPrint('isCameraReady: $isCameraReady');
          final Size size = MediaQuery.of(context).size;
          final double cameraMaxSize = max(size.width, size.height);
          final double cropSize =
              min(size.width, size.height) * widget.cropPercent;
          if (state is CameraControllerState) {
            CameraController? controller = bloc!.controller;
            controller
                ?.getMaxZoomLevel()
                .then((double value) => _maxZoomLevel = value);
            controller
                ?.getMinZoomLevel()
                .then((double value) => _minZoomLevel = value);
          } else if (state is CameraCodeState) {
            CodeResult result = state.result;
            if (result.isValid) {
              widget.onScan?.call(result);
            } else {
              widget.onScanFailure?.call(result);
            }
          } else if (state is CameraMultiCodeState) {
            List<CodeResult> results = state.result;
            if (results.isNotEmpty) {
              widget.onMultiScan?.call(results);
            } else {
              widget.onMultiScanFailure?.call(results);
            }
          } else if (state is FileCodeState) {
            CodeResult result = state.result ??
                CodeResult(false, null, null, null, null, null, false, false, 0,
                    'Barcode not found.');
            if (result.isValid) {
              widget.onScan?.call(result);
            } else {
              widget.onScanFailure?.call(result);
            }
          } else if (state is FileMultiCodeState) {
            List<CodeResult> results = state.result;
            if (results.isNotEmpty) {
              widget.onMultiScan?.call(results);
            } else {
              widget.onMultiScanFailure?.call(results);
            }
          }

          return Stack(
            children: <Widget>[
              if (!isCameraReady && widget.loading != null) widget.loading!,
              if (isCameraReady)
                SizedBox(
                  width: cameraMaxSize,
                  height: cameraMaxSize,
                  child: ClipRRect(
                    child: OverflowBox(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: cameraMaxSize,
                          child: CameraPreview(
                            bloc!.controller!,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.isShowScannerOverlay)
                Container(
                  decoration: ShapeDecoration(
                      shape: widget.scannerOverlay ??
                          ScannerOverlayShape(
                              borderColor: Theme.of(context).primaryColor,
                              cutOutSize: cropSize)),
                ),
              if (widget.allowPinchZoom)
                GestureDetector(
                  onScaleStart: (ScaleStartDetails details) {
                    _zoom = _scaleFactor;
                  },
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    _scaleFactor = (_zoom * details.scale)
                        .clamp(_minZoomLevel, _maxZoomLevel);
                    bloc!.controller?.setZoomLevel(_scaleFactor);
                  },
                ),
              if (widget.isShowFlashlight && isCameraReady)
                Positioned(
                  top: widget.flashlightPosition.top,
                  bottom: widget.flashlightPosition.bottom,
                  left: widget.flashlightPosition.left,
                  right: widget.flashlightPosition.right,
                  child: FloatingActionButton(
                      onPressed: () {
                        FlashMode mode = bloc!.controller!.value.flashMode;
                        if (mode == FlashMode.torch) {
                          mode = FlashMode.off;
                        } else {
                          mode = FlashMode.torch;
                        }
                        bloc?.add(CameraFlashModeEvent(mode: mode));
                      },
                      backgroundColor: Colors.black26,
                      child: _FlashIcon(
                          flashMode: bloc!.controller?.value.flashMode ??
                              FlashMode.off)),
                ),
              if (widget.isShowGallery)
                Positioned(
                  top: widget.galleryPosition.top,
                  bottom: widget.galleryPosition.bottom,
                  left: widget.galleryPosition.left,
                  right: widget.galleryPosition.right,
                  child: FloatingActionButton(
                    onPressed: () async {
                      processImagePath();
                    },
                    child: const Icon(Icons.image),
                  ),
                ),
            ],
          );
        }));
  }

  @override
  void dispose() {
    widget.zxing.stopCameraProcessing();
    bloc?.add(CameraControllerDisposeEvent(listener: rebuildOnMount));
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isAndroid() => Theme.of(context).platform == TargetPlatform.android;

  void rebuildOnMount() {
    if (mounted) {
      bool on = true;
      bloc?.add(CameraRebuildOnMountEvent(on: on));
    }
  }

  void permissionSetCallback(bool isPermission, String? error) {
    if (error != null) {
      debugPrint(error);
    }
    widget.onPermissionSet?.call(isPermission, error);
  }

  Future<void> initStateAsync() async {
    // Spawn a new isolate
    await widget.zxing.startCameraProcessing();
    bloc?.add(CameraControllerInitEvent(
        cameras: null,
        direction: widget.cameraFacing == CameraFacing.front
            ? CameraLensDirection.front
            : CameraLensDirection.back,
        resolution: widget.resolution,
        onAvailable: processImageStream,
        listener: rebuildOnMount,
        permissionSetCallback: permissionSetCallback));
  }

  Future<void> processImageStream(CameraImage image) async {
    if (!_isProcessing) {
      _isProcessing = true;
      try {
        final double cropPercent =
            widget.isShowScannerOverlay ? widget.cropPercent : 0;
        final int cropSize =
            (min(image.width, image.height) * cropPercent).round();
        final DecodeParams params = DecodeParams(
          format: widget.codeFormat,
          cropWidth: cropSize,
          cropHeight: cropSize,
          tryHarder: widget.tryHarder,
          tryInverted: widget.tryInverted,
          isMultiScan: widget.isMultiScan,
        );

        if (widget.isMultiScan) {
          bloc?.add(CameraMultiCodeEvent(image: image, params: params));
        } else {
          bloc?.add(CameraCodeEvent(image: image, params: params));
        }
      } on FileSystemException catch (e) {
        debugPrint(e.message);
      } catch (e) {
        debugPrint(e.toString());
      }
      await Future<void>.delayed(widget.scanDelay);
      _isProcessing = false;
    }
  }

  Future<void> processImagePath() async {
    bloc?.add(OpenGalleryEvent(
        isMultiScan: widget.isMultiScan,
        params: DecodeParams(tryInverted: true)));
  }
}

class _FlashIcon extends StatelessWidget {
  const _FlashIcon({required this.flashMode});
  final FlashMode flashMode;

  @override
  Widget build(BuildContext context) {
    switch (flashMode) {
      case FlashMode.torch:
        return const Icon(Icons.flash_on);
      case FlashMode.off:
        return const Icon(Icons.flash_off);
      case FlashMode.always:
        return const Icon(Icons.flash_on);
      case FlashMode.auto:
        return const Icon(Icons.flash_auto);
    }
  }
}
