import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/screens/home/v2/home_page_v2_header.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/home_page_v2_trade_panel.dart';

class HomeTradesPage extends StatefulWidget {
  const HomeTradesPage({
    super.key,
  });

  @override
  State<HomeTradesPage> createState() => _HomeTradesPageState();
}

class _HomeTradesPageState extends State<HomeTradesPage> {
  late final TempStateProvider tempProvider;

  @override
  void initState() {
    super.initState();
    tempProvider = Provider.of<TempStateProvider>(context, listen: false);
  }

  void _handleSelection(int? selected) {
    setState(() => tempProvider.setHomeV2Index(selected!));
  }

  Widget updateDragWrapper(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (_) {
        if (_.primaryVelocity! > 0) {
          _handleSelection((tempProvider.homeV2Index + 1) % 4);
        } else {
          _handleSelection((tempProvider.homeV2Index - 1) % 4);
        }
      },
      child: Container(
        width: 1.0.sw,
        height: 0.75.sh,
        color: Colors.transparent,
      ),
    );
  }

  (String, String) _getTitles() {
    switch (tempProvider.homeV2Index) {
      case 0:
        return (
          context.tr('incoming.trades.title'),
          context.tr('no.incoming.trades'),
        );
      case 1:
        return (
          context.tr('outgoing.trades.title'),
          context.tr('no.outgoing.trades'),
        );
      case 2:
        return (
          context.tr('tbc.trades.title'),
          context.tr('no.tbc.trades'),
        );
      case 3:
        return (
          context.tr('trade.history.title'),
          context.tr('no.trade.history'),
        );
      default:
        return ('', context.tr('no.trades.at.all'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final (title, emptyContentText) = _getTitles();
    return Consumer<BartStateProvider>(
      builder: (context, provider, child) => StreamBuilder(
          stream: BartFirestoreServices.getTradeListStreamZipV2(
            provider.userProfile.userID,
          ),
          builder: (context, snapshot) {
            final List<int> unreadCountArray = [];

            if (snapshot.hasData) {
              for (final x in snapshot.data!) {
                unreadCountArray.add(x[1]);
              }
            } else {
              for (final x in [0,0,0,0]) {
                unreadCountArray.add(x);
              }
            }

            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: HomePageV2PersistentHeader(
                    segmentTitle: title,
                    onSelectionChanged: _handleSelection,
                    unreadCountArray: unreadCountArray,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  sliver: SliverStack(
                    children: [
                      SliverToBoxAdapter(child: updateDragWrapper(context)),
                      HomePageV2TradePanel(
                        title: title,
                        emptyContentText: emptyContentText,
                        snapshot: snapshot,
                        segmentIndex: tempProvider.homeV2Index,
                        userID: provider.userProfile.userID,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
