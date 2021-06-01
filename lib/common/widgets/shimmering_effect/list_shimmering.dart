import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../resources/colors/custom_color_scheme.dart';

/// Shimmering effect for loading state for lists
class ListShimmering extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w),
      child: ListView.builder(
          itemCount: 20,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Get.theme.colorScheme.lightShade,
              highlightColor: Get.theme.colorScheme.lightShade.withOpacity(0.3),
              child: _shimmering(context),
            );
          }),
    );
  }

  Widget _shimmering(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 40.h,
          height: 40.h,
          decoration:
              const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(16.w)),
                ),
              ),
              SizedBox(height: 8.h),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(16.w)),
                  ),
                ),
              ),
              SizedBox(height: 16.h)
            ],
          ),
        ),
      ],
    );
  }
}
