import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/styles/bart_payment_page_style.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/currency_dropdown_menu.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.returnForItem,
  });

  final Item returnForItem;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<String> currencyList = ["€"]; // ["\$", "€"];
  late String currencyUnit;
  late String amount;
  late final TextEditingController _amountController;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    currencyUnit = currencyList[0];
    _amountController = TextEditingController();
  }

  bool validateAmount() {
    final amount = _amountController.text;
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
          message: context.tr('returnOffer.page.amount.snackbar1'),
          backgroundColor: Colors.red,
          icon: Icons.info,
        ).build(context),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentPageStyle =
        Theme.of(context).extension<BartPaymentPageStyle>()!;
    final stateProvider =
        Provider.of<BartStateProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                context.tr('returnOffer.page.amount.header'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: BartAppTheme.red1,
                      fontSize: 25,
                    ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10,
                ),
                child: TextField(
                  maxLines: 1,
                  minLines: 1,
                  controller: _amountController,
                  style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 50.sp,
                    color: paymentPageStyle.textFieldTextColor,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "0.00",
                    hintFadeDuration: const Duration(milliseconds: 500),
                    hintStyle: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 50.sp,
                    ),
                    fillColor: paymentPageStyle.textFieldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 10,
                    ),

                    // drop down menu to select currency
                    prefixIcon: CurrencyDropDownMenu(
                      currencyList: currencyList,
                      onChanged: (String? newValue) {
                        setState(() => currencyUnit = newValue!);
                      },
                      selectedCurrency: currencyUnit,
                    ),

                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0.0),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: BartAppTheme.red1,
                        width: 0.0,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),

              // CONTINUE BUTTON HERE!!

              const SizedBox(height: 50),

              Center(
                child: SizedBox(
                  width: 150,
                  height: 75,
                  child: BartMaterialButton(
                    label: context.tr('returnOffer.page.btn.continue'),
                    onPressed: () {
                      // 0. validate the amount
                      if (!validateAmount()) return;

                      final loadingOverlay = LoadingBlockFullScreen(
                        context: _scaffoldKey.currentContext!,
                        dismissable: false,
                      );

                      // 1. get the timestamp of submission
                      final timestamp = Timestamp.fromDate(DateTime.now());

                      // 2. Block the UI using the loading overlay
                      loadingOverlay.show();

                      // 3. take the currency & amount, and format it
                      final currency = currencyUnit;
                      final amount = double.parse(_amountController.text);
                      final formattedAmount = NumberFormat.currency(
                        locale: context.locale.toString(),
                        symbol: currency,
                      ).format(amount);
                      debugPrint("Currency: $currency");
                      debugPrint("Amount: $amount");
                      debugPrint("Formatted Amount: $formattedAmount");

                      // 4. Get the imminent document IDs from the firestore collection
                      final newItemID =
                          BartFirestoreServices.getNextNewItemID();
                      final newTradeID =
                          BartFirestoreServices.getNextNewTradeID();

                      // 5. Create a new payment item
                      final paymentItem = Item(
                        itemID: newItemID,
                        isPayment: true,
                        isListedInMarket: false,
                        postedOn: timestamp,
                        itemName: formattedAmount,
                        itemDescription: formattedAmount,
                        itemOwner: stateProvider.userProfile,
                        imgs: [],
                      );

                      // 6. Add the payment item to the firestore collection
                      BartFirestoreServices.addItem(paymentItem, newItemID)
                          .then((value) {
                        // 6. Create a new trade
                        final paymentTrade = Trade(
                          tradeID: newTradeID,
                          tradedItem: widget.returnForItem,
                          offeredItem: paymentItem,
                          isAccepted: false,
                          isCompleted: false,
                          acceptedByTradee: false,
                          acceptedByTrader: false,
                          timeUpdated: timestamp,
                          isRead: false,
                          timeCreated: timestamp,
                        );

                        // 7. Add the trade to the firestore collection
                        BartFirestoreServices.addTrade(paymentTrade)
                            .then((value) {
                          // 8. Hide the loading overlay
                          loadingOverlay.hide();

                          final Map<String, dynamic> obj = {
                            'messageHeading': context.tr(
                                'trade.result.message.title.heading.success'), // todo:_IMPLEMENT THE FAILED ONES ALSO!!
                            'message':
                                context.tr('trade.result.message.text.success'),
                            'isSuccessful': true,
                            'item1': widget.returnForItem,
                            'item2': paymentItem,
                            'dateCreated': paymentTrade.timeCreated,
                          };
                          context.push(
                            '/market/listed-items/item/${widget.returnForItem.itemID}/returnItem/tradeResult',
                            extra: obj,
                          );
                        });
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
