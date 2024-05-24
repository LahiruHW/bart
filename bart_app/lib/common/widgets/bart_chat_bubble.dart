import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:bart_app/common/entity/message.dart';
import 'package:bart_app/styles/bart_chat_bubble_style.dart';
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
      ),
    );
  }

  Widget buildReceiverBubble(
    BuildContext context,
    BartChatBubbleStyle bubbleTheme,
    Message msg,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleTheme = Theme.of(context).extension<BartChatBubbleStyle>();
    return message.senderID == currentUserID
        ? buildSenderBubble(context, bubbleTheme!, message)
        : buildReceiverBubble(context, bubbleTheme!, message);
  }
}

class BubbleChildFactory extends StatelessWidget {
  const BubbleChildFactory({
    super.key,
    required this.message,
    required this.bubbleTheme,
    required this.currentUserID,
  });

  final Message message;
  final BartChatBubbleStyle bubbleTheme;
  final String currentUserID;

  String formatTime() {
    final time = message.timeSent;
    // get the formatted time in HH:MM AM/PM format
    final formattedTime = time.toDate().toString().substring(11, 16);
    return formattedTime;
  }

  Widget _resolveChildBody(BuildContext context) {
    final backgroundColor = (message.senderID == currentUserID)
        ? Colors.white
        : bubbleTheme.senderBackgroundColor;

    if (message.isSharedTrade!) {
      final Trade thisTrade = message.extra['tradeContent'];
      final UserLocalProfile sender =
          (message.senderID == thisTrade.tradedItem.itemOwner.userID)
              ? thisTrade.tradedItem.itemOwner
              : thisTrade.offeredItem.itemOwner;
      final String senderText = (currentUserID == sender.userID)
          ? "You asked about this trade"
          : "${sender.userName} is asking about this trade";
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
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
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: (message.senderID == currentUserID)
                          ? bubbleTheme.senderTextColor
                          : bubbleTheme.receiverBackgroundColor,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: CachedNetworkImage(
                width: 70,
                height: 70,
                imageUrl: thisTrade.tradedItem.imgs[0],
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
                width: 70,
                height: 70,
                imageUrl: thisTrade.offeredItem.imgs[0],
              ),
            ),
          ],
        ),
      );
    }

    if (message.isSharedItem!) {
      final Item thisItem = message.extra['itemContent'];
      final String senderText = (message.senderID == currentUserID)
          ? "You asked about this item"
          : "${message.senderName} is asking about this item";
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: thisItem.imgs[0],
              fit: BoxFit.contain,
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.subdirectory_arrow_right_rounded,
                  color: (message.senderID == currentUserID)
                      ? bubbleTheme.senderTextColor
                      : bubbleTheme.receiverBackgroundColor,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    senderText,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: (message.senderID == currentUserID)
                              ? bubbleTheme.senderTextColor
                              : bubbleTheme.receiverBackgroundColor,
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
    return Column(
      crossAxisAlignment: (message.senderID == currentUserID)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        _resolveChildBody(context),
        const SizedBox(height: 5),
        Text(
          message.text,
          style: bubbleTheme.textStyle.copyWith(
            color: (message.senderID == currentUserID)
                ? bubbleTheme.senderTextColor
                : bubbleTheme.receiverTextColor,
          ),
        ),
        Text(
          formatTime(),
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 10,
                color: (message.senderID == currentUserID)
                    ? bubbleTheme.senderTextColor
                    : bubbleTheme.receiverTextColor,
              ),
        ),
      ],
    );
  }
}
