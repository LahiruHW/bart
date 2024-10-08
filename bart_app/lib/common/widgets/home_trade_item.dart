import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/home_trade_widget_style.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';

class TradeWidget extends StatelessWidget {
  const TradeWidget({
    super.key,
    this.onTap,
    required this.tradeType,
    required this.trade,
    required this.userID,
  });

  final VoidCallback? onTap;
  final TradeCompType tradeType;
  final Trade trade;
  final String userID;

  (Color, Color, Color) getTileColors(BuildContext context) {
    final tileStyle = Theme.of(context).extension<BartTradeWidgetStyle>()!;

    switch (tradeType) {
      case TradeCompType.incoming:
        return (
          tileStyle.incomingBackgroundColour,
          tileStyle.incomingTextColour,
          tileStyle.incomingShadowColour,
        );
      case TradeCompType.outgoing:
        return (
          tileStyle.outgoingBackgroundColour,
          tileStyle.outgoingTextColour,
          tileStyle.outgoingShadowColour,
        );
      case TradeCompType.toBeCompleted:
        return (
          tileStyle.tbcBackgroundColour,
          tileStyle.tbcTextColour,
          tileStyle.tbcShadowColour,
        );
      case TradeCompType.failed:
        return (
          tileStyle.completeFailBackgroundColour,
          tileStyle.completeFailTextColour,
          tileStyle.completeFailShadowColour,
        );
      case TradeCompType.tradeHistory:
        return (
          tileStyle.tradeHistoryBackgroundColour,
          tileStyle.tradeHistoryTextColour,
          tileStyle.tradeHistoryShadowColour,
        );
      default:
        return (
          tileStyle.incomingBackgroundColour,
          tileStyle.incomingTextColour,
          tileStyle.incomingShadowColour,
        );
    }
  }

  String getTitle(Trade trade) {
    switch (tradeType) {
      case TradeCompType.incoming:
        return tr('incoming.trade.label',
            namedArgs: {'itemOwner': trade.offeredItem.itemOwner.userName});
      case TradeCompType.outgoing:
        return tr('outgoing.trade.label',
            namedArgs: {'itemOwner': trade.tradedItem.itemOwner.userName});
      case TradeCompType.toBeCompleted:
        return (userID == trade.offeredItem.itemOwner.userID)
            ? tr('successful.trade.label1',
                namedArgs: {'itemOwner': trade.tradedItem.itemOwner.userName})
            : tr('successful.trade.label2',
                namedArgs: {'itemOwner': trade.offeredItem.itemOwner.userName});
      case TradeCompType.failed:
        return (userID == trade.offeredItem.itemOwner.userID)
            ? tr('failed.trade.label1',
                namedArgs: {'itemOwner': trade.tradedItem.itemOwner.userName})
            : tr('failed.trade.label2',
                namedArgs: {'itemOwner': trade.offeredItem.itemOwner.userName});
      case TradeCompType.tradeHistory:
        return (userID == trade.offeredItem.itemOwner.userID)
            ? tr('trade.history.label1',
                namedArgs: {'itemOwner': trade.tradedItem.itemOwner.userName})
            : tr('trade.history.label2',
                namedArgs: {'itemOwner': trade.offeredItem.itemOwner.userName});

      default:
        return "You have an offer from ${trade.offeredItem.itemOwner.userName}";
    }
  }

  Color getShimmerColour(BuildContext context, TradeCompType tradeType) {
    final tradeStyle = Theme.of(context).extension<BartTradeWidgetStyle>()!;
    switch (tradeType) {
      case TradeCompType.incoming:
        return tradeStyle.incomingTextColour;
      case TradeCompType.outgoing:
        return tradeStyle.outgoingTextColour;
      case TradeCompType.toBeCompleted:
        return tradeStyle.tbcTextColour;
      case TradeCompType.tradeHistory:
        return Colors.green;
      case TradeCompType.failed:
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, textColor, shadowColor) = getTileColors(context);
    final title = getTitle(trade);
    final shimmerColor = getShimmerColour(context, tradeType);

    final tradeWidget = Container(
      margin: const EdgeInsets.only(
        top: 2,
        bottom: 10,
        left: 12,
        right: 12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 18.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(7.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 3,
            offset: const Offset(0, 0.8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: textColor,
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Text(
              trade.isRead ? context.tr('read') : context.tr("unread"),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: textColor,
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: onTap,
      child: (!trade.isRead)
          ? tradeWidget.animate().shimmer(
                color: shimmerColor,
                duration: 1000.ms,
                delay: 300.ms,
              )
          : tradeWidget,
    );
  }
}
