import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/home_page_expansion_panel.dart';
import 'package:flutter/material.dart';

class ShimmerHomeTradeWidgetList2 {
  ExpansionPanelList show(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) => true,
      dividerColor: Colors.transparent,
      materialGapSize: 0,
      elevation: 0,
      children: [
        const HomePageTradeExpansionPanelBuilder(
          title: "Completed Trade History",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.tradeHistory,
          userID: "",
        ).build(context),
      ],
    );
  }
}
