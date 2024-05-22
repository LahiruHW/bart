// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:bart_app/common/widgets/icons/icon_exchange.dart';
import 'package:bart_app/common/widgets/result_item_tile.dart';
import 'package:bart_app/common/widgets/result_message_tile.dart';

/// A page that displays the result of a trade, for a few seconds
class TradeResultPage extends StatefulWidget {
  const TradeResultPage({
    super.key,
    required this.messageHeading,
    required this.message,
    required this.isSuccessful,
    required this.item1,
    required this.item2,
    required this.dateCreated,
  });

  final REDIRECT_DELAY_SECONDS = 5;
  final String messageHeading;
  final String message;
  final bool isSuccessful;
  final Item item1;
  final Item item2;
  final Timestamp dateCreated;

  @override
  State<TradeResultPage> createState() => _TradeResultPageState();
}

class _TradeResultPageState extends State<TradeResultPage> {
  void goBackToMarket() {
    Future.delayed(
      Duration(seconds: widget.REDIRECT_DELAY_SECONDS),
      () => context.go('/market'),
    );
  }

  @override
  Widget build(BuildContext context) {
    goBackToMarket();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TradeResultMessageTile(
            messageHeading: widget.messageHeading,
            message: widget.message,
            isSuccessful: widget.isSuccessful,
          ),
          const SizedBox(height: 20),
          ResultItemTile(
            item: widget.item1,
            label: context.tr(
              'trade.confirmation.label1',
              namedArgs: {'itemOwner': widget.item1.itemOwner.userName},
            ),
          ).animate().moveX(
                duration: 600.ms,
                begin: -500,
                end: 0,
                curve: Curves.easeInOutCubic,
              ),
          const SizedBox(height: 12),
          const ExchangeIcon(),
          const SizedBox(height: 12),
          ResultItemTile(
            item: widget.item2,
            label: !widget.item2.isPayment
                ? context.tr('trade.confirmation.label2')
                : context.tr('trade.confirmation.label3'),
          ).animate().moveX(
                duration: 600.ms,
                begin: 500,
                end: 0,
                curve: Curves.easeInOutCubic,
              ),
        ],
      ),
    );
  }
}
