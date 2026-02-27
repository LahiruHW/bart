import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BartSideNavRail extends StatefulWidget {
  const BartSideNavRail({
    super.key,
    required this.bodyWidget,
  });

  final StatefulNavigationShell bodyWidget;

  @override
  State<BartSideNavRail> createState() => _BartSideNavRailState();
}

class _BartSideNavRailState extends State<BartSideNavRail> {
  int selectedIndex = 0;
  bool isExtended = true;
  bool isLocked = false;

  void _onTappedNew(BuildContext context, int index) {
    final isInitLocation = (index == widget.bodyWidget.currentIndex);
    widget.bodyWidget.goBranch(
      index,
      initialLocation: isInitLocation,
    );
    setState(() => selectedIndex = index);
  }

  // void _calculateSelectedIndex(BuildContext context) {
  //   final GoRouter route = GoRouter.of(context);
  //   final String location = route.routerDelegate.currentConfiguration.fullPath;
  //   if (location.startsWith('/home')) {
  //     setState(() => selectedIndex = 0);
  //   } else if (location.startsWith('/chat')) {
  //     setState(() => selectedIndex = 1);
  //   } else if (location.startsWith('/market')) {
  //     setState(() => selectedIndex = 2);
  //   } else if (location.startsWith('/profile')) {
  //     setState(() => selectedIndex = 3);
  //   } else {
  //     setState(() => selectedIndex = 0);
  //   }
  // }

  void toggleNavRail() {
    if (!isLocked) setState(() => isExtended = !isExtended);
  }

  // void toggleNavRailLock() {
  //   setState(() => isLocked = !isLocked);
  // }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.none,
      selectedLabelTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontSize: 18.spMin,
          ),
      unselectedLabelTextStyle:
          Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 18.spMin,
              ),
      extended: isExtended,

      // minWidth: 50,
      // minExtendedWidth: 100,

      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        child: Text(
          'bart.',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 30.spMin,
                color: Theme.of(context).navigationRailTheme.indicatorColor,
              ),
        ),
      ),
      onDestinationSelected: (index) => _onTappedNew(context, index),
      
      destinations: [
        NavigationRailDestination(
          // key: BartTuteWidgetKeys.bottomNavBarHome,
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_sharp),
          label: Text(context.tr('bottom.navbar.home')),
        ),
        NavigationRailDestination(
          // key: BartTuteWidgetKeys.bottomNavBarChats,
          icon: const Icon(Icons.chat_outlined),
          selectedIcon: const Icon(Icons.chat_rounded),
          label: Text(context.tr('bottom.navbar.chat')),
        ),
        NavigationRailDestination(
          // key: BartTuteWidgetKeys.bottomNavBarMarket,
          icon: const Icon(Icons.shopping_bag_outlined),
          selectedIcon: const Icon(Icons.shopping_bag_rounded),
          label: Text(context.tr('bottom.navbar.market')),
        ),
        NavigationRailDestination(
          // key: BartTuteWidgetKeys.bottomNavBarProfile,
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: Text(context.tr('bottom.navbar.profile')),
        ),
      ],
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () => context.push(
                    '/settings',
                    extra: {'beginAllExpanded': false},
                  ),
                  icon: const Icon(Icons.settings_outlined),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: toggleNavRail,
                  icon: isExtended
                      ? const Icon(Icons.arrow_back_ios_new_rounded)
                      : const Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
      selectedIndex: selectedIndex,
    );
  }
}
