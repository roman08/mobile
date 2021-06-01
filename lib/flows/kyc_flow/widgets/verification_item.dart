import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../resources/icons/icons_svg.dart';
import '../../../resources/strings/app_strings.dart';
import '../models/tiers_result.dart';
import 'property_widget.dart';

class VerificationItem extends StatelessWidget {
  final Color tintColor;
  final Color normalColor;
  final TextStyle statusTextStyle;
  final TextStyle statusSelectedTextStyle;
  final TextStyle titleTextStyle;
  final TextStyle propertyTextStyle;

  final String title;
  final RequirementStatus status;
  final List<Requirement> requirements;
  final bool hasLine;

  final Function onTap;

  const VerificationItem({
    Key key,
    this.tintColor,
    this.normalColor,
    this.statusTextStyle,
    this.statusSelectedTextStyle,
    this.titleTextStyle,
    this.propertyTextStyle,
    this.title,
    this.status,
    this.requirements,
    this.hasLine = true,
    this.onTap,
  }) : super(key: key);

  String _getStatusName() {
    switch (this.status) {
      case RequirementStatus.approved:
        return KYCStrings.VERIFIED;
      default:
        return KYCStrings.UNVERIFIED;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 0,
      padding: EdgeInsets.zero,
      onPressed:
          this.status == RequirementStatus.notAvailable ? null : this.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: this.status == RequirementStatus.approved
                            ? tintColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: this.status == RequirementStatus.approved
                              ? this.tintColor
                              : this.normalColor,
                        ),
                      ),
                      child: this.status == RequirementStatus.approved
                          ? Container(
                              width: 24,
                              height: 24,
                              child: Center(
                                child: SvgPicture.asset(
                                  IconsSVG.check,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    if (this.hasLine)
                      Container(
                        width: 1,
                        height:
                            18 + 18 * this.requirements.length.toDouble() + 32,
                        color: this.status == RequirementStatus.approved
                            ? this.tintColor
                            : this.normalColor,
                      )
                    else
                      Container(),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _getStatusName().tr(),
                          style: this.status == RequirementStatus.approved
                              ? statusSelectedTextStyle
                              : statusTextStyle,
                        ),
                        Text(
                          this.title,
                          style: titleTextStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return PropertyWidget(
                              title: requirements[index].name,
                              status: requirements[index].status,
                              textStyle: propertyTextStyle,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 4,
                            );
                          },
                          itemCount: requirements.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: SvgPicture.asset(
              this.status == RequirementStatus.approved ||
                      this.status == RequirementStatus.pending ||
                      this.status == RequirementStatus.notAvailable
                  ? IconsSVG.lock
                  : IconsSVG.arrowRightIOSStyle,
            ),
          ),
        ],
      ),
    );
  }
}
