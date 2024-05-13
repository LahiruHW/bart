import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:bart_app/common/utility/bart_router.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/home_page_expansion_panel.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_home_trade_item_list1.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_home_trade_item_list2.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isITExpanded = true; // for incoming trades expansion panel
  bool isOTExpanded = true; // outgoing trades ""
  bool isSTExpanded = true; // successful trades ""
  bool isFTExpanded = true; // trade history ""

  void handleExpansion1(int index, bool isExpanded) {
    switch (index) {
      case 0:
        setState(() => isITExpanded = isExpanded);
        break;
      case 1:
        setState(() => isOTExpanded = isExpanded);
        break;
      case 2:
        setState(() => isSTExpanded = isExpanded);
        break;
      case 3:
        setState(() => isFTExpanded = isExpanded);
        break;
      default:
        break;
    }
  }

  void handleExpansion2(int index, bool isExpanded) {
    switch (index) {
      case 0:
        setState(() => isFTExpanded = isExpanded);
        break;
      default:
        break;
    }
  }

  Widget buildHeader(
    BuildContext context,
    bool isExpanded, {
    String title = "",
    int count = 0,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10.0 + 5.0,
        bottom: 8.0,
        top: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            // 'Incoming Trades',
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                              .colorScheme
                              .background
                              .computeLuminance() >
                          0.5
                      ? Colors.black
                      : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            // '3',
            "$count",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                              .colorScheme
                              .background
                              .computeLuminance() >
                          0.5
                      ? Colors.black
                      : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BartStateProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 10.0,
          bottom: 10.0,
        ),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.only(
                // left: 5.0,
                // right: 5.0,
                bottom: 5.0,
              ),
              decoration: BoxDecoration(
                // color: Colors.white,
                color: Theme.of(context)
                            .colorScheme
                            .background
                            .computeLuminance() >
                        0.5
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder(
                stream: BartFirestoreServices.getTradeListStreamZip(
                  provider.userProfile.userID,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ShimmerHomeTradeWidgetList1().show(context);
                  }

                  final trades = snapshot.data!;

                  return ExpansionPanelList(
                    expansionCallback: handleExpansion1,
                    dividerColor: Colors.transparent,
                    materialGapSize: 0,
                    elevation: 0,
                    children: [
                      HomePageTradeExpansionPanelBuilder(
                        title: context.tr('incoming.trades.title'),
                        tradeList: snapshot.hasData ? trades[0] : [],
                        // tradeList: trades[0],
                        isExpanded: isITExpanded,
                        tradeType: TradeCompType.incoming,
                        userID: provider.userProfile.userID,
                      ).build(context),
                      HomePageTradeExpansionPanelBuilder(
                        title: context.tr('outgoing.trades.title'),
                        tradeList: snapshot.hasData ? trades[1] : [],
                        // tradeList: trades[1],
                        isExpanded: isOTExpanded,
                        tradeType: TradeCompType.outgoing,
                        userID: provider.userProfile.userID,
                      ).build(context),
                      HomePageTradeExpansionPanelBuilder(
                        title: context.tr('successful.title'),
                        tradeList: snapshot.hasData ? trades[2] : [],
                        // tradeList: trades[2],
                        isExpanded: isSTExpanded,
                        tradeType: TradeCompType.successful,
                        userID: provider.userProfile.userID,
                      ).build(context),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BartMaterialButton(
                  label: context.tr('home.btn.go.to.market'),
                  icon: Icons.arrow_forward_rounded,
                  // onPressed: () => GoRouter.of(context).go('/market'),
                  onPressed: () => context.go('/market'),
                  // onPressed: () =>
                  //     BartFirestoreServices.addPropertyToCollection(
                  //   BartFirestoreServices.itemCollection,
                  //   {'isPayment': false},
                  // ),
                ),
                const SizedBox(width: 10),
                BartMaterialButton(
                  // label: "List an item\nto trade",
                  label: context.tr('home.btn.list.item'),
                  icon: Icons.add_circle,
                  // onPressed: () => BartRouter.pushPage(context, 'newItem', null),
                  onPressed: () => context.push('/home/newItem'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.only(
                bottom: 5.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Theme.of(context)
                            .colorScheme
                            .background
                            .computeLuminance() >
                        0.5
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder(
                stream: BartFirestoreServices.getCompletedTradeListStream(
                  provider.userProfile.userID,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ShimmerHomeTradeWidgetList2().show(context);
                  }
                  final trades = snapshot.data!;
                  return ExpansionPanelList(
                    expansionCallback: handleExpansion2,
                    dividerColor: Colors.transparent,
                    materialGapSize: 0,
                    elevation: 0,
                    children: [
                      HomePageTradeExpansionPanelBuilder(
                        title: context.tr('trade.history.title'),
                        tradeList: snapshot.hasData ? trades : [],
                        isExpanded: isFTExpanded,
                        tradeType: TradeCompType.tradeHistory,
                        userID: provider.userProfile.userID,
                      ).build(context),
                    ],
                  );
                },
              ),
            ),
          ]
              .animate(
                delay: 300.ms,
                interval: 50.ms,
              )
              .fadeIn(
                duration: 400.ms,
                curve: Curves.easeInOutCubic,
              ),
        ),
      ),
    );
  }
}
