import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:bart_app/common/entity/message.dart';
import 'package:bart_app/styles/bart_chat_bubble_style.dart';

class BartChatBubble extends StatelessWidget {
  const BartChatBubble({
    super.key,
    required this.message,
    required this.currentUserID,
  });

  final Message message;
  final String currentUserID;

  String formatTime() {
    final time = message.timeSent;
    // get the formatted time in HH:MM AM/PM format
    final formattedTime = time.toDate().toString().substring(11, 16);
    return formattedTime;
  }

  // TODO:_ function to build the message
  // TODO:_ function to build sender message bubble
  // TODO:_ function to build receiver message bubble

  @override
  Widget build(BuildContext context) {
    final bubbleTheme = Theme.of(context).extension<BartChatBubbleStyle>();

    return Bubble(
      margin: const BubbleEdges.only(top: 10),
      style: BubbleStyle(
        margin: message.senderID == currentUserID
            ? const BubbleEdges.only(left: 70)
            : const BubbleEdges.only(right: 70),
        alignment: message.senderID == currentUserID
            ? Alignment.topRight
            : Alignment.topLeft,
        nip: message.senderID == currentUserID
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        // color: message.senderID == currentUserID ? Colors.blue : Colors.grey,
        color: message.senderID == currentUserID
            ? bubbleTheme!.senderBackgroundColor
            : bubbleTheme!.receiverBackgroundColor,
        padding: const BubbleEdges.all(10),
        radius: const Radius.circular(20),
      ),
      // child: Text(message.text),
      child: Column(
        crossAxisAlignment: message.senderID == currentUserID
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: bubbleTheme.textStyle.copyWith(
              color: message.senderID == currentUserID
                  ? bubbleTheme.senderTextColor
                  : bubbleTheme.receiverTextColor,
            ),
          ),
          Text(
            formatTime(),
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontSize: 10,
                  color: message.senderID == currentUserID
                      ? bubbleTheme.senderTextColor
                      : bubbleTheme.receiverTextColor,
                ),
          )
        ],
      ),
    );
  }
}
