import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/home_page_expansion_panel.dart';
import 'package:flutter/material.dart';

class ShimmerHomeTradeWidgetList1 {
  ExpansionPanelList show(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) => true,
      dividerColor: Colors.transparent,
      materialGapSize: 0,
      elevation: 0,
      children: [
        const HomePageTradeExpansionPanelBuilder(
          title: "Incoming Trades",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.empty,
          userID: "",
        ).build(context),
        const HomePageTradeExpansionPanelBuilder(
          title: "Outgoing Trades",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.empty,
          userID: "",
        ).build(context),
        const HomePageTradeExpansionPanelBuilder(
          title: "Successful",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.empty,
          userID: "",
        ).build(context),
      ],
    );
  }
}
