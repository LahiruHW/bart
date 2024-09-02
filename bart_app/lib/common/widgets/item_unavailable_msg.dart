import 'package:flutter/material.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/extensions/ext_trade.dart';

class ItemUnavailableMsg extends StatelessWidget {
  const ItemUnavailableMsg({
    super.key,
    required this.userID,
    required this.trade,
  });

  final String userID;
  final Trade trade;

  String getMessage() {
    if (trade.isTrader(userID)) {
      return tr('view.trade.page.item.na.1');
    }
    return tr(
      'view.trade.page.item.na.2',
      namedArgs: {'itemOwner': trade.tradedItem.itemOwner.userName},
    );
  }

  @override
  Widget build(BuildContext context) {

    final String itemNAText = getMessage();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Text(
        itemNAText,
        textAlign: TextAlign.center,
        maxLines: 2,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: BartAppTheme.red1,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
