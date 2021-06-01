import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../resources/icons/icons_svg.dart';
import '../../../enities/common/wallet_entity.dart';

class WalletListItemPlaceholder extends StatelessWidget {
  final WalletEntity wallet;
  final bool isSelected;

  const WalletListItemPlaceholder({
    Key key,
    this.wallet,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
        visualDensity: VisualDensity.compact,
        title: Text(
          wallet.toSelectedItemString(),
          style: Get.textTheme.headline5.copyWith(
            color: Get.theme.colorScheme.onSecondary,
          ),
        ),
        trailing: isSelected
            ? SvgPicture.asset(
                IconsSVG.check,
                width: 18.w,
                height: 13.h,
                color: Get.theme.colorScheme.primary,
              )
            : const SizedBox(),
      );
}
