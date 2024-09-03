import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:bart_app/common/widgets/bart_chat_bubble.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/chat_input_actions.dart';
import 'package:bart_app/common/extensions/ext_bart_scroll_controller.dart';

class ChatPageChatView extends StatefulWidget {
  const ChatPageChatView({
    super.key,
    required this.userID,
    required this.chatID,
    required this.chatData,
  });

  final String userID;
  final String chatID;
  final Chat chatData;

  @override
  State<ChatPageChatView> createState() => _ChatPageChatViewState();
}

class _ChatPageChatViewState extends State<ChatPageChatView> {
  late final TextEditingController _textEditController;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;

  Timer? _debounce;
  final Duration _debounceDuration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    _textEditController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _focusNode.addListener(() {
      if (_focusNode.hasFocus || _focusNode.hasPrimaryFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _scrollController.scrollDown(),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _scrollController.scrollDown(),
      );
    });
  }

  Widget _dateSeparator(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(
            thickness: 0.5,
            color: Theme.of(context).dividerColor,
          ),
          Center(
            child: Container(
              height: 20,
              width: 80,
              alignment: Alignment.center,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                date,
                style: TextStyle(
                  color: Theme.of(context).dividerColor,
                  fontSize: 12.spMin,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyChatWidget(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 80.h),
        child: Text(
          context.tr('chat.page.empty'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 12.spMin,
                color: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .color!
                    .withOpacity(0.5),
              ),
        ),
      );

  void _createDebounce() {
    _debounce = Timer(
      _debounceDuration,
      () {
        BartFirestoreServices.updateReadMessages(
          widget.chatData,
          widget.userID,
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          onVerticalDragDown: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          onHorizontalDragDown: (_) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          child: StreamBuilder(
            stream: BartFirestoreServices.chatRoomMessageListStream(
              widget.chatID,
              widget.userID,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return _emptyChatWidget(context);
                }

                // scroll down after the list is built
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) => _scrollController.scrollDown(),
                );

                final firstMsgDT = snapshot.data!.first.timeSent.toDate();
                final diff = DateTime.now().difference(firstMsgDT).inDays;
                final date = diff < 1
                    ? "Today"
                    : diff == 1
                        ? "Yesterday"
                        : "${firstMsgDT.day}/${firstMsgDT.month}/${firstMsgDT.year}";

                _createDebounce();
                return ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 80.h),
                  children: [
                    _dateSeparator(context, date),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data![index];
                        return VisibilityDetector(
                          key: Key(message.messageID),
                          onVisibilityChanged: (info) async {
                            // while the timer is active:
                            //    add all the unread messages to the batch
                            // when the timer is finished:
                            //    update the read status of all the messages in the batch
                            //    clear the batch
                            if (info.visibleFraction >= 0.6) {
                              if (_debounce?.isActive ?? false) {
                                if (!message.isRead!) {
                                  BartFirestoreServices.updateMsgBatch(
                                    widget.chatData,
                                    message,
                                    widget.userID,
                                  );
                                }
                                _debounce!.cancel();
                              }
                              _createDebounce();
                            }
                            // var visiblePT = info.visibleFraction * 100;
                            // debugPrint('Widget ${info.key} is $visiblePT% visible');
                          },
                          child: BartChatBubble(
                            message: message,
                            currentUserID: widget.userID,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        final currentDT = DateTime.now();
                        final currentMsg = snapshot.data![index];
                        final currentMsgDT = currentMsg.timeSent.toDate();
                        final nextMsg = snapshot.data![index + 1];
                        final nextMsgDT = nextMsg.timeSent.toDate();
                        final showDate = !nextMsg.isSameDayAsMsg(currentMsg);
                        if (showDate) {
                          final diff = currentDT.difference(nextMsgDT).inDays;
                          final date = diff == 0
                              ? "Today"
                              : diff == 1
                                  ? "Yesterday"
                                  : "${currentMsgDT.day}/${currentMsgDT.month}/${currentMsgDT.year}";
                          return _dateSeparator(context, date);
                        }
                        return const SizedBox(height: 1);
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.chatData.users.contains(
            UserLocalProfile.empty(),
          )
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.85),
                  child: Text(
                    context.tr('chat.user.is.deleted'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.spMin),
                  ),
                )
              : ChatInputGroup(
                  controller: _textEditController,
                  focusNode: _focusNode,
                  onSend: () {
                    if (_textEditController.text.isNotEmpty) {
                      debugPrint("Send message: ${_textEditController.text}");
                      BartFirestoreServices.sendMessageUsingChatObj(
                        widget.chatData,
                        widget.userID,
                        _textEditController.text.trim(),
                      );

                      _textEditController.clear();
                      _scrollController.scrollDown();
                    }
                  },
                ),
        ),
      ],
    );
  }
}
