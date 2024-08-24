import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/widgets/bart_appbar.dart';
import 'package:bart_app/common/widgets/bottom_nav_bar.dart';
import 'package:bart_app/common/widgets/side_nav_drawer.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';

class Base extends StatefulWidget {
  const Base({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;
  static final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    final index = widget.bodyWidget.currentIndex;
    return Scaffold(
      key: Base.globalKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3,
      drawerDragStartBehavior: DragStartBehavior.start,
      extendBody: false,
      appBar: BartAppBar(
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
          onPressed: () => Base.globalKey.currentState!.openEndDrawer(),
        ),
      ),
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
}
