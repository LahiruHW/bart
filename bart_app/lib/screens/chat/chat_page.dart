import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/bart_chat_bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';
import 'package:bart_app/common/widgets/input/chat_input_actions.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatID,
    required this.chatData,
    // this.extra,
  });

  /**
   * extra: {
   *  'headerBannerText': to show in the banner 
   * }
   */

  final String chatID;
  final Chat chatData;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _textEditController;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _textEditController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus || _focusNode.hasPrimaryFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(offset: 100),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<BartStateProvider>(
        builder: (context, provider, child) => Scaffold(
          key: globalKey,
          body: Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 5.0,
              bottom: 5.0,
            ),
            child: Column(
              children: [
                // show the image and the name of the user you're chatting with
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      Container(
                        width: 35,
                        height: 35,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: widget.chatData.chatImageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                              )
                            : CachedNetworkImage(
                                key: UniqueKey(),
                                cacheManager:
                                    BartImageTools.customCacheManager,
                                progressIndicatorBuilder:
                                    BartImageTools.progressLoader,
                                imageUrl: widget.chatData.chatImageUrl,
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.chatData.chatName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: StreamBuilder(
                    stream: BartFirestoreServices.chatRoomMessageListStream(
                      widget.chatID,
                      provider.userProfile.userID,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // scroll down after the list is built
                        WidgetsBinding.instance.addPostFrameCallback(
                          (timeStamp) => scrollDown(),
                        );

                        final firstMsgDT =
                            snapshot.data!.first.timeSent.toDate();
                        final diff =
                            DateTime.now().difference(firstMsgDT).inDays;
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
                                    if (info.visibleFraction == 1.0) {
                                      BartFirestoreServices.updateReadMessage(
                                        widget.chatData,
                                        message,
                                        provider.userProfile.userID,
                                      );
                                    }
                                    // var visiblePT = info.visibleFraction * 100;
                                    // debugPrint('Widget ${info.key} is $visiblePT% visible');
                                  },
                                  child: BartChatBubble(
                                    message: message,
                                    currentUserID: provider.user!.uid,
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
                Divider(
                  color:
                      Theme.of(context).colorScheme.surface.computeLuminance() >
                              0.5
                          ? Colors.white
                          : Colors.black,
                  indent: 0,
                  height: 1,
                ),

                // if there is a user in the chatData that is deleted, show a message

                widget.chatData.users.contains(UserLocalProfile.empty())
                    ? Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                            debugPrint(
                                "Send message: ${_textEditController.text}");
                            BartFirestoreServices.sendMessageUsingChatObj(
                              widget.chatData,
                              provider.userProfile.userID,
                              _textEditController.text.trim(),
                            );

                            _textEditController.clear();
                            scrollDown(offset: 100);
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
