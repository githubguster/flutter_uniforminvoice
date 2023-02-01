enum CameraFacing {
  /// Shows back facing camera.
  back,

  /// Shows front facing camera.
  front,

  /// Unknown camera
  unknown
}

class CameraFeatures {
  CameraFeatures(this.hasFlash, this.hasBackCamera, this.hasFrontCamera);

  factory CameraFeatures.fromJson(Map<String, dynamic> features) =>
      CameraFeatures(
          features['hasFlash'] ?? false,
          features['hasBackCamera'] ?? false,
          features['hasFrontCamera'] ?? false);

  final bool hasFlash;
  final bool hasFrontCamera;
  final bool hasBackCamera;
}
