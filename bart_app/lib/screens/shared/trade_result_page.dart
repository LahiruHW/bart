// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
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

  final REDIRECT_DELAY_SECONDS = 4;
  final String messageHeading;
  final String message;
  final bool isSuccessful;
  final Item item1;
  final Item item2;
  final Timestamp dateCreated;

  @override
  State<TradeResultPage> createState() => _TradeResultPageState();
}

class _TradeResultPageState extends State<TradeResultPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  double currentAnimVal = 0.0;
  late final AnimationController _loadAnimController;

  @override
  void initState() {
    super.initState();
    _loadAnimController = AnimationController(
      vsync: this,
      duration: (widget.REDIRECT_DELAY_SECONDS).seconds,
    )..addListener(updateAnimation);
    _loadAnimController.drive(
      CurveTween(curve: Curves.easeInOutCubic),
    );
    _startTimer();
  }

  void updateAnimation() => setState(
        () => currentAnimVal = _loadAnimController.value,
      );

  void goBackToMarket() => context.go('/market');

  void _startTimer() {
    debugPrint('------------------ Timer started');
    _timer?.cancel();
    _loadAnimController.forward();
    _timer = Timer(
      Duration(seconds: widget.REDIRECT_DELAY_SECONDS),
      goBackToMarket,
    );
  }

  void _stopTimer() {
    if (kDebugMode) debugPrint('------------------ Timer stopped');
    _timer?.cancel();
    _loadAnimController.stop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = (_timer != null);
    final shouldEnable = TickerMode.of(context);
    if (enabled != shouldEnable) {
      (shouldEnable) ? _startTimer() : _stopTimer();
    }
  }

  @override
  void dispose() {
    _loadAnimController.removeListener(updateAnimation);
    _loadAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
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
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            width: screenwidth * currentAnimVal,
            height: 5,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
