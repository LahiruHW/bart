import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatListTile extends StatefulWidget {
  const ChatListTile({
    super.key,
    required this.chat,
    required this.onTap,
  });

  final Chat chat;
  final VoidCallback onTap;

  @override
  State<ChatListTile> createState() => _ChatListTileState();
}

class _ChatListTileState extends State<ChatListTile> {
  String timeText = "";

  String getTimeDifferenceText(Timestamp timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp.toDate());
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (difference.inSeconds <= 2) {
      return "Just now";
    } else if (difference.inSeconds <= 60) {
      return "${difference.inSeconds}s ago";
    } else if (difference.inMinutes <= 60) {
      return "${difference.inMinutes}min ago";
    } else if (difference.inHours <= 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays <= 1) {
      return "Yesterday";
    } else {
      return formatter.format(timestamp.toDate());
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() => timeText = getTimeDifferenceText(widget.chat.lastUpdated));
    final provider = Provider.of<BartStateProvider>(context, listen: false);
    final unreadCount =
        widget.chat.getUnreadMsgCountForUser(provider.userProfile.userID);
    return ListTile(
      title: Text(widget.chat.chatName),
      subtitle: Text(
        widget.chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: (widget.chat.chatImageUrl.isNotEmpty)
          ? CachedNetworkImage(
              key: UniqueKey(),
              cacheKey: 'chatUserImg_${widget.chat.chatID}',
              imageUrl: widget.chat.chatImageUrl,
              cacheManager: BartImageTools.customCacheManager,
              alignment: Alignment.center,
              fit: BoxFit.fill,
              width: 60,
              height: 60,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
            )
          : const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 30,
              child: Icon(Icons.person),
            ),
      trailing: unreadCount == 0
          ? Text(timeText)
          : SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    // padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? "99+" : unreadCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(timeText),
                ],
              ),
            ),
      minLeadingWidth: 10,
      style: ListTileStyle.drawer,
      onTap: widget.onTap,
    );
  }
}
