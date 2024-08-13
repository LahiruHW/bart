import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputGroup extends StatefulWidget {
  const ChatInputGroup({
    super.key,
    this.onSend,
    this.controller,
    required this.focusNode,
  });

  final VoidCallback? onSend;
  final TextEditingController? controller;
  final FocusNode focusNode;

  @override
  State<ChatInputGroup> createState() => _ChatInputGroupState();
}

class _ChatInputGroupState extends State<ChatInputGroup> {
  @override
  Widget build(BuildContext context) {
    // the typing area
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SizedBox.fromSize(
        size: const Size(double.infinity, 75),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: TextFormField(
                focusNode: widget.focusNode,
                controller: widget.controller,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.normal,
                    ),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.normal,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(width: 0.2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: IconButton.filled(
                icon: const Icon(Icons.send),
                padding: const EdgeInsets.all(20),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                onPressed: widget.onSend ?? () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
