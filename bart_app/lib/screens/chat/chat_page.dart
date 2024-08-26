import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:bart_app/common/widgets/chat_page_header.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/chat_page_chat_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.chatID,
    required this.chatData,
  });

  final String chatID;
  final Chat chatData;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

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
                ChatPageHeader(chatData: widget.chatData),
                Expanded(
                  child: ChatPageChatView(
                    userID: provider.userProfile.userID,
                    chatID: widget.chatID,
                    chatData: widget.chatData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
