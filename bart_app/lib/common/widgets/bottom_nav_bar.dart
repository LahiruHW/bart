import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/utility/clipper_bottom_navbar.dart';

// https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/

class BartBottomNavBar extends StatefulWidget {
  const BartBottomNavBar({
    super.key,
    this.index,
    this.curvedTopEdges = false,
    required this.navShell,
  });

  final int? index;
  final StatefulNavigationShell navShell;
  final double edgeRadius = 30;

  /// if this is true, the [extendBody] property of the [Scaffold]
  /// widget in the [Base] class should be set to true
  final bool curvedTopEdges;

  @override
  State<BartBottomNavBar> createState() => _BartBottomNavBarState();
}

class _BartBottomNavBarState extends State<BartBottomNavBar> {
  late int selectedIndex = 0;

  void _onTappedNew(BuildContext context, int index) {
    final isInitLocation = (index == widget.navShell.currentIndex);
    widget.navShell.goBranch(
      index,
      initialLocation: isInitLocation,
    );
    setState(() => selectedIndex = index);
  }

  void _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/home')) {
      setState(() => selectedIndex = 0);
    } else if (location.startsWith('/chat')) {
      setState(() => selectedIndex = 1);
    } else if (location.startsWith('/market')) {
      setState(() => selectedIndex = 2);
    } else if (location.startsWith('/profile')) {
      setState(() => selectedIndex = 3);
    } else {
      setState(() => selectedIndex = 0);
    }
  }

  BottomNavigationBar buildNormalBottomNavBar(BuildContext context) {
    _calculateSelectedIndex(context);
    return BottomNavigationBar(
      elevation: Theme.of(context).bottomNavigationBarTheme.elevation,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      currentIndex: selectedIndex,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home_sharp),
          label: context.tr('bottom.navbar.home'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_outlined),
          activeIcon: const Icon(Icons.chat_rounded),
          label: context.tr('bottom.navbar.chat'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_bag_outlined),
          activeIcon: const Icon(Icons.shopping_bag_rounded),
          label: context.tr('bottom.navbar.market'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline_rounded),
          activeIcon: const Icon(Icons.person_rounded),
          label: context.tr('bottom.navbar.profile'),
        ),
      ],
      onTap: (index) => _onTappedNew(context, index),
    );
  }

  Widget buildTopCurvedBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(widget.edgeRadius),
          topLeft: Radius.circular(widget.edgeRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        clipper: BottomNavBarClipper(edgeRadius: widget.edgeRadius),
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.edgeRadius),
          topRight: Radius.circular(widget.edgeRadius),
        ),
        child: buildNormalBottomNavBar(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Theme.of(context).brightness == Brightness.dark
            ? BartAppTheme.black2
            : Colors.white,
        splashFactory: null,
      ),
      child: widget.curvedTopEdges
          ? buildTopCurvedBottomNavBar(context)
          : buildNormalBottomNavBar(context),

      // Container(
      //   decoration: BoxDecoration(
      //     color: Colors.red,
      //     borderRadius: BorderRadius.only(
      //       topRight: Radius.circular(widget.edgeRadius),
      //       topLeft: Radius.circular(widget.edgeRadius),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.25),
      //         spreadRadius: 0,
      //         blurRadius: 5,
      //       ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     clipper: BottomNavBarClipper(edgeRadius: widget.edgeRadius),
      //     clipBehavior: Clip.antiAlias,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(widget.edgeRadius),
      //       topRight: Radius.circular(widget.edgeRadius),
      //     ),
      //     child: BottomNavigationBar(
      //       elevation: Theme.of(context).bottomNavigationBarTheme.elevation,
      //       backgroundColor:
      //           Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      //       currentIndex: selectedIndex,
      //       showUnselectedLabels: false,
      //       items: const <BottomNavigationBarItem>[
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.home_outlined),
      //           activeIcon: Icon(Icons.home_sharp),
      //           label: 'Home',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.chat_outlined),
      //           activeIcon: Icon(Icons.chat_rounded),
      //           label: 'Chat',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.shopping_bag_outlined),
      //           activeIcon: Icon(Icons.shopping_bag_rounded),
      //           label: 'Market',
      //         ),
      //       ],
      //       onTap: (index) => _onTappedNew(context, index),
      //     ),
      //   ),
      // ),
    );
  }
}
