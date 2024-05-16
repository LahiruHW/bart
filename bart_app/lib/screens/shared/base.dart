
import 'package:bart_app/common/widgets/side_nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/widgets/bart_appbar.dart';
import 'package:bart_app/common/widgets/bottom_nav_bar.dart';

class Base extends StatefulWidget {
  const Base({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final index = widget.bodyWidget.currentIndex;
    return Scaffold(
      key: globalKey,
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 8,
      extendBody: false,
      appBar: BartAppBar(
        showBackButton: true,
        showTitle: true,
        trailing: IconButton(
          icon: const Icon(Icons.menu),
          style: ButtonStyle(
            // foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
            foregroundColor: WidgetStateProperty.all<Color>(
              Theme.of(context).appBarTheme.foregroundColor!,
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              Colors.transparent,
            ),
          ),
          onPressed: () => globalKey.currentState!.openEndDrawer(),
        ),
      ),
      body: widget.bodyWidget,
      endDrawer: BartSideNavMenu(
        currentIndex: widget.bodyWidget.currentIndex,
      ),
      bottomNavigationBar: BartBottomNavBar(
        navShell: widget.bodyWidget,
        // index: widget.bodyWidget.currentIndex,
        index: index,
        curvedTopEdges: false,
      ),
    );
  }
}
