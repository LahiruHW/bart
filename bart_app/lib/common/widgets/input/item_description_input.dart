import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionTextField extends StatefulWidget {
  const DescriptionTextField({
    super.key,
    required this.textController,
    this.maxCharCount = 500,
    this.minLines = 8,
    this.maxLines = 18,
    this.showSendButton = false,
    this.focusNode,
    this.onSend,
    this.isSending = false,
  }) : assert(showSendButton == false || onSend != null);

  final TextEditingController textController;
  final int maxCharCount;
  final int minLines;
  final int maxLines;
  final bool showSendButton;
  final FocusNode? focusNode;
  final VoidCallback? onSend;
  final bool isSending;

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      focusNode: widget.focusNode ?? FocusNode(),
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxCharCount,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 14.spMin,
            fontWeight: FontWeight.normal,
          ),
      cursorOpacityAnimates: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 14.spMin,
              fontWeight: FontWeight.normal,
            ),
        suffixIcon: widget.showSendButton
            ? Column(
                children: !widget.isSending
                    ? [
                        IconButton(
                          onPressed: widget.onSend,
                          icon: const Icon(Icons.send),
                        ),
                        Text(
                          "send",
                          style: TextStyle(
                            fontSize: 14.spMin,
                          ),
                        )
                      ]
                    : [
                        const IconButton(
                          onPressed: null,
                          isSelected: false,
                          disabledColor: Colors.grey,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.more_horiz),
                        ),
                        Text(
                          "sending",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.spMin,
                          ),
                        )
                      ],
              )
            : null,
      ),
    );
  }
}
