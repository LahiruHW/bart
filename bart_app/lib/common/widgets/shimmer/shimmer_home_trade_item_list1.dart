import 'package:flutter/material.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/home_page_expansion_panel.dart';

class ShimmerHomeTradeWidgetList1 {
  ExpansionPanelList show(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) => true,
      dividerColor: Colors.transparent,
      materialGapSize: 0,
      elevation: 0,
      children: [
        HomePageTradeExpansionPanelBuilder(
          title: "Incoming Trades",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.none,
          userID: "",
          tuteKey: BartTuteWidgetKeys.homePageIncomingTrades,
        ).build(context),
        HomePageTradeExpansionPanelBuilder(
          title: "Outgoing Trades",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.none,
          userID: "",
          tuteKey: BartTuteWidgetKeys.homePageOutgoingTrades,
        ).build(context),
        HomePageTradeExpansionPanelBuilder(
          title: "Successful",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.none,
          userID: "",
          tuteKey: BartTuteWidgetKeys.homePageTBCTrades,
        ).build(context),
      ],
    );
  }
}
