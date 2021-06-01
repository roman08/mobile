import 'package:Velmie/common/screens/camera-view-screen/camera_view_screen.dart';
import 'package:Velmie/flows/kyc_flow/cubit/document_cubit.dart';
import 'package:Velmie/flows/kyc_flow/repository/kyc_repository.dart';
import 'package:Velmie/flows/kyc_flow/screens/image_view_screen.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

class DocumentField extends StatefulWidget {
  final String title;
  final Function(String path) onDocumentChange;
  final String fileId;
  final bool disabled;

  const DocumentField({
    @required this.title,
    this.onDocumentChange,
    this.fileId,
    this.disabled = false,
  }) : assert(title != null);

  @override
  _DocumentFieldState createState() => _DocumentFieldState();
}

class _DocumentFieldState extends State<DocumentField> {
  void onLoad(String path) {
    if (path == null) {
      return;
    }
    widget.onDocumentChange?.call(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentCubit(kycRepository: context.read<KycRepository>()),
      child: BlocConsumer<DocumentCubit, DocumentState>(
        listener: (context, state) {
          if (state is DocumentLoaded) {
            Get.to(ImageViewScreen(data: state.data));
          }
        },
        builder: (context, state) => Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: .5.h,
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              if (widget.fileId != null && widget.fileId.isNotEmpty) {
                context.read<DocumentCubit>().loadDocument(widget.fileId);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: widget.disabled ? AppColors.primaryText.withOpacity(.7) : AppColors.primaryText,
                      fontSize: 15.ssp,
                    ),
                  ),
                ),
                if (!widget.disabled) GestureDetector(
                  onTap: () {
                    if (widget.fileId == null || widget.fileId.isEmpty) {
                      return Get.bottomSheet(modalPopup(context, (path) => onLoad(path)));
                    }

                    widget.onDocumentChange?.call('');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: widget.fileId != null && widget.fileId.isNotEmpty
                        ? const Icon(Icons.delete_forever_rounded, color: AppColors.error)
                        : const Icon(Icons.add, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget modalPopup(BuildContext context, Function(String path) onLoad) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.SELECT_FROM_GALERY.tr(),
            style: const TextStyle(color: AppColors.primaryText),
          ),
          onPressed: () async {
            final pickedFile = await ImagePicker().getImage(
              source: ImageSource.gallery,
              imageQuality: 100,
            );
            onLoad(pickedFile?.path);
            Get.back();
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            KYCStrings.TAKE_SHOT.tr(),
            style: const TextStyle(color: AppColors.primaryText),
          ),
          onPressed: () async {
            Get.to(
              CameraViewScreen(
                pageTitle: widget.title,
                onTakePicture: (path) {
                  onLoad(path);
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
          style: const TextStyle(color: AppColors.primaryText),
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
