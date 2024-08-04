import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/screens/shared/base.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/widgets/tutorial/bart_tutorial_coach.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class BartSideNavMenu extends StatelessWidget {
  const BartSideNavMenu({
    super.key,
    this.currentIndex,
  });

  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    final loadingOverlay = LoadingBlockFullScreen(
      context: context,
      dismissable: false,
    );

    return Consumer<BartStateProvider>(
      builder: (context, stateProvider, child) => NavigationDrawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        children: [
          Container(
            width: double.infinity,
            height: 75,
            padding: const EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'bart.',
              textAlign: TextAlign.start,
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            leading: const Icon(Icons.tour_outlined),
            title: Text(context.tr('tute.start.header')),
            subtitle: Text(context.tr('tute.start.subHeader')),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            onTap: () {
              Base.globalKey.currentState!.closeEndDrawer();
              BartAnalyticsEngine.userBeginsTutorial();
              Future.delayed(
                const Duration(milliseconds: 200),
                () => context.go('/home'),
              ).then(
                (val) => BartTutorialCoach.showTutorial(
                  Base.globalKey.currentContext!,
                ),
              );
            },
          ),
          ListTile(
            key: BartTuteWidgetKeys.sideNavMenuSettings,
            contentPadding: const EdgeInsets.only(left: 20),
            leading: const Icon(Icons.settings_outlined),
            title: Text(context.tr('side.navmenu.settings')),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            onTap: () => GoRouter.of(context).push('/settings', extra: {'beginAllExpanded': false}),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(context.tr('side.navmenu.logout')),
            titleTextStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            onTap: () async {
              loadingOverlay.show();

              // Future.delayed(
              //   const Duration(milliseconds: 0),
              //   () => GoRouter.of(context).go('/login-base'),
              // ).then(
              //   (value) {
              //     Future.delayed(
              //       const Duration(milliseconds: 3000), // was 3500 before
              //       () => stateProvider.signOut(),
              //     );
              //     // stateProvider.clearUserProfileInstance();  <------ this should go here
              //   },
              // );

              await stateProvider.signOut().then(
                (value) {
                  if (value) {
                    Future.delayed(
                      const Duration(milliseconds: 2000),
                      () {
                        loadingOverlay.hide();
                        GoRouter.of(context).go('/login-base');
                      },
                    );
                  } else {
                    loadingOverlay.hide();
                    // TODO:_ SHOW ERROR MESSAGE HERE
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
