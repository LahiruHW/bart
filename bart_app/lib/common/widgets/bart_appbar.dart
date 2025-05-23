import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/utility/bart_route_handler.dart';

const statusBarHeight = 35.0;

class BartAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A custom appbar for the "bart." app that uses the [NavigationToolbar] widget
  /// that deals with the positioning of the [leading], [middle] and [trailing] widgets
  const BartAppBar({
    super.key,
    this.showTitle = true,
    this.trailing,
  });

  final bool showTitle;
  final Widget? trailing;

  final transparentDeco = const BoxDecoration(
    color: Colors.transparent,
  );

  @override
  Widget build(BuildContext context) {
    final canPopCurrent = BartRouteHandler.canPop(context);
    final shouldShowED = BartRouteHandler.shouldShowExitDialog(context);
    const showED = BartRouteHandler.showExitDialog;
    return Material(
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      elevation: 7,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
            ),
          ),
          Column(
            children: [
              if (!kIsWeb)
                Container(
                  height: statusBarHeight,
                  width: double.infinity,
                  decoration: transparentDeco,
                ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      ),
                    ),
                    NavigationToolbar(
                      centerMiddle: true,
                      leading: (canPopCurrent)
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back),
                              style: ButtonStyle(
                                iconColor: WidgetStateProperty.all<Color>(
                                  Theme.of(context)
                                      .appBarTheme
                                      .foregroundColor!,
                                ),
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent,
                                ),
                              ),
                              onPressed: () async {
                                if (canPopCurrent) {
                                  if (shouldShowED) {
                                    final shouldPop = await showED(context);
                                    if (shouldPop! && context.mounted) {
                                      context.pop();
                                    }
                                  } else {
                                    context.mounted ? context.pop() : null;
                                  }
                                }
                              },
                            )
                          : null,
                      middle: showTitle
                          ? Text(
                              "bart.",
                              style:
                                  Theme.of(context).appBarTheme.titleTextStyle,
                            )
                          : null,
                      trailing: trailing,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // i.e. get the (width, height) of the appbar
  @override
  Size get preferredSize =>
      // kIsWeb ? Size(double.infinity, 75.h) : const Size(double.infinity, 55);
      const Size(double.infinity, 55);
      // const Size(double.infinity, 70);
}
