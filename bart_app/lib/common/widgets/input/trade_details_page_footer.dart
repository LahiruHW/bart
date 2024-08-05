import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/constants/enum_trade_comp_types.dart';
import 'package:bart_app/common/constants/enum_material_button_types.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/input/item_description_input.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class TradeDetailsPageFooter {
  TradeDetailsPageFooter({
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
              loadingOverlay.show(); // first show the loading indicator
              BartFirestoreServices.cancelTrade(trade).then((cancelled) {
                debugPrint("||||||||||||||||||||| cancelled: $cancelled");
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
                  context.go('/home'); // finally go back home
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

  List<Widget> build(BuildContext context) {
    switch (tradeType) {
      case TradeCompType.incoming:
        return [
          Text(
            // 'Ask a question about the product: ',
            context.tr('view.trade.page.incoming.askQuestion'),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: BartAppTheme.red1,
                  fontSize: 20,
                ),
          ),
          const SizedBox(height: 10),
          (!trade.offeredItem.isPayment)
              ? DescriptionTextField(
                  textController: descriptionTextController!,
                  focusNode: focusNode,
                  minLines: 6,
                  maxLines: 10,
                  maxCharCount: 200,
                  showSendButton: true,
                  isSending: isMsgSending,
                  onSend: () async {
                    whileSending();
                    await BartFirestoreServices.getChatRoomID(
                      trade.offeredItem.itemOwner,
                      trade.tradedItem.itemOwner,
                    ).then((chatID) async {
                      debugPrint("||||||||||||||||||||| chatID: $chatID");
                      if (descriptionTextController!.text.isEmpty) return;
                      return await BartFirestoreServices.sendMessageUsingChatID(
                        chatID,
                        trade.tradedItem.itemOwner.userID,
                        descriptionTextController!.text,
                        isSharedTrade: true,
                        tradeContent: trade,
                      ).then(
                        (value) async {
                          onSent();
                          // show the snackbar to confirm the message was sent
                          ScaffoldMessenger.of(context).showSnackBar(
                            BartSnackBar(
                              message: context.tr(
                                'view.trade.page.incoming.questionSent',
                                namedArgs: {
                                  'itemOwner':
                                      trade.offeredItem.itemOwner.userName,
                                },
                              ),
                              actionText: "CHAT",
                              backgroundColor: Colors.green,
                              icon: Icons.check_circle,
                              onPressed: () async {
                                await BartFirestoreServices.getChat(
                                        userID, chatID)
                                    .then(
                                  (chat) {
                                    context.go('/chat/chatRoom/$chatID',
                                        extra: chat);
                                  },
                                );
                              },
                            ).build(context),
                          );
                          descriptionTextController!.clear();
                        },
                      );
                    });
                  },
                )
              : const SizedBox(),
          (!trade.offeredItem.isPayment)
              ? const SizedBox(height: 10)
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                height: 75,
                child: BartMaterialButton(
                  buttonType: BartMaterialButtonType.green,
                  // label: "Accept",
                  label: context.tr('accept'),
                  onPressed: () {
                    loadingOverlay.show();

                    // accept & complete the trade
                    BartFirestoreServices.markTradeAsAccepted(
                      trade.tradeID,
                    ).then(
                      (value) {
                        Future.delayed(
                          const Duration(milliseconds: 1500),
                          () {
                            loadingOverlay.hide();
                            trade.tradeCompType = TradeCompType.toBeCompleted;
                            context.replace(
                              '/home/viewTrade',
                              extra: {
                                'trade': trade,
                                'tradeType': trade.tradeCompType,
                                'userID': userID,
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 150,
                height: 75,
                child: BartMaterialButton(
                  label: context.tr('decline'),
                  onPressed: () {
                    loadingOverlay.show();

                    // accept & complete the trade
                    BartFirestoreServices.declineTrade(trade.tradeID).then(
                      (value) {
                        Future.delayed(
                          const Duration(milliseconds: 1500),
                          () {
                            loadingOverlay.hide();
                            GoRouter.of(context).pop();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ];

      case TradeCompType.outgoing:
        return [
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
                          '/home/viewTrade/editTrade',
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
                      onPressed: () => cancelConfirmationDialog(context),
                    ),
                  ),
                )
              : Container(),
        ];

      case TradeCompType.toBeCompleted:
        return [
          Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(bottom: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (trade.offeredItem.itemOwner.userID == userID)
                      ? SizedBox(
                          width: 150,
                          height: 75,
                          child: BartMaterialButton(
                            buttonType: BartMaterialButtonType.green,
                            label: trade.offeredItem.isPayment
                                ? context
                                    .tr('view.trade.page.btn.handover.done3')
                                : context
                                    .tr('view.trade.page.btn.handover.done1'),
                            onPressed: () {
                              loadingOverlay.show();
                              // the tradee accepts the trade
                              BartFirestoreServices.acceptTradeAsTradee(
                                trade.tradeID,
                              ).then(
                                (value) {
                                  Future.delayed(
                                    const Duration(milliseconds: 1500),
                                    () {
                                      context.go('/home');
                                      loadingOverlay.hide();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Container(),
                  (trade.tradedItem.itemOwner.userID == userID)
                      ? SizedBox(
                          width: 150,
                          height: 75,
                          child: BartMaterialButton(
                            buttonType: BartMaterialButtonType.green,
                            label: context
                                .tr('view.trade.page.btn.handover.done2'),
                            onPressed: () async {
                              loadingOverlay.show();
                              // item is taken off the market
                              trade.tradedItem.isListedInMarket = false;
                              await Future.wait(
                                [
                                  BartFirestoreServices.updateItem(
                                    trade.tradedItem,
                                  ),
                                  // the trader accepts the trade
                                  BartFirestoreServices.acceptTradeAsTrader(
                                    trade.tradeID,
                                  ),
                                ],
                              ).then(
                                (value) {
                                  Future.delayed(
                                    const Duration(milliseconds: 1500),
                                    () {
                                      context.go('/home');
                                      loadingOverlay.hide();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: BartMaterialButton(
                      // label: "Go to chat",
                      label: context.tr('view.trade.page.btn.goToChat'),
                      onPressed: () {
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
        ];

      case TradeCompType.tradeHistory:
        return [
          Container(),
        ];

      default:
        return [
          Container(),
        ];
    }
  }
}
