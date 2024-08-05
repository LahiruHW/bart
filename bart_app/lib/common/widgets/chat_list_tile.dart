import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final listTileStyle = Theme.of(context).listTileTheme;
    return ListTile(
      title: Text(
        widget.chat.chatName,
        style: listTileStyle.titleTextStyle!.copyWith(
          fontSize: 20.spMin,
        ),
      ),
      subtitle: Text(
        widget.chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: listTileStyle.subtitleTextStyle!.copyWith(
          fontSize: 16.spMin,
        ),
      ),
      leading: (widget.chat.chatImageUrl.isNotEmpty)
          ? CachedNetworkImage(
              key: UniqueKey(),
              cacheKey: 'chatUserImg_${widget.chat.chatID}',
              imageUrl: widget.chat.chatImageUrl,
              cacheManager: BartImageTools.customCacheManager,
              alignment: Alignment.center,
              fit: BoxFit.fill,
              width: 60.w,
              height: 60.h,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
            )
          : CircleAvatar(
              backgroundColor: Colors.black,
              radius: 30.r,
              child: const Icon(Icons.person),
            ),
      trailing: unreadCount == 0
          ? Text(
              timeText,
              style: TextStyle(fontSize: 12.spMin),
            )
          : SizedBox(
              width: 100.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20.w,
                    height: 20.h,
                    // padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? "99+" : unreadCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.spMin,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    timeText,
                    style: TextStyle(fontSize: 12.spMin),
                  ),
                ],
              ),
            ),
      minLeadingWidth: 10,
      style: ListTileStyle.drawer,
      onTap: widget.onTap,
    );
  }
}
