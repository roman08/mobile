import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../networking/api_constants.dart';

/// Widget for view network images
class ImageView extends StatelessWidget {
  const ImageView({
    this.imageId,
    this.fit,
    this.placeholderString,
    this.placeholderStringColor,
    this.loadPlaceholder,
    this.errorPlaceholder,
    this.borderRadius,
    this.onPressed,
  });

  final int imageId;
  final BoxFit fit;
  final String placeholderString;
  final Color placeholderStringColor;
  final Widget loadPlaceholder;
  final Widget errorPlaceholder;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(0)),
          child: imageId != null
              ? Image.network(
                  PublicApi.downloadPublicFile(imageId),
                  fit: fit ?? BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent loadingProgress,
                  ) =>
                      (loadingProgress == null)
                          ? child
                          : Center(
                              child:
                                  loadPlaceholder ?? _defaultLoadPlaceholder()),
                  errorBuilder: (
                    BuildContext context,
                    Object error,
                    StackTrace stackTrace,
                  ) =>
                      Center(
                          child:
                              errorPlaceholder ?? _defaultErrorPlaceholder()),
                )
              : Center(child: _textPlaceholder()),
        ),
      );

  Widget _textPlaceholder() => Padding(
        padding: EdgeInsets.all(4.w),
        child: Text(
          placeholderString ?? "No image",
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Get.theme.textTheme.headline3.copyWith(
              color: placeholderStringColor ??
                  Get.theme.colorScheme.secondaryVariant),
        ),
      );

  Widget _defaultLoadPlaceholder() => _textPlaceholder();

  Widget _defaultErrorPlaceholder() => _textPlaceholder();
}
