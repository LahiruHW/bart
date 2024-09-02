// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/item_description_input.dart';

class ItemQuestionField extends StatefulWidget {
  const ItemQuestionField({
    super.key,
    required this.item,
    required this.userID,
    required this.focusNode,
  });

  final Item item;
  final String userID;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => ItemQuestionFieldState();
}

class ItemQuestionFieldState extends State<ItemQuestionField> {
  late final TextEditingController textEditController;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    textEditController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          context.tr('view.trade.page.incoming.askQuestion'),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: BartAppTheme.red1,
                fontSize: 20.spMin,
              ),
        ),
        const SizedBox(height: 10),
        DescriptionTextField(
          textController: textEditController,
          focusNode: widget.focusNode,
          minLines: 6,
          maxLines: 10,
          maxCharCount: 200,
          showSendButton: true,
          isSending: isSending,
          onSend: () async {
            setState(() => isSending = true);
            await BartFirestoreServices.getChatRoomID(
              await BartFirestoreServices.getUserProfile(
                widget.userID,
              ),
              widget.item.itemOwner,
            ).then(
              (chatID) async {
                debugPrint("||||||||||||||||||||| chatID: $chatID");
                if (textEditController.text.isEmpty) return;
                return await BartFirestoreServices.sendMessageUsingChatID(
                  chatID,
                  widget.userID,
                  textEditController.text.trim(),
                  isSharedItem: true,
                  itemContent: widget.item,
                ).then(
                  (value) async {
                    setState(() => isSending = false);
                    // show the snackbar to confirm the message was sent
                    ScaffoldMessenger.of(context).showSnackBar(
                      BartSnackBar(
                        message: context.tr(
                          'view.trade.page.incoming.questionSent',
                          namedArgs: {
                            'itemOwner': widget.item.itemOwner.userName,
                          },
                        ),
                        actionText: "CHAT",
                        backgroundColor: Colors.green,
                        icon: Icons.check_circle,
                        onPressed: () async {
                          await BartFirestoreServices.getChat(
                                  widget.userID, chatID)
                              .then(
                            (chat) {
                              context.go('/chat/chatRoom/$chatID', extra: chat);
                            },
                          );
                        },
                      ).build(context),
                    );
                    textEditController.clear();
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
