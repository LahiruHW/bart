import 'package:flutter/material.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/home_page_expansion_panel.dart';

class ShimmerHomeTradeWidgetList2 {
  ExpansionPanelList show(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) => true,
      dividerColor: Colors.transparent,
      materialGapSize: 0,
      elevation: 0,
      children: [
        HomePageTradeExpansionPanelBuilder(
          title: "Completed Trade History",
          tradeList: [],
          isExpanded: true,
          tradeType: TradeCompType.tradeHistory,
          userID: "",
          tuteKey: BartTuteWidgetKeys.homePageSTH,
        ).build(context),
      ],
    );
  }
}
