import 'package:bart_app/common/entity/chat.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_chat_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// import 'package:bart_app/common/utility/bart_router.dart';
import 'package:bart_app/common/widgets/chat_list_tile.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
// import 'package:rxdart/rxdart.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({
    super.key,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<BartStateProvider>(
      builder: (context, provider, child) => SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 15.0,
        ),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Text(
                  'Chat',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: Theme.of(context)
                                    .colorScheme
                                    .background
                                    .computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            StreamBuilder(
              stream: BartFirestoreServices.getChatListTileStream(
                provider.userProfile.userID,
              ),
              // BartFirestoreServices.getChatListTileStream2(
              //   provider.userProfile.userID,
              //   provider.userProfile.chats,
              // ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  // final data = snapshot.data as List<Map<String, dynamic>>;
                  final data = snapshot.data as List<Chat>;

                  return data.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...data.map(
                              (chatData) {
                                return ChatListTile(
                                  chat: chatData,
                                  onTap: () => context.push(
                                    '/chat/chatRoom/${chatData.chatID}',
                                    extra: chatData,
                                  ),
                                );
                              },
                            )
                          ]
                              .animate(
                                delay: 300.ms,
                                interval: 50.ms,
                              )
                              .fadeIn(
                                duration: 400.ms,
                                curve: Curves.easeInOutCubic,
                              ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                            top: (screenHeight * 0.45) - (screenHeight * 0.1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No chats yet",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      10,
                      (index) {
                        return const ChatListTileShimmer();
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
