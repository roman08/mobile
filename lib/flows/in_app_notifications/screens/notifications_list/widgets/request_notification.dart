import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/app_buttons/button.dart';
import '../../../../transfer_money/send/send_by_request/entities/transfer_link_entity.dart';
import '../../../../transfer_money/send/send_by_request/screens/send_by_request_screen.dart';
import '../../../bloc/request_notifications_bloc.dart';

class RequestNotification extends StatelessWidget {
  final TransferByRequestEntity transfer;
  final Uint8List avatar;
  final RequestNotificationsBloc requestNotificationsBloc;

  const RequestNotification({
    this.transfer,
    this.avatar,
    this.requestNotificationsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8.5,
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(.35),
              shape: BoxShape.circle,
            ),
            child: avatar == null
                ? Center(
                    child: Text(
                      transfer.username
                          .trim()
                          .split(' ')
                          .map((e) => e[0].toUpperCase())
                          .join(''),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  )
                : FittedBox(
                    child: Image.memory(avatar),
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              '${transfer.username} requested ${transfer.amount} ${transfer.currencyCode} from you',
              style: const TextStyle(
                color: Colors.black,
                height: 1.3,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            height: 28,
            child: Button(
              title: 'Send money',
              onPressed: () {
                Get.to(SendByRequestScreen(
                  transferData: transfer,
                  requestNotificationBloc: requestNotificationsBloc,
                ));
              },
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () => requestNotificationsBloc
                .deleteNotification(transfer.moneyRequestId),
            child: const Icon(
              Icons.close,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
