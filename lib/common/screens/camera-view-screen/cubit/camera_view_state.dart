part of 'camera_view_cubit.dart';

enum CameraViewStatus { setup, pending, error }

class CameraViewState {
  CameraController controller;
  List<CameraDescription> cameras;
  CameraLensDirection currentCameraDirection;
  CameraViewStatus status;

  CameraViewState({
    this.controller,
    this.cameras,
    this.currentCameraDirection = CameraLensDirection.back,
    this.status = CameraViewStatus.setup,
  });

  CameraViewState copyWith({
    CameraController controller,
    List<CameraDescription> cameras,
    CameraLensDirection currentCameraDirection,
    CameraViewStatus status,
  }) {
    return CameraViewState(
      controller: controller ?? this.controller,
      cameras: cameras ?? this.cameras,
      currentCameraDirection: currentCameraDirection ?? this.currentCameraDirection,
      status: status ?? this.status,
    );
  }

  @override
  String toString() => 'CameraViewState{controller: $controller, cameras: $cameras, '
      'currentCameraDirection: $currentCameraDirection}';
}
