import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../networking/api_constants.dart';

/// Widget for view network images
class CircleImageView extends StatelessWidget {
  CircleImageView({
    @required this.radius,
    @required this.placeholderString,
    this.imageId,
    this.placeholderStringColor,
    this.backgroundColor,
    this.onPressed,
    this.fit,
    this.loadPlaceholder,
    this.errorPlaceholder,
  })  : assert(radius != null),
        assert(placeholderString != null && placeholderString.isNotEmpty);

  final int imageId;
  final BoxFit fit;
  final double radius;
  final Color backgroundColor;
  final String placeholderString;
  final Color placeholderStringColor;
  final Widget loadPlaceholder;
  final Widget errorPlaceholder;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: ClipOval(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            color: backgroundColor ?? Get.theme.colorScheme.surface,
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
                                child: loadPlaceholder ??
                                    _defaultLoadPlaceholder()),
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
        ),
      );

  Widget _textPlaceholder() => Text(
        placeholderString[0],
        style: Get.theme.textTheme.headline3.copyWith(
            color: placeholderStringColor ??
                Get.theme.colorScheme.secondaryVariant),
      );

  Widget _defaultLoadPlaceholder() => _textPlaceholder();

  Widget _defaultErrorPlaceholder() => _textPlaceholder();
}
