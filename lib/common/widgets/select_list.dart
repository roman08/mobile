import 'package:Velmie/resources/colors/custom_color_scheme.dart';
import 'package:Velmie/resources/themes/need_to_refactor_and_remove/app_text_styles_old.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/colors/custom_color_scheme.dart';

class SelectList extends StatelessWidget {
  final List<String> values;
  final String currentValue;

  const SelectList(this.values, [this.currentValue]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: LayoutBuilder(
          builder: (context, _) {
            return Stack(
              children: <Widget>[
                ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        if (currentValue != null) GestureDetector(
                          onTap: () => onChange(currentValue),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                            title: Text(
                              currentValue,
                              textAlign: TextAlign.start,
                              style: AppTextStylesOld.defaultTextStyles().r16,
                            ),
                            trailing: Icon(Icons.check, color: Theme.of(context).colorScheme.primaryText),
                          ),
                        ),
                        if (currentValue != null) Divider(
                          thickness: 1,
                          height: 1,
                          color: Theme.of(context).colorScheme.boldShade,
                        ),
                      ],
                    ),
                    ...values.map((String value) => getSelectionListItem(value)),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getSelectionListItem(String value) {
    return Container(
      child: (value == currentValue)
          ? const SizedBox()
          : Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  title: Text(
                    value,
                    textAlign: TextAlign.start,
                    style: AppTextStylesOld.defaultTextStyles().r16,
                  ),
                  onTap: () => onChange(value),
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
              ],
            ),
    );
  }

  void onChange(String value) {
    Get.back(result: values.indexOf(value));
  }
}
