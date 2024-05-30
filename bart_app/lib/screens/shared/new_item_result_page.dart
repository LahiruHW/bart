// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
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

  final REDIRECT_DELAY_SECONDS = 4;

  final String messageHeading;
  final String message;
  final bool isSuccessful;
  final Item item;
  final Timestamp dateCreated;

  @override
  State<NewItemResultPage> createState() => _NewItemResultPageState();
}

class _NewItemResultPageState extends State<NewItemResultPage>
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
  
  // check if the current route begins with "/home" or "/market" and go to that route
  void goBackHome() {
    final route = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (route.startsWith('/home')) {
      context.go('/home');
    } else if (route.startsWith('/market')) {
      context.go('/market');
    } else {
      context.go('/home');
    }
  }

  void _startTimer() {
    debugPrint('------------------ Timer started');
    _timer?.cancel();
    _loadAnimController.forward();
    _timer = Timer(
      Duration(seconds: widget.REDIRECT_DELAY_SECONDS),
      goBackHome,
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
        Padding(
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
                label: context.tr('newItem.confirmation.label'),
                onTap: null,
              ).animate().moveX(
                    duration: 600.ms,
                    begin: -500,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                  ),
            ],
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
