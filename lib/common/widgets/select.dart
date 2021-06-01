import 'package:Velmie/common/widgets/select_list.dart';
import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:Velmie/resources/themes/need_to_refactor_and_remove/app_colors_old.dart';
import 'package:Velmie/resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Select extends StatefulWidget {
  final String label;
  final List<SelectItem> options;
  final String value;
  final Function(String value) onChange;
  final bool disabled;
  final String placeholder;
  final VoidCallback onEmptyValueTap;

  const Select({
    this.label,
    @required this.options,
    this.value,
    this.onChange,
    this.disabled = false,
    this.placeholder,
    this.onEmptyValueTap,
  }) : assert(options != null);

  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  SelectItem value;

  @override
  void initState() {
    if (widget.value != null) {
      value = widget.options.firstWhere((element) => element.title == widget.value, orElse: () => null);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant Select oldWidget) {
    if (widget.value != null) {
      value = widget.options.firstWhere((element) => element.title == widget.value, orElse: () => null);
    }

    super.didUpdateWidget(oldWidget);
  }

  void openList() async {
    if (widget.options.isEmpty) {
      widget.onEmptyValueTap?.call();
      return;
    }

    final mappedValues = widget.options.map((e) {
      String string = e.title;

      if (e.description != null) {
        string += ' (${e.description})';
      }

      return string;
    }).toList();

    final result = await Get.to(
      SelectList(
        mappedValues,
        value == null ? null : mappedValues.firstWhere((mapped) => mapped.startsWith(value?.title), orElse: () => null),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      value = widget.options[result];
    });

    widget.onChange?.call(value.title);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: !widget.disabled ? () => openList() : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11.ssp,
                color: widget.disabled ? AppColors.primaryText.withOpacity(.7) : AppColors.primaryText,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(bottom: 3.h, top: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                value ??
                    Text(
                      widget.placeholder ?? '',
                      style: AppTextStylesOld.defaultTextStyles().r14.copyWith(
                            color: widget.disabled ? AppColors.secondaryText : AppColors.primaryText,
                          ),
                    ),
                if (!widget.disabled)
                  Container(
                    transform: Matrix4.translationValues(0, -2.h, 0),
                    child: Icon(Icons.keyboard_arrow_down, color: AppColorsOld().midShade),
                  ),
              ],
            ),
          ),
          Container(height: 1.h, color: AppColors.border)
        ],
      ),
    );
  }
}

class SelectItem extends StatelessWidget {
  final String title;
  final String description;
  final Widget icon;
  final Color color;

  const SelectItem({
    @required this.title,
    this.description,
    this.icon,
    this.color,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Container(
            height: 30.h,
            width: 30.h,
            margin: EdgeInsets.only(right: 16.w),
            child: icon,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStylesOld.defaultTextStyles().m16.copyWith(color: color ?? AppColors.primaryText),
            ),
            if (description != null)
              Text(
                description,
                style: AppTextStylesOld.defaultTextStyles().r14.copyWith(color: AppColors.primaryText),
              ),
          ],
        ),
      ],
    );
  }
}
