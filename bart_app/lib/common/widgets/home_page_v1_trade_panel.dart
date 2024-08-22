import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/home_trade_item.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_home_trade_item.dart';

class HomePageV1TradePanelBuilder {
  const HomePageV1TradePanelBuilder({
    required this.title,
    required this.tradeList,
    required this.isExpanded,
    required this.tradeType,
    required this.userID,
    this.tuteKey,
  });

  final String title;
  final String userID;
  final bool isExpanded;
  final List<Trade> tradeList;
  final TradeCompType tradeType;
  final GlobalKey? tuteKey;

  String getEmptyContentText(TradeCompType tradeType) {
    switch (tradeType) {
      case TradeCompType.incoming:
        return tr("no.incoming.trades");
      case TradeCompType.outgoing:
        return tr("no.outgoing.trades");
      case TradeCompType.toBeCompleted:
        return tr('no.tbc.trades');
      case TradeCompType.failed:
        return tr('no.failed.trades');
      case TradeCompType.tradeHistory:
        return tr('no.trade.history');
      default:
        return tr('no.trades.at.all');
    }
  }

  Widget buildHeader(
    BuildContext context,
    bool isExpanded, {
    String title = "",
    int count = 0,
  }) {
    return Container(
      key: tuteKey,
      padding: const EdgeInsets.only(
        left: 10.0 + 5.0,
        bottom: 8.0,
        top: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 0.65.sw,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          Text(
            "$count",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                              .colorScheme
                              .surface
                              .computeLuminance() >
                          0.5
                      ? Colors.black
                      : Colors.white,
                  fontSize: 19.spMin,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel build(BuildContext context) {
    return ExpansionPanel(
      isExpanded: isExpanded,
      canTapOnHeader: true,
      // backgroundColor: Theme.of(context).cardColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      headerBuilder: (context, isExpanded) => buildHeader(
        context,
        isExpanded,
        title: title,
        count: tradeList.isNotEmpty ? tradeList.length : 0,
      ),
      body: Column(
        children: tradeList.isNotEmpty // maybe implement the view limiter here?
            ? tradeList
                .map(
                  (trade) => TradeWidget(
                    userID: userID,
                    trade: trade,
                    tradeType: tradeType,
                    onTap: () {
                      context.push(
                        '/viewTrade',
                        extra: {
                          'trade': trade,
                          'tradeType': tradeType,
                          'userID': userID,
                        },
                      );
                    },
                  ),
                )
                .toList()
            : tradeType == TradeCompType.none
                ? [
                    const ShimmerHomeTradeWidget(),
                    const ShimmerHomeTradeWidget(),
                  ]
                : [
                    Padding(
                      padding: EdgeInsets.all(8.spMin),
                      child: Text(
                        getEmptyContentText(tradeType),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .computeLuminance() >
                                      0.5
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6),
                              fontSize: 14.spMin,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
      ),
    );
  }
}
