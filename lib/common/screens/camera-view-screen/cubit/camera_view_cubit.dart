import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';

import '../../../../app.dart';

part 'camera_view_state.dart';

class CameraViewCubit extends Cubit<CameraViewState> {
  CameraViewCubit() : super(CameraViewState());

  /// Initialization logic
  void init() async {
    /// Get available cameras list
    final cameras = await availableCameras();

    if (cameras.isNotEmpty) {
      final camera = _cameraByDirection(cameras, state.currentCameraDirection);

      if (camera == null) {
        /// Camera with initial lens direction [CameraLensDirection.back] not found
        emit(state.copyWith(status: CameraViewStatus.error));
        return;
      }

      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await controller.initialize();
      } on CameraException catch (e) {
        logger.e(e);
        emit(state.copyWith(status: CameraViewStatus.error));
      }

      emit(state.copyWith(
        controller: controller,
        cameras: cameras,
        status: CameraViewStatus.pending,
      ));
    } else {
      /// Cameras not found
      emit(state.copyWith(status: CameraViewStatus.error));
    }
  }

  /// Change direction from front to back and vice versa
  void toggleCameraDirection() async {
    emit(state.copyWith(status: CameraViewStatus.setup));

    if (state.controller != null) {
      await state.controller.dispose();
    }

    final newDirection = _toggledCameraDirection();
    final camera = _cameraByDirection(state.cameras, newDirection);
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      logger.e(e);
      emit(state.copyWith(status: CameraViewStatus.error));
    }

    emit(state.copyWith(
      controller: controller,
      currentCameraDirection: newDirection,
      status: CameraViewStatus.pending,
    ));
  }

  Future<String> takePicture() async {
    final file = await state.controller.takePicture();
    return Future.value(file.path);
  }

  void dispose() {
    state.controller.dispose();
  }

  CameraLensDirection _toggledCameraDirection() =>
      state.controller?.description?.lensDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;

  CameraDescription _cameraByDirection(List<CameraDescription> cameras, CameraLensDirection direction) =>
      cameras.firstWhere((CameraDescription camera) => camera.lensDirection == direction);
}
