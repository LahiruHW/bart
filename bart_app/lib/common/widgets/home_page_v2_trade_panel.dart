import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:transparent_pointer/transparent_pointer.dart';
import 'package:bart_app/common/widgets/home_trade_item.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_home_trade_item.dart';

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

  Widget _dateSeparator(BuildContext context, String date) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.h,
        bottom: 16.h,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            thickness: 0.5,
            color: Theme.of(context).dividerColor,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 20,
              width: 80,
              alignment: Alignment.center,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                date,
                style: TextStyle(
                  color: Theme.of(context).dividerColor,
                  fontSize: 12.spMin,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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

    final List<Trade> trades = snapshot.data![segmentIndex][0];

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

    final firstTradeDT = trades[0].timeCreated.toDate();
    final diff = DateTime.now().difference(firstTradeDT).inDays;
    final date = diff < 1
        ? "Today"
        : diff == 1
            ? "Yesterday"
            : "${firstTradeDT.day}/${firstTradeDT.month}/${firstTradeDT.year}";

    return MultiSliver(
      children: [
        SliverToBoxAdapter(child: _dateSeparator(context, date)),
        SliverList.separated(
          itemCount: trades.length,
          itemBuilder: (context, index) {
            final trade = trades[index];
            return TransparentPointer(
              child: TradeWidget(
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
              ),
            );
          },
          separatorBuilder: (context, index) {
            final currentDT = DateTime.now();
            final Trade currentTrade = trades[index];
            final Trade nextTrade = trades[index + 1];
            final nextTradeDT = nextTrade.timeCreated.toDate();
            final showDate = !nextTrade.isSameDayAsTrade(currentTrade);
            if (showDate) {
              final diff = currentDT.difference(nextTradeDT).inDays;
              final date = diff == 0
                  ? "Today"
                  : diff == 1
                      ? "Yesterday"
                      : "${nextTradeDT.day}/${nextTradeDT.month}/${nextTradeDT.year}";
              return _dateSeparator(context, date);
            }
            return const SizedBox(height: 1);
          },
        ),
      ],
    );
  }
}
