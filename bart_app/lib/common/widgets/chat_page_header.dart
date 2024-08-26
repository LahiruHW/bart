import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Shows the image and the name of the user you're chatting
/// with in the chat page
class ChatPageHeader extends StatelessWidget {
  const ChatPageHeader({
    super.key,
    required this.chatData,
  });

  final Chat chatData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
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
            child: chatData.chatImageUrl.isEmpty
                ? const Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                : CachedNetworkImage(
                    key: UniqueKey(),
                    cacheManager: BartImageTools.customCacheManager,
                    progressIndicatorBuilder: BartImageTools.progressLoader,
                    imageUrl: chatData.chatImageUrl,
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10),
          Text(
            chatData.chatName,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 18.spMin,
                ),
          ),
        ],
      ),
    );
  }
}
