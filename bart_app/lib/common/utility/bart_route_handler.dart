import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/utility/bart_firebase_analytics.dart';

class BartRouteHandler {
  /// Checks if the current page can be popped based on both
  /// the current location and the last matched location
  static bool canPop(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location =
        route.routerDelegate.currentConfiguration.last.matchedLocation;
    final stackCheck = route.canPop();
    final pathCheck = location == '/home-trades' ||
        location == '/home-services' ||
        location == '/chat' ||
        location == '/market/listed-items' ||
        location == '/market/services' ||
        location == '/profile';
    final canPop = stackCheck && !pathCheck;
    return canPop;
  }

  static Future<bool?> shouldExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  /// all the functions that are done before the app closes
  static void preExitCallbacks(BuildContext context) {
    final tempProvider = Provider.of<TempStateProvider>(context, listen: false);
    tempProvider.clearAllTempData();
    BartAnalyticsEngine.logAppClose();
  }

  static Widget popHandlerWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final shouldPop =
            await BartRouteHandler.shouldExitDialog(context) ?? false;

        if (context.mounted && shouldPop) {
          context.pop();
        }
      },
      child: child,
    );
  }
}
