import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_app_version_data.dart';
// import 'package:bart_app/common/constants/tutorial_widget_keys.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/colour_switch_toggle.dart';
import 'package:bart_app/common/widgets/input/language_switch_toggle.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

const statusBarHeight = 35.0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.beginAllExpanded,
  });
  final bool beginAllExpanded;
  static final GlobalKey<ScaffoldState> globalKey = GlobalKey();
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _deleteDialog(BuildContext parentContext, BartStateProvider provider) {
    final loadingOverlay = LoadingBlockFullScreen(
      context: parentContext,
      dismissable: false,
    );
    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('my.account.delete.dialog.header'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('my.account.delete.dialog.body1'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                context.tr('my.account.delete.dialog.body2'),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              context.tr('no'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              loadingOverlay.show();
              await BartFirestoreServices.deleteUserProfile(
                provider.userProfile.userID,
              ).then(
                (value) async {
                  await provider.deleteAccount().then(
                    (value) {
                      loadingOverlay.hide();
                      if (value) {
                        parentContext.go('/login-base');
                      } else {
                        throw Exception('Account deletion failed');
                      }
                    },
                  );
                },
              );
            },
            child: Text(context.tr('yes')),
          ),
        ],
      ),
    );
  }

  void _showMyDataDialog(BuildContext context, BartStateProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          context.tr('my.account.show.my.data.dialog.header'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('my.account.show.my.data.dialog.body1'),
            ),
            const SizedBox(height: 10),
            Text(
              context.tr('my.account.show.my.data.dialog.body2'),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                context.tr('my.account.show.my.data.dialog.body3'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              BartFirestoreServices.makeDataRequest(
                provider.userProfile.userID,
              ).then(
                (_) {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    BartSnackBar(
                      message: context.tr('my.account.show.my.data.snackbar1'),
                      icon: Icons.check_circle_outline_rounded,
                      backgroundColor: Colors.green,
                    ).build(context),
                  );
                },
              );
            },
            child: Text(
              context.tr('yes'),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              context.tr('no'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Theme(
      data: theme,
      child: Scaffold(
        key: SettingsPage.globalKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: statusBarHeight,
                width: double.infinity,
              ),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: NavigationToolbar(
                  centerMiddle: false,
                  leading: IconButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: () => context.pop(),
                  ),
                  middle: Text(
                    context.tr('settings.page.title'),
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .computeLuminance() >
                                  0.5
                              ? Colors.black
                              : Colors.white,
                        ),
                  ),
                ),
              ),
              ExpansionTile(
                // key: BartTuteWidgetKeys.settingsPagePersonalisation,
                initiallyExpanded: widget.beginAllExpanded,
                leading: const Icon(Icons.design_services_outlined),
                title: Text(
                  context.tr('personalisation.header'),
                ),
                maintainState: true,
                children: [
                  ListTile(
                    title: Text(context.tr('dark.mode.label')),
                    trailing: const SizedBox(
                      width: 100,
                      height: 40,
                      child: BartThemeModeToggle(),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      context.tr('language.label'),
                      maxLines: 1,
                    ),
                    trailing: const SizedBox(
                      width: 100,
                      height: 40,
                      child: BartLocaleToggle(),
                    ),
                  ),
                ],
              ),
              Consumer<BartStateProvider>(
                builder: (context, provider, child) => ExpansionTile(
                  initiallyExpanded: widget.beginAllExpanded,
                  leading: const Icon(Icons.person_outline_outlined),
                  title: Text(
                    context.tr('my.account.header'),
                  ),
                  maintainState: true,
                  children: [
                    Material(
                      color: Theme.of(context).listTileTheme.tileColor,
                      child: InkWell(
                        child: ListTile(
                          isThreeLine: true,
                          title:
                              Text(context.tr('my.account.show.my.data.top')),
                          subtitle: Text(
                            context.tr('my.account.show.my.data.bottom'),
                          ),
                          onTap: () => _showMyDataDialog(context, provider),
                          enableFeedback: true,
                        ),
                      ),
                    ),
                    Material(
                      child: InkWell(
                        onLongPress: () => _deleteDialog(context, provider),
                        child: ListTile(
                          title: Text(
                            context.tr('my.account.delete.top'),
                            style: const TextStyle(color: Colors.red),
                          ),
                          subtitle: Text(
                            context.tr('my.account.delete.bottom'),
                            style: const TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              BartSnackBar(
                                icon: Icons.info_outline_rounded,
                                message:
                                    context.tr('my.account.delete.snackbar1'),
                                backgroundColor: Colors.amber,
                              ).build(context),
                            );
                          },
                          enabled: true,
                          enableFeedback: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_rounded),
                title: Text(
                  context.tr('privacy.policy.header'),
                ),
                onTap: () => context.push(
                  '/privacyPolicy',
                  extra:
                      'assets/translations/${context.tr('privacy.policy.fileName')}',
                ),
              ),
              ExpansionTile(
                initiallyExpanded: widget.beginAllExpanded,
                leading: const Icon(Icons.info),
                title: Text(
                  context.tr('about.header'),
                ),
                maintainState: false,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      context.tr('about.text'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      context.tr('app.version.info', namedArgs: {
                        'versionNum': BartAppVersionData.version,
                        'buildNum': BartAppVersionData.buildNumber,
                      }),
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
