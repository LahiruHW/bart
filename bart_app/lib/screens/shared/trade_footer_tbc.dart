// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/constants/enum_material_button_types.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class TBCTradeFooter extends StatelessWidget {
  const TBCTradeFooter({
    super.key,
    required this.userID,
    required this.trade,
    required this.loadingOverlay,
    required this.isMsgSending,
    required this.whileSending,
    required this.onSent,
  });

  final Trade trade;
  final String userID;
  final LoadingBlockFullScreen loadingOverlay;
  final bool isMsgSending;
  final Function whileSending;
  final Function onSent;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (trade.offeredItem.itemOwner.userID == userID)
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: BartMaterialButton(
                      buttonType: BartMaterialButtonType.green,
                      isEnabled: !isMsgSending,
                      label: trade.offeredItem.isPayment
                          ? context.tr(
                              'view.trade.page.btn.handover.done3',
                            )
                          : context.tr(
                              'view.trade.page.btn.handover.done1',
                            ),
                      onPressed: () async {
                        whileSending();
                        loadingOverlay.show();
                        // the tradee accepts the trade
                        await BartFirestoreServices.acceptTradeAsTradee(
                          trade.tradeID,
                        ).then(
                          (value) {
                            onSent();
                            loadingOverlay.hide();
                            context.go('/home-trades');
                          },
                        );
                      },
                    ),
                  ),
                if (trade.tradedItem.itemOwner.userID == userID)
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: BartMaterialButton(
                      buttonType: BartMaterialButtonType.green,
                      isEnabled: !isMsgSending,
                      label: context.tr(
                        'view.trade.page.btn.handover.done2',
                      ),
                      onPressed: () async {
                        whileSending();
                        loadingOverlay.show();
                        // the trader accepts the trade
                        await BartFirestoreServices.acceptTradeAsTrader(
                          trade.tradeID,
                        ).then(
                          (value) {
                            onSent();
                            context.go('/home-trades');
                            loadingOverlay.hide();
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 75,
                  child: BartMaterialButton(
                    label: context.tr('view.trade.page.btn.goToChat'),
                    isEnabled: !isMsgSending,
                    onPressed: () {
                      whileSending();
                      loadingOverlay.show();
                      Future.delayed(
                        const Duration(milliseconds: 1500),
                        () {
                          BartFirestoreServices.getChatRoomID(
                            trade.offeredItem.itemOwner,
                            trade.tradedItem.itemOwner,
                          ).then(
                            (chatID) async {
                              await BartFirestoreServices.getChat(
                                userID,
                                chatID,
                              ).then(
                                (chat) {
                                  loadingOverlay.hide();
                                  onSent();
                                  context.go(
                                    '/chat/chatRoom/$chatID',
                                    extra: chat,
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
