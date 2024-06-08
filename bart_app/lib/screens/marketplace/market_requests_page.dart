import 'package:flutter/material.dart';

class MarketRequestsPage extends StatelessWidget {
  const MarketRequestsPage({
    super.key,
    required this.parentContext,
  });

  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'Requests\nstill in progress (...sigh)',
          textAlign: TextAlign.center,
        ),
      );
  }
}
