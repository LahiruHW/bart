import 'package:bart_app/common/widgets/home_trade_item.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_home_trade_item.dart';
import 'package:go_router/go_router.dart';

class HomePageV2TradePanel extends StatelessWidget {
  const HomePageV2TradePanel({
    super.key,
    required this.title,
    required this.emptyContentText,
    required this.snapshot,
    required this.segmentIndex,
    required this.userID,
  });

  final String title;
  final String emptyContentText;
  final AsyncSnapshot snapshot;
  final int segmentIndex;
  final String userID;

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return const ShimmerHomeTradeWidget();
          },
          childCount: 10,
        ),
      );
    }

    final List<Trade> trades = snapshot.data![segmentIndex];

    if (trades.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            emptyContentText,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.surface.computeLuminance() >
                              0.5
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.6),
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.normal,
                ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final trade = trades[index];
          return TradeWidget(
            trade: trade,
            tradeType: trade.tradeCompType,
            userID: userID,
            onTap: () {
              context.push(
                '/viewTrade',
                extra: {
                  'trade': trades[index],
                  'tradeType': trade.tradeCompType,
                  'userID': userID,
                },
              );
            },
          );
        },
        childCount: trades.length,
      ),
    );
  }
}
