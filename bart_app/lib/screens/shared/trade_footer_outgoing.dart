// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class OutgoingTradeFooter extends StatelessWidget {
  const OutgoingTradeFooter({
    super.key,
    required this.userID,
    required this.trade,
    required this.tradeType,
    this.descriptionTextController,
    this.focusNode,
    required this.loadingOverlay,
    required this.isMsgSending,
    required this.whileSending,
    required this.onSent,
  });

  final Trade trade;
  final String userID;
  final FocusNode? focusNode;
  final TradeCompType tradeType;
  final TextEditingController? descriptionTextController;
  final LoadingBlockFullScreen loadingOverlay;
  final bool isMsgSending;
  final Function whileSending;
  final Function onSent;

  void cancelConfirmationDialog(BuildContext thisContext) {
    showDialog(
      context: thisContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('view.trade.page.outgoing.btn.cancel'),
        ),
        content: Text(context.tr('view.trade.page.outgoing.cancel.warning')),
        actions: [
          TextButton(
            onPressed: () async {
              whileSending();
              loadingOverlay.show(); // first show the loading indicator
              BartFirestoreServices.cancelTrade(trade).then((cancelled) {
                debugPrint("||||||||||||||||||||| cancelled: $cancelled");
                onSent();
                loadingOverlay.hide();
                if (cancelled) {
                  ScaffoldMessenger.of(thisContext).showSnackBar(
                    BartSnackBar(
                      message: context.tr(
                        'view.trade.page.outgoing.cancel.msg',
                        namedArgs: {
                          'itemOwner': trade.tradedItem.itemOwner.userName
                        },
                      ),
                      backgroundColor: Colors.green,
                      icon: Icons.check_circle,
                    ).build(context),
                  );
                  Navigator.of(context).pop(); // THEN close the dialog
                  context.go('/home-trades'); // finally go back home
                }
              });
            },
            child: Text(context.tr('yes')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('no')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        (!trade.isAccepted &&
                (!trade.acceptedByTradee && !trade.acceptedByTrader))
            ? Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: Text(
                    context.tr(
                      'view.trade.page.outgoing.waiting.msg',
                      namedArgs: {
                        'itemOwner': trade.tradedItem.itemOwner.userName
                      },
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: BartAppTheme.red1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              )
            : Container(),

        // show a button to edit the trade
        (!trade.isAccepted && !trade.isCompleted)
            ? Center(
                child: SizedBox(
                  width: 150,
                  height: 75,
                  child: BartMaterialButton(
                    label: context.tr('view.trade.page.btn.editTrade'),
                    onPressed: () {
                      context.push(
                        '/viewTrade/editTrade',
                        extra: {'trade': trade},
                      );
                    },
                  ),
                ),
              )
            : Container(),

        (!trade.isAccepted && !trade.isCompleted)
            ? const SizedBox(height: 10)
            : Container(),

        // show a button to cancel the trade
        (!trade.isAccepted && !trade.isCompleted)
            ? Center(
                child: SizedBox(
                  width: 150,
                  height: 75,
                  child: BartMaterialButton(
                    label: context.tr('view.trade.page.outgoing.btn.cancel'),
                    isEnabled: !isMsgSending,
                    onPressed: () => cancelConfirmationDialog(context),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
