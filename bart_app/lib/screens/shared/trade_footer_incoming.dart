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
import 'package:bart_app/common/constants/enum_material_button_types.dart';
import 'package:bart_app/common/widgets/input/item_description_input.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class IncomingTradeFooter extends StatelessWidget {
  const IncomingTradeFooter({
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if (!trade.offeredItem.isPayment)
          Text(
            context.tr('view.trade.page.incoming.askQuestion'),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: BartAppTheme.red1,
                  fontSize: 20,
                ),
          ),
        const SizedBox(height: 10),
        if (!trade.offeredItem.isPayment)
          DescriptionTextField(
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
                  descriptionTextController!.text.trim(),
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
                            'itemOwner': trade.offeredItem.itemOwner.userName,
                          },
                        ),
                        actionText: "CHAT",
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                        onPressed: () async {
                          await BartFirestoreServices.getChat(userID, chatID)
                              .then(
                            (chat) {
                              context.go(
                                '/chat/chatRoom/$chatID',
                                extra: chat,
                              );
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
          ),
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
                isEnabled: !isMsgSending,
                buttonType: BartMaterialButtonType.green,
                label: context.tr('accept'),
                onPressed: () {
                  whileSending();
                  loadingOverlay.show();

                  // accept & complete the trade
                  BartFirestoreServices.markTradeAsAccepted(
                    trade.tradeID,
                  ).then(
                    (value) {
                      Future.delayed(
                        const Duration(milliseconds: 1500),
                        () {
                          onSent();
                          loadingOverlay.hide();
                          trade.tradeCompType = TradeCompType.toBeCompleted;
                          context.replace(
                            '/viewTrade',
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
                isEnabled: !isMsgSending,
                onPressed: () {
                  whileSending();
                  loadingOverlay.show();

                  // accept & complete the trade
                  BartFirestoreServices.declineTrade(trade.tradeID).then(
                    (value) {
                      onSent();
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
      ],
    );
  }
}
