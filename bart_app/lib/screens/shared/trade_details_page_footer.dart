// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/screens/shared/trade_footer_tbc.dart';
import 'package:bart_app/screens/shared/trade_footer_incoming.dart';
import 'package:bart_app/screens/shared/trade_footer_outgoing.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class TradeDetailsPageFooter extends StatelessWidget {
  const TradeDetailsPageFooter({
    super.key,
    required this.userID,
    required this.trade,
    required this.tradeType,
    this.descriptionTextController,
    this.focusNode,
    required this.loadingOverlay,
    required this.isMsgSending,
    required this.whileSending,
    required this.onSent,
  });

  final Trade trade;
  final String userID;
  final FocusNode? focusNode;
  final TradeCompType tradeType;
  final TextEditingController? descriptionTextController;
  final LoadingBlockFullScreen loadingOverlay;
  final bool isMsgSending;
  final Function whileSending;
  final Function onSent;

  @override
  Widget build(BuildContext context) {
    switch (tradeType) {
      case TradeCompType.incoming:
        return IncomingTradeFooter(
          userID: userID,
          trade: trade,
          focusNode: focusNode!,
          tradeType: tradeType,
          loadingOverlay: loadingOverlay,
          isMsgSending: isMsgSending,
          whileSending: whileSending,
          onSent: onSent,
        );

      case TradeCompType.outgoing:
        return OutgoingTradeFooter(
          userID: userID,
          trade: trade,
          loadingOverlay: loadingOverlay,
          isMsgSending: isMsgSending,
          whileSending: whileSending,
          onSent: onSent,
        );

      case TradeCompType.toBeCompleted:
        return TBCTradeFooter(
          userID: userID,
          trade: trade,
          loadingOverlay: loadingOverlay,
          isMsgSending: isMsgSending,
          whileSending: whileSending,
          onSent: onSent,
        );

      case TradeCompType.tradeHistory:
        return Container();

      default:
        return Container();
    }
  }
}
