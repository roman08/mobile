import 'package:flutter/material.dart';

import 'kyc_flow.dart';
import 'screens/account_level_screen.dart';
import 'screens/document_preview_screen.dart';
import 'screens/enter_property_screen.dart';
import 'screens/indicator_document_screen.dart';
import 'screens/list_types_screen.dart';
import 'screens/success_screen.dart';
import 'screens/verification_group_details_screen.dart';
import 'screens/verification_screen.dart';

class KYC {
  Map<String, Widget Function(BuildContext)> routes = {
    KycFlow.ROUTE: (context) => const KycFlow(),
    AccountLevelScreen.ROUTE: (context) => AccountLevelScreen(),
    VerificationGroupDetailsScreen.ROUTE: (context) {
      final map =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      return VerificationGroupDetailsScreen(
        tierId: map['id'],
        cubit: map['bloc'],
      );
    },
    EnterPropertyScreen.ROUTE: (context) {
      final map =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      return EnterPropertyScreen(
        requirement: map['requirement'],
        cubit: map['bloc'],
      );
    },
    VerificationScreen.ROUTE: (context) {
      final map =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      return VerificationScreen(
        requirement: map['requirement'],
        bloc: map['bloc'],
      );
    },
    IndicatorDocumentScreen.ROUTE: (context) {
      final map =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      return IndicatorDocumentScreen(
        requirement: map['requirement'],
        cubit: map['bloc'],
      );
    },
    DocumentPreviewScreen.ROUTE: (context) => DocumentPreviewScreen(
          object: ModalRoute.of(context).settings.arguments,
        ),
    ListTypesScreen.LIST_TYPES_ROUTE: (context) => ListTypesScreen(
          object: ModalRoute.of(context).settings.arguments,
        ),
    SuccessScreen.ROUTE: (context) => SuccessScreen(
          title: ModalRoute.of(context).settings.arguments,
        ),
  };

  void openAccountLevel(BuildContext context) {
    Navigator.pushNamed(
      context,
      KycFlow.ROUTE,
    );
  }
}
