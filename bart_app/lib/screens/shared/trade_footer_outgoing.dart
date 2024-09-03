import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/widgets/item_unavailable_msg.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class OutgoingTradeFooter extends StatelessWidget {
  const OutgoingTradeFooter({
    super.key,
    required this.userID,
    required this.trade,
    required this.loadingOverlay,
    required this.isMsgSending,
    required this.whileSending,
    required this.onSent,
  });

  final String userID;
  final Trade trade;
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
              context.pop(); // first close the dialog
              whileSending();
              loadingOverlay.show(); // then show the loading indicator
              BartFirestoreServices.cancelTrade(
                trade,
                restoreTradedItem: true,
              ).then(
                (cancelled) {
                  debugPrint("||||||||||||||||||||| cancelled: $cancelled");
                  onSent();
                  loadingOverlay.hide();
                  final parentContext = Base.globalKey.currentContext!;
                  if (cancelled && parentContext.mounted) {
                    ScaffoldMessenger.of(parentContext).showSnackBar(
                      BartSnackBar(
                        message: parentContext.tr(
                          'view.trade.page.outgoing.cancel.msg',
                          namedArgs: {
                            'itemOwner': trade.tradedItem.itemOwner.userName
                          },
                        ),
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                      ).build(parentContext),
                    );
                    parentContext.go('/home-trades');
                  }
                },
              );
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
      children: (trade.tradedItem.isListedInMarket)
          ? [
              if (!trade.isAccepted &&
                  (!trade.acceptedByTradee && !trade.acceptedByTrader))
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(bottom: 15),
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
                ),

              // show a button to edit the trade
              if (!trade.isAccepted && !trade.isCompleted)
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 75,
                    child: BartMaterialButton(
                      label: context.tr('view.trade.page.btn.editTrade'),
                      isEnabled: !isMsgSending,
                      onPressed: () {
                        context.push(
                          '/viewTrade/editTrade',
                          extra: {'trade': trade},
                        );
                      },
                    ),
                  ),
                ),

              if (!trade.isAccepted && !trade.isCompleted)
                const SizedBox(height: 20),

              // show a button to cancel the trade
              if (!trade.isAccepted && !trade.isCompleted)
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 75,
                    child: BartMaterialButton(
                      label: context.tr('view.trade.page.outgoing.btn.cancel'),
                      isEnabled: !isMsgSending,
                      onPressed: () => cancelConfirmationDialog(context),
                    ),
                  ),
                ),
            ]
          : [
              ItemUnavailableMsg(
                userID: userID,
                trade: trade,
              ),
              BartMaterialButton(
                label: context.tr('view.trade.page.outgoing.btn.cancel'),
                onPressed: () {
                  loadingOverlay.show(); // first show the loading indicator
                  Base.globalKey.currentContext!.go('/home-trades');
                  BartFirestoreServices.cancelTrade(
                    trade,
                    restoreTradedItem: false,
                  ).then(
                    (value) {
                      loadingOverlay.hide();
                    },
                  );
                },
              ),
            ],
    );
  }
}
