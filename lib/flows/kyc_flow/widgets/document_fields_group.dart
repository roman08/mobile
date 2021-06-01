import 'package:Velmie/common/widgets/app_buttons/button.dart';
import 'package:Velmie/flows/kyc_flow/widgets/document_field.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/strings/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocumentFieldsGroup extends StatefulWidget {
  final String title;
  final String frontId;
  final String backId;
  final String selfieId;
  final Function(String idFront, String idBack, String selfie) onSubmit;
  final bool disabled;

  const DocumentFieldsGroup({
    @required this.title,
    this.onSubmit,
    this.frontId,
    this.backId,
    this.selfieId,
    this.disabled = false,
  });

  @override
  _DocumentFieldsGroupState createState() => _DocumentFieldsGroupState();
}

class _DocumentFieldsGroupState extends State<DocumentFieldsGroup> {
  String frontId;
  String backId;
  String selfieId;
  
  @override
  void initState() {
    frontId = widget.frontId;
    backId = widget.backId;
    selfieId = widget.selfieId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(color: AppColors.secondaryText, fontSize: 16.ssp),
        ),
        SizedBox(height: 10.h),
        DocumentField(
          title: AppStrings.FRONT.tr() + ' *',
          fileId: frontId,
          disabled: widget.disabled,
          onDocumentChange: (path) => setState(() => frontId = path),
        ),
        DocumentField(
          title: AppStrings.BACK.tr(),
          fileId: backId,
          disabled: widget.disabled,
          onDocumentChange: (path) => setState(() => backId = path),
        ),
        DocumentField(
          title: AppStrings.USER_SELFIE.tr() + ' *',
          fileId: selfieId,
          disabled: widget.disabled,
          onDocumentChange: (path) => setState(() => selfieId = path),
        ),
        if (!widget.disabled) SizedBox(
          child: Button(
            title: AppStrings.SEND.tr(),
            isSupportLoading: true,
            onPressed: frontId.isNotEmpty && selfieId.isNotEmpty
                ? () => widget.onSubmit?.call(frontId, backId, selfieId)
                : null,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
