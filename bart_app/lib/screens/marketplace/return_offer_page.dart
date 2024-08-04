import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/screens/shared/new_item_page.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/screens/marketplace/payment_page.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/widgets/buttons/market_tab_button.dart';

class ReturnOfferPage extends StatefulWidget {
  const ReturnOfferPage({
    super.key,
    this.returnForItem,
  });

  final Item? returnForItem;

  @override
  State<ReturnOfferPage> createState() => _ReturnOfferPageState();
}

class _ReturnOfferPageState extends State<ReturnOfferPage> {
  bool _onItemReturnPage = true;

  void _togglePage() {
    setState(() {
      _onItemReturnPage = !_onItemReturnPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BartStateProvider, TempStateProvider>(
      builder: (context, stateProvider, tempProvider, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            // the tab button row
            SizedBox.fromSize(
              size: const Size(double.infinity, 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: MarketPageTabButton(
                      title: context.tr('returnOffer.page.tab.returnItem'),
                      enabled: _onItemReturnPage,
                      onTap: _togglePage,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(context.tr('or')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: MarketPageTabButton(
                      title: context.tr('returnOffer.page.tab.returnMoney'),
                      enabled: !_onItemReturnPage,
                      onTap: _togglePage,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),

            Expanded(
              child: SizedBox.expand(
                child: _onItemReturnPage
                    ? NewItemPage(
                        isReturnOffer: true,
                        returnForItem: widget.returnForItem,
                      )
                    : PaymentPage(
                        returnForItem: widget.returnForItem!,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
