import 'package:Velmie/common/screens/camera-view-screen/cubit/camera_view_cubit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../widgets/app_bars/base_app_bar.dart';

typedef PictureCallback = void Function(String path);

class CameraViewScreen extends StatelessWidget {
  final String pageTitle;
  final PictureCallback onTakePicture;

  const CameraViewScreen({
    @required this.pageTitle,
    this.onTakePicture,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CameraViewCubit()..init(),
        child: BlocConsumer<CameraViewCubit, CameraViewState>(
          listener: (context, state) {
            if (state.status == CameraViewStatus.error) {
              Get.back();
            }
           },
          builder: (context, state) {
            return Scaffold(
              appBar: _appBar(onDirectionToggle: () => context.read<CameraViewCubit>().toggleCameraDirection()),
              body: Container(
                color: Get.theme.colorScheme.onBackground,
                child: Stack(
                  children: [
                    if (state.status == CameraViewStatus.pending &&
                        state.controller != null &&
                        state.controller.value.isInitialized)
                      Center(child: CameraPreview(state.controller)),
                    Container(
                      height: 140.h,
                      margin: EdgeInsets.only(top: 580.h),
                      padding: EdgeInsets.only(bottom: 30.h),
                      decoration: BoxDecoration(color: Get.theme.colorScheme.onBackground),
                      child: Center(
                        child: FlatButton(
                          child: SvgPicture.asset(IconsSVG.cameraButton),
                          onPressed: () => context
                              .read<CameraViewCubit>()
                              .takePicture()
                              .then((String path) => onTakePicture?.call(path)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  BaseAppBar _appBar({Function onDirectionToggle}) {
    return BaseAppBar(
      titleString: pageTitle,
      titleColor: Get.theme.colorScheme.background,
      backIconPath: IconsSVG.arrowLeftIOSStyle,
      backIconColor: Get.theme.colorScheme.background,
      backgroundColor: Get.theme.colorScheme.onBackground,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 24.w),
          child: GestureDetector(
            onTap: () => onDirectionToggle?.call(),
            child: const Icon(
              Icons.replay,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
