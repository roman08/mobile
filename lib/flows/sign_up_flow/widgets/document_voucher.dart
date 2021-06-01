import 'dart:io';

import 'package:Velmie/common/screens/camera-view-screen/camera_view_screen.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:Velmie/resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';


class DocumentVoucher extends StatefulWidget {
    final String title;
  final Function(String filePath) onChange;

  const DocumentVoucher({
    this.title,
    this.onChange,
  });

  @override
  _DocumentVoucherState createState() => _DocumentVoucherState();
}

class _DocumentVoucherState extends State<DocumentVoucher> {
   String filePath;

  void onChange(String path) {
    setState(() => filePath = path);
    widget.onChange?.call(path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(modalPopup(context)),
      child: Column(
        children: [
          if (widget.title != null)
            Text(
              widget.title,
              style: AppTextStylesOld.defaultTextStyles().m16.copyWith(color: AppColors.primaryText),
            ),
          if (widget.title != null) SizedBox(height: 10.h),
          Container(
            height: 150.w,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border,
                width: 2.h,
              ),
              borderRadius: BorderRadius.circular(5.h),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (filePath != null)
                  Positioned.fill(
                    child: Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                const Icon(
                  Icons.photo_camera_outlined,
                  size: 80,
                  color: AppColors.border,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
 Widget modalPopup(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.SELECT_FROM_GALERY.tr(),
            style: AppTextStylesOld.defaultTextStyles().r16.copyWith(color: AppColors.primaryText),
          ),
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(
              source: ImageSource.gallery,
              imageQuality: 100,
            );
            onChange.call(pickedFile.path);
            Get.back();
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.TAKE_SHOT.tr(),
            style: AppTextStylesOld.defaultTextStyles().r16.copyWith(color: AppColors.primaryText),
          ),
          onPressed: () async {
            Get.to(
              CameraViewScreen(
                pageTitle: KYCStrings.TAKE_SHOT.tr(),
                onTakePicture: (path) {
                  onChange.call(path);
                  Get.close(2);
                },
              ),
            );
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          AppStrings.CANCEL.tr(),
          style: AppTextStylesOld.defaultTextStyles().r16.copyWith(color: AppColors.error),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }

//   Widget _modalPopup(BuildContext context) {
//     return CupertinoActionSheet(
//       actions: <Widget>[
//         CupertinoActionSheetAction(
//           child: Text(
//             KYCStrings.SELECT_FROM_GALERY.tr(),
//             // style: _style.sheetActionTextStyle,
//           ),
//           onPressed: () async {
//             final pickedFile = await ImagePicker().getImage(
//               source: ImageSource.gallery,
//               imageQuality: 100,
//             );
//             context.read<ProfileCubit>().updateVoucher(filePath: pickedFile.path);
//             Get.back();
//           },
//         ),
//         CupertinoActionSheetAction(
//           child: Text(
//             KYCStrings.TAKE_SHOT.tr(),
//             style: _style.sheetActionTextStyle,
//           ),
//           onPressed: () async {
//             Get.to(
//               CameraViewScreen(
//                 pageTitle: AppStrings.AVATAR.tr(),
//                 onTakePicture: (path) {
//                   context.read<ProfileCubit>().updateVoucher(filePath: path);

//                   // Close the action sheet and then profile screen
//                   Get.close(2);
//                 },
//               ),
//             );
//           },
//         )
//       ],
//       cancelButton: CupertinoActionSheetAction(
//         child: Text(
//           AppStrings.CANCEL.tr(),
//           style: _style.sheetCancelTextStyle,
//         ),
//         onPressed: () {
//           Get.back();
//         },
//       ),
//     );
//   }
}