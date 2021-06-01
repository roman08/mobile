import 'package:flutter/material.dart';

import '../../../../resources/strings/app_strings.dart';

enum RequestOperation { all, incoming, outgoing }
enum RequestStatus { executed, pending, cancelled }
enum RequestCategory {
  add_fund,
  withdraw,
  send_money,
  request_money,
  pay_bills
}

class TransactionPurpose {
  static const String TBAOutgoing = 'tba_outgoing';
  static const String TBAIncoming = 'tba_incoming';
  static const String convertOutgoing = 'convert_outgoing';
  static const String convertIncoming = 'convert_incoming';
  static const String TBUOutgoing = 'tbu_outgoing';
  static const String TBUIncoming = 'tbu_incoming';
  static const String OWTOutgoing = 'owt_outgoing';
  static const String CFTOutgoing = 'cft_outgoing';
  static const String CFTIncoming = 'cft_incoming';
  static const String creditAccount = 'credit_account';
  static const String debitRevenue = 'debit_revenue';
  static const String debitAccount = 'debit_account';
  static const String creditRevenue = 'credit_revenue';
  static const String cardOutgoing = 'card_outgoing';
  static const String cardIncoming = 'card_incoming';
  static const String withdrawals = 'withdrawals';
}

class RequestEnums {
  static String requestStatusToString(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return AppStrings.PENDING;
      case RequestStatus.executed:
        return AppStrings.SUCCESSFUL;
      case RequestStatus.cancelled:
        return AppStrings.FAILED;
      default:
        return "";
    }
  }

  static String requestCategoryToString(RequestCategory category) {
    switch (category) {
      case RequestCategory.add_fund:
        return AppStrings.ADD_FUND;
      case RequestCategory.withdraw:
        return AppStrings.WITHDRAW;
      case RequestCategory.send_money:
        return AppStrings.SEND_MONEY;
      case RequestCategory.request_money:
        return AppStrings.REQUEST_MONEY;
      case RequestCategory.pay_bills:
        return AppStrings.PAY_BILLS;
      default:
        return "";
    }
  }

  static String requestOperationToString(RequestOperation operation) {
    switch (operation) {
      case RequestOperation.incoming:
        return AppStrings.INCOMING;
      case RequestOperation.outgoing:
        return AppStrings.OUTGOING;
      default:
        return "";
    }
  }

  static IconData requestPurposeToIcon(String purpose) {
    switch (purpose) {
      case TransactionPurpose.CFTOutgoing:
      case TransactionPurpose.TBUOutgoing:
      case TransactionPurpose.TBAOutgoing:
      case TransactionPurpose.convertOutgoing:
      case TransactionPurpose.OWTOutgoing:
        return Icons.arrow_upward;
      case TransactionPurpose.TBAIncoming:
      case TransactionPurpose.TBUIncoming:
      case TransactionPurpose.CFTIncoming:
      case TransactionPurpose.creditAccount:
      case TransactionPurpose.convertIncoming:
        return Icons.arrow_downward;
      case TransactionPurpose.cardOutgoing:
      case TransactionPurpose.cardIncoming:
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  static RequestStatus stringAsRequestStatus(String status) {
    return RequestStatus.values
        .singleWhere((element) => element.toString().split('.').last == status);
  }

  static RequestCategory stringAsRequestCategory(String status) {
    return RequestCategory.values
        .singleWhere((element) => element.toString().split('.').last == status);
  }

  static RequestOperation stringAsRequestOperation(String status) {
    return RequestOperation.values
        .singleWhere((element) => element.toString().split('.').last == status);
  }

  static RequestOperation intAsRequestOperation(int operation) {
    return RequestOperation.values[operation];
  }
}
