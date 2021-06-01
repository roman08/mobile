import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../resources/colors/custom_color_scheme.dart';

/// Shimmering effect for loading state for grid lists
class GridShimmering extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 20,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 9.h,
            crossAxisSpacing: 9.w,
          ),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: _body(context),
          ),
        ),
      );

  Widget _body(BuildContext context) => Column(
        children: [
          Expanded(child: _shimmeringHeader(context), flex: 15),
          Expanded(child: _shimmeringFooter(context), flex: 6),
        ],
      );

  Widget _shimmeringHeader(BuildContext context) => Shimmer.fromColors(
        baseColor: Get.theme.colorScheme.lightShade,
        highlightColor: Get.theme.colorScheme.lightShade.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.h),
                topRight: Radius.circular(4.h),
              ),
              color: Colors.grey,
              shape: BoxShape.rectangle),
        ),
      );

  Widget _shimmeringFooter(BuildContext context) => Shimmer.fromColors(
        baseColor: Get.theme.colorScheme.lightShade,
        highlightColor: Get.theme.colorScheme.lightShade.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.h),
              bottomRight: Radius.circular(4.h),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16.w)),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16.w)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 32.h,
                height: 32.h,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle),
              ),
            ],
          ),
        ),
      );
}
