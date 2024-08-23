import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/screens/home/v2/home_page_v2_header.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
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

  void _handleSelection(Set<int> selected) {
    setState(() => tempProvider.setHomeV2Index(selected));
  }

  (String, String) _getTitles() {
    switch (tempProvider.homeV2Index.first) {
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
      builder: (context, provider, child) => CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: HomePageV2PersistentHeader(
              segmentTitle: title,
              onSelectionChanged: _handleSelection,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: StreamBuilder(
              stream: BartFirestoreServices.getTradeListStreamZipV2(
                provider.userProfile.userID,
              ),
              builder: (context, snapshot) {
                return HomePageV2TradePanel(
                  title: title,
                  emptyContentText: emptyContentText,
                  snapshot: snapshot,
                  multiArrayIndex: tempProvider.homeV2Index.first,
                  userID: provider.userProfile.userID,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
