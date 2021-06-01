import 'package:Velmie/resources/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxAcceptance extends StatelessWidget {
  final bool value;
  final String title;
  final String link;
  final Function(bool value) onChange;
  final VoidCallback onLinkTap;

  const CheckboxAcceptance({
    this.value = false,
    this.title,
    this.link,
    this.onChange,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: (value) => onChange?.call(value)),
        Expanded(
          child: Wrap(
            children: [
              if (title != null) Text('$title ', style: TextStyle(fontSize: 16.ssp, color: AppColors.primaryText)),
              if (link != null)
                GestureDetector(
                  onTap: () => onLinkTap?.call(),
                  child: Text(
                    link,
                    style: TextStyle(
                      fontSize: 16.ssp,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
