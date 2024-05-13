import 'package:flutter/material.dart';

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
  }) : assert(showSendButton == false || onSend != null);

  final TextEditingController textController;
  final int maxCharCount;
  final int minLines;
  final int maxLines;
  final bool showSendButton;
  final FocusNode? focusNode;
  final VoidCallback? onSend;

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
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        // hintText: 'Description',
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
        suffixIcon: widget.showSendButton
            ? Column(
                children: [
                  IconButton(
                    onPressed: widget.onSend,
                    icon: const Icon(Icons.send),
                  ),
                  const Text("send")
                ],
              )
            : null,
      ),
    );
  }
}
