import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/index.dart';
import 'package:bart_app/common/providers/state_provider.dart';

/// Base Shell for the Home Tab that switches between the legacy UI and the new UI
class HomePageBase extends StatefulWidget {
  const HomePageBase({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;

  @override
  State<HomePageBase> createState() => _HomePageBaseState();
}

class _HomePageBaseState extends State<HomePageBase> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BartStateProvider>(
      builder: (context, stateProvider, child) =>
          stateProvider.userProfile.settings!.isLegacyUI
              ? const HomePageV1()
              : HomePageV2(
                  bodyWidget: widget.bodyWidget,
                ),
    );
  }
}
