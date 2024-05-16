import 'package:flutter/material.dart';

class ExchangeIcon extends StatelessWidget {
  const ExchangeIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        transform: Matrix4.rotationZ(3.14 / 2),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
            width: 5,
          ),
        ),
        child: Icon(
          Icons.compare_arrows_rounded,
          color: Theme.of(context).colorScheme.surface.computeLuminance() > 0.5
              ? Colors.black.withOpacity(0.5)
              : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}
