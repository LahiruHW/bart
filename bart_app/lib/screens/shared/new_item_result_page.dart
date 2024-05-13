// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bart_app/common/widgets/result_item_tile.dart';
import 'package:bart_app/common/widgets/result_message_tile.dart';

/// A page that displays the result of a new-item-posting, for a few seconds
class NewItemResultPage extends StatefulWidget {
  const NewItemResultPage({
    super.key,
    required this.messageHeading,
    required this.message,
    required this.isSuccessful,
    required this.item,
    required this.dateCreated,
  });

  final REDIRECT_DELAY_SECONDS = 5;

  final String messageHeading;
  final String message;
  final bool isSuccessful;
  final Item item;
  final Timestamp dateCreated;

  @override
  State<NewItemResultPage> createState() => _NewItemResultPageState();
}

class _NewItemResultPageState extends State<NewItemResultPage> {
  void goBackHome() {
    Future.delayed(
      Duration(seconds: widget.REDIRECT_DELAY_SECONDS),
      () => GoRouter.of(context).go('/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    goBackHome();
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TradeResultMessageTile(
            messageHeading: widget.messageHeading,
            message: widget.message,
            isSuccessful: widget.isSuccessful,
          ),
          const SizedBox(height: 20),
          ResultItemTile(
            item: widget.item,
            // label: 'Posted by you',
            label: context.tr('newItem.confirmation.label'),
          ).animate().moveX(
                duration: 600.ms,
                begin: -500,
                end: 0,
                curve: Curves.easeInOutCubic,
              ),
        ],
      ),
    );
  }
}
