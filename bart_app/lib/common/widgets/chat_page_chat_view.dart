import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:bart_app/common/widgets/bart_chat_bubble.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/chat_input_actions.dart';

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
  final Duration _debounceDuration = const Duration(milliseconds: 400);

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
          () => scrollDown(),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => scrollDown(),
      );
    });
  }

  void scrollDown({double offset = 0.0}) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
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
        StreamBuilder(
          stream: BartFirestoreServices.chatRoomMessageListStream(
            widget.chatID,
            widget.userID,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // scroll down after the list is built
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) => scrollDown(),
              );

              final firstMsgDT = snapshot.data!.first.timeSent.toDate();
              final diff = DateTime.now().difference(firstMsgDT).inDays;
              final date = diff < 1
                  ? "Today"
                  : diff == 1
                      ? "Yesterday"
                      : "${firstMsgDT.day}/${firstMsgDT.month}/${firstMsgDT.year}";

              return ListView(
                controller: _scrollController,
                children: [
                  _dateSeparator(context, date),
                  ListView.separated(
                    padding: const EdgeInsets.only(bottom: 10),
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
                  const SizedBox(height: 80),
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
        Align(
          alignment: Alignment.bottomCenter,
          child: widget.chatData.users.contains(
            UserLocalProfile.empty(),
          )
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Text(
                    "This user has deleted their account. You can no longer chat with them.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
                      scrollDown(offset: 100);
                    }
                  },
                ),
        ),
      ],
    );
  }
}
