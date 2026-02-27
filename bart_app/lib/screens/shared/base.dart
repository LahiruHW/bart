import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/widgets/bart_appbar.dart';
import 'package:bart_app/common/widgets/side_nav_rail.dart';
import 'package:bart_app/common/widgets/bottom_nav_bar.dart';
import 'package:bart_app/common/widgets/side_nav_drawer.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';

class Base extends StatefulWidget {
  const Base({
    super.key,
    required this.bodyWidget,
    this.borderPadding = 10,
  });

  final StatefulNavigationShell bodyWidget;
  static final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  final double borderPadding;

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    final index = widget.bodyWidget.currentIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // portrait mode
        if (w <= h) {
          return Scaffold(
            key: Base.globalKey,
            drawerEnableOpenDragGesture: true,
            drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.15,
            drawerDragStartBehavior: DragStartBehavior.start,
            extendBody: false,
            appBar: (!kIsWeb)
                ? BartAppBar(
                    showTitle: true,
                    trailing: IconButton(
                      key: BartTuteWidgetKeys.appBarHamburgerMenu,
                      icon: const Icon(Icons.menu),
                      style: ButtonStyle(
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).appBarTheme.foregroundColor!,
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () =>
                          Base.globalKey.currentState!.openEndDrawer(),
                    ),
                  )
                : null,
            body: widget.bodyWidget,
            endDrawer: BartSideNavMenu(
              currentIndex: widget.bodyWidget.currentIndex,
            ),
            bottomNavigationBar: BartBottomNavBar(
              navShell: widget.bodyWidget,
              index: index,
              curvedTopEdges: false,
            ),
          );
        }

        // landscape mode
        else {
          return Scaffold(
            key: Base.globalKey,
            backgroundColor: Colors.grey,
            body: Row(
              children: [
                Container(
                  // margin: EdgeInsets.only(
                  //   left: widget.borderPadding,
                  //   top: widget.borderPadding,
                  //   bottom: widget.borderPadding,
                  // ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BartSideNavRail(
                    bodyWidget: widget.bodyWidget,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.all(widget.borderPadding),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      // color: Colors.blue.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: widget.bodyWidget,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
