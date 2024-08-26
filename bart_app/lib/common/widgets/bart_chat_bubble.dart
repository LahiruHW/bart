import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/common/entity/message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_chat_bubble_style.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bart_app/common/entity/user_local_profile.dart';

class BartChatBubble extends StatelessWidget {
  const BartChatBubble({
    super.key,
    required this.message,
    required this.currentUserID,
  });

  final Message message;
  final String currentUserID;

  Widget buildSenderBubble(
    BuildContext context,
    BartChatBubbleStyle bubbleTheme,
    Message msg,
    bool isSender,
  ) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      style: BubbleStyle(
        margin: const BubbleEdges.only(left: 70),
        alignment: Alignment.topRight,
        nip: BubbleNip.rightTop,
        color: bubbleTheme.senderBackgroundColor,
        padding: const BubbleEdges.all(10),
        radius: const Radius.circular(20),
      ),
      child: BubbleChildFactory(
        message: message,
        bubbleTheme: bubbleTheme,
        currentUserID: currentUserID,
        isSender: isSender,
      ),
    );
  }

  Widget buildReceiverBubble(
    BuildContext context,
    BartChatBubbleStyle bubbleTheme,
    Message msg,
    bool isSender,
  ) {
    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      style: BubbleStyle(
        margin: const BubbleEdges.only(right: 70),
        alignment: Alignment.topLeft,
        nip: BubbleNip.leftTop,
        color: bubbleTheme.receiverBackgroundColor,
        padding: const BubbleEdges.all(10),
        radius: const Radius.circular(20),
      ),
      child: BubbleChildFactory(
        message: message,
        bubbleTheme: bubbleTheme,
        currentUserID: currentUserID,
        isSender: isSender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleTheme = Theme.of(context).extension<BartChatBubbleStyle>();
    final isSender = (message.senderID == currentUserID);
    return message.senderID == currentUserID
        ? buildSenderBubble(context, bubbleTheme!, message, isSender)
        : buildReceiverBubble(context, bubbleTheme!, message, isSender);
  }
}

class BubbleChildFactory extends StatelessWidget {
  const BubbleChildFactory({
    super.key,
    required this.message,
    required this.bubbleTheme,
    required this.currentUserID,
    required this.isSender,
  });

  final Message message;
  final BartChatBubbleStyle bubbleTheme;
  final String currentUserID;
  final bool isSender;

  String formatTime() {
    final time = message.timeSent;
    // get the formatted time in HH:MM AM/PM format
    final formattedTime = time.toDate().toString().substring(11, 16);
    return formattedTime;
  }

  Widget _errorBody(String errorText) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: const AssetImage('assets/images/caution-tape.png'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.40),
              BlendMode.dstIn,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 8.w,
          ),
          child: Text(
            errorText,
            style: TextStyle(
              fontSize: 15.spMin,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _resolveChildBody(BuildContext context) {
    final backgroundColor = isSender
        ? bubbleTheme.senderContextBackgroundColor
        : bubbleTheme.receiverContextBackgroundColor;
    if (message.isSharedTrade!) {
      if (message.extra['tradeContent'] == null ||
          message.extra['tradeContent'].isNull) {
        return _errorBody(
          context.tr('chat.bubble.trade.context.notFoundError'),
        );
      }
      final Trade? thisTrade = message.extra['tradeContent'];
      final UserLocalProfile sender =
          (message.senderID == thisTrade!.tradedItem.itemOwner.userID)
              ? thisTrade.tradedItem.itemOwner
              : thisTrade.offeredItem.itemOwner;
      final String senderText = (currentUserID == sender.userID)
          ? context.tr('chat.bubble.trade.context.subText1')
          : context.tr(
              'chat.bubble.trade.context.subText2',
              namedArgs: {'senderName': sender.userName},
            );
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                senderText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.bold,
                      color: isSender
                          ? bubbleTheme.senderContextTextColor
                          : bubbleTheme.receiverContextTextColor,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                key: UniqueKey(),
                width: 70,
                height: 70,
                imageUrl: thisTrade.tradedItem.imgs[0],
                progressIndicatorBuilder: BartImageTools.progressLoader,
                cacheManager: BartImageTools.customCacheManager,
              ),
            ),
            Transform(
              transform: Matrix4.rotationZ(3.14 / 2),
              alignment: Alignment.center,
              child: const Icon(
                Icons.swap_vertical_circle_outlined,
                applyTextScaling: true,
                size: 30,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                key: UniqueKey(),
                width: 70,
                height: 70,
                imageUrl: thisTrade.offeredItem.imgs[0],
                progressIndicatorBuilder: BartImageTools.progressLoader,
                cacheManager: BartImageTools.customCacheManager,
              ),
            ),
          ],
        ),
      );
    }

    if (message.isSharedItem!) {
      if (message.extra['itemContent'] == null ||
          message.extra['itemContent'].isNull) {
        return _errorBody(
          context.tr('chat.bubble.item.context.notFoundError'),
        );
      }
      final Item thisItem = message.extra['itemContent'];
      final String senderText = isSender
          ? context.tr('chat.bubble.item.context.subText1')
          : context.tr(
              'chat.bubble.item.context.subText2',
              namedArgs: {'senderName': message.senderName},
            );
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: thisItem.imgs[0],
              fit: BoxFit.cover,
              scale: 0.3.dg,
              progressIndicatorBuilder: BartImageTools.progressLoader,
              cacheManager: BartImageTools.customCacheManager,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.subdirectory_arrow_right_rounded,
                  color: isSender
                      ? bubbleTheme.senderContextTextColor
                      : bubbleTheme.receiverContextTextColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    senderText,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize: 10.spMin,
                          fontWeight: FontWeight.bold,
                          color: isSender
                              ? bubbleTheme.senderContextTextColor
                              : bubbleTheme.receiverContextTextColor,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // return empty container if just a normal message
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final timeWidget = Text(
      formatTime(),
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 9.spMin,
            color: isSender
                ? bubbleTheme.senderTextColor
                : bubbleTheme.receiverTextColor,
          ),
    );

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _resolveChildBody(context),
        SizedBox(height: 5.h),
        Text(
          message.text,
          style: bubbleTheme.textStyle.copyWith(
            color: isSender
                ? bubbleTheme.senderTextColor
                : bubbleTheme.receiverTextColor,
          ),
        ),
        isSender
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  timeWidget,
                  SizedBox(width: 5.w),
                  message.isRead!
                      ? Icon(
                          Icons.done_all,
                          size: 14.spMin,
                          color: bubbleTheme.readTickColour,
                        )
                      : Icon(
                          Icons.done,
                          size: 14.spMin,
                          color: bubbleTheme.unreadTickColour,
                        ),
                ],
              )
            : timeWidget,
      ],
    );
  }
}
