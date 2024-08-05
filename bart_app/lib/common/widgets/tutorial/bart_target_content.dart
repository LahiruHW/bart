import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/styles/bart_tutorial_content_style.dart';

class BartTargetContent extends StatefulWidget {
  const BartTargetContent({
    super.key,
    required this.text,
    this.extraContent,
    this.skipText, // "Skip" or "Finish"
    this.previousText, // "Back"
    this.nextText, // "Next"
    this.onSkip,
    this.onPrevious,
    this.onNext,
    this.showPreviousBtn = true,
    this.showSkipBtn = true,
    this.showNextBtn = true,
  }) : assert(((showPreviousBtn == true &&
                    onPrevious != null &&
                    previousText != null) ||
                (showPreviousBtn == false)) &&
            ((showSkipBtn == true && onSkip != null && skipText != null) ||
                (showSkipBtn == false)) &&
            ((showNextBtn == true && onNext != null && nextText != null) ||
                (showNextBtn == false)));

  final String text;
  final Widget? extraContent;
  final String? skipText;
  final String? previousText;
  final String? nextText;
  final VoidCallback? onSkip;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool showSkipBtn;
  final bool showPreviousBtn;
  final bool showNextBtn;

  @override
  State<BartTargetContent> createState() => _BartTargetContentState();
}

class _BartTargetContentState extends State<BartTargetContent> {
  @override
  Widget build(BuildContext context) {
    final contentStyle =
        Theme.of(context).extension<BartTutorialContentStyle>()!;
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: contentStyle.contentBackgroundColour,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              color: contentStyle.contentTextColour,
              fontSize: 16.spMin,
            ),
          ),
          widget.extraContent ?? const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.showSkipBtn
                  ? TextButton(
                      onPressed: widget.onSkip,
                      child: Text(
                        widget.skipText!,
                        style: TextStyle(
                          color: contentStyle.buttonTextColor,
                          fontSize: 18.spMin,
                        ),
                      ),
                    )
                  : const SizedBox(width: 1),
              const Spacer(),
              widget.showPreviousBtn
                  ? TextButton(
                      onPressed: widget.onPrevious!,
                      child: Text(
                        widget.previousText!,
                        style: TextStyle(
                          color: contentStyle.buttonTextColor,
                          fontSize: 18.spMin,
                        ),
                      ),
                    )
                  : const SizedBox(width: 1),
              widget.showNextBtn
                  ? TextButton(
                      onPressed: widget.onNext!,
                      child: Text(
                        widget.nextText!,
                        style: TextStyle(
                          color: contentStyle.buttonTextColor,
                          fontSize: 18.spMin,
                        ),
                      ),
                    )
                  : const SizedBox(width: 1),
            ],
          ),
        ],
      ),
    );
  }
}
