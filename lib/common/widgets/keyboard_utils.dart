import 'package:flutter/cupertino.dart';

bool isKeyboardVisible(BuildContext context) =>
    !(MediaQuery.of(context).viewInsets.bottom == 0.0);
