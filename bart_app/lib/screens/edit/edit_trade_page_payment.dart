import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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

class EditTradePagePayment extends StatefulWidget {
  const EditTradePagePayment({
    super.key,
    required this.trade,
  });

  final Trade trade;

  @override
  State<EditTradePagePayment> createState() => _EditTradePagePaymentState();
}

class _EditTradePagePaymentState extends State<EditTradePagePayment> {
  final List<String> currencyList = ["€"]; // ["\$", "€"];
  late String currencyUnit;
  late String amount;
  late final TextEditingController _amountController;
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isBtnEnabled = true;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    currencyUnit = currencyList[0];
    final amount = extractAmount(widget.trade.offeredItem.itemName);
    _amountController = TextEditingController(text: amount);
  }

  // extract the amount from the currencyAmount string
  String extractAmount(String currencyAmount) {
    for (final unit in currencyList) {
      if (currencyAmount.contains(unit)) {
        currencyAmount = currencyAmount.replaceAll(unit, '');
        break;
      }
    }
    return currencyAmount;
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
    final loadOverlay = LoadingBlockFullScreen(
      context: context,
      dismissable: false,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    label: context.tr('edit.trade.page.btn.confirm'),
                    isEnabled: _isBtnEnabled,
                    onPressed: () {
                      setState(() => _isBtnEnabled = false);
                      // 0. validate the amount
                      if (!validateAmount()) return;

                      // 1. get the timestamp of submission
                      final timestamp = Timestamp.fromDate(DateTime.now());

                      // 2. Block the UI using the loading overlay
                      loadOverlay.show();

                      // 3. take the currency & amount, and format it
                      final currency = currencyUnit;
                      final amount = double.parse(_amountController.text);
                      final formattedAmount = NumberFormat.currency(
                        locale: context.locale.toString(),
                        symbol: currency,
                      ).format(amount);

                      // 4. create a new payment item based on the current offeredItem
                      final editedItem = widget.trade.offeredItem.copyWith(
                        itemName: formattedAmount,
                        itemDescription: formattedAmount,
                        isPayment: true,
                        isListedInMarket: false,
                      );
                      // 5. create a new trade with the edited item
                      final editedTrade = widget.trade.copyWith(
                        offeredItem: editedItem,
                        timeUpdated: timestamp,
                        isRead: false,
                      );

                      // 6. save the changes to the firestore
                      BartFirestoreServices.saveEditPaymentTradeChanges(
                        editedTrade,
                      ).then(
                        (result) {
                          loadOverlay.hide();
                          setState(() => _isBtnEnabled = true);
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              BartSnackBar(
                                message: tr('edit.trade.page.success.snackbar'),
                                backgroundColor: Colors.green,
                                icon: Icons.error,
                              ).build(context),
                            );
                            context.go(
                              '/viewTrade',
                              extra: {
                                'trade': editedTrade,
                                'tradeType': editedTrade.tradeCompType,
                                'userID': stateProvider.userProfile.userID,
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              BartSnackBar(
                                message: tr('edit.trade.page.error.snackbar'),
                                backgroundColor: Colors.red,
                                icon: Icons.error,
                              ).build(context),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
