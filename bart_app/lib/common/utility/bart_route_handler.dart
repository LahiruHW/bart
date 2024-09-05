import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';

class BartRouteHandler {
  static final List<String> warningRouteList = [
    'newItem',
    'returnItem',
    'editItem',
    'editTrade',
  ];

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

  static Future<bool?> showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      // barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return AlertDialog(
          title: Text(context.tr("pre.exit.dialog.header")),
          content: Text(context.tr('pre.exit.dialog.body')),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              child: Text(context.tr('no')),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelSmall,
              ),
              child: Text(context.tr('yes')),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  /// only used in the appbar to check if the exit dialog should be shown
  static bool shouldShowExitDialog(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location =
        route.routerDelegate.currentConfiguration.last.matchedLocation;
    for (final i in warningRouteList) {
      if (location.endsWith(i)) {
        return true;
      }
    }
    return false;
  }

  static Widget popHandlerWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await preExitWarning(context);
        if (shouldPop && context.mounted) context.pop();
      },
      child: child,
    );
  }

  //
  static Future<bool> preExitWarning(BuildContext context) async {
    final shouldPop = await BartRouteHandler.showExitDialog(context) ?? false;
    if (context.mounted && shouldPop) {
      preExitCallbacks(context);
      return true;
    }
    return false;
  }

  /// all the functions that are done before the app closes
  static void preExitCallbacks(BuildContext context) {
    final tempProvider = Provider.of<TempStateProvider>(context, listen: false);
    tempProvider.clearAllTempData();
  }

  static Widget popResistantWrapper({required Widget child}) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => false,
      child: child,
    );
  }
}
