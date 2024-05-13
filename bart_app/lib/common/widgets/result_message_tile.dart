import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TradeResultMessageTile extends StatelessWidget {
  const TradeResultMessageTile({
    super.key,
    required this.messageHeading,
    required this.message,
    required this.isSuccessful,
  });

  final String messageHeading;
  final String message;
  final bool isSuccessful;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        // margin: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 20,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.background.computeLuminance() > 0.5
                  ? Colors.white
                  : Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 0.1,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              messageHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: isSuccessful ? Colors.green : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 20, color: Colors.transparent),
            (isSuccessful
                    ? const Icon(Icons.check_circle,
                        color: Colors.green, size: 100)
                    : const Icon(Icons.cancel, color: Colors.red, size: 100))
                .animate()
                .rotate(
                  begin: 0.0,
                  end: 1.0,
                  curve: Curves.easeInOutCubic,
                  delay: 500.ms,
                  duration: 1000.ms,
                )
                .scaleXY(
                  begin: 0.0,
                  end: 1.0,
                  curve: Curves.easeInOutCubic,
                  delay: 500.ms,
                  duration: 1000.ms,
                ),
            const Divider(height: 20, color: Colors.transparent),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: isSuccessful ? Colors.green : Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
