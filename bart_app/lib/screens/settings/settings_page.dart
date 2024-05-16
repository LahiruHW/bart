import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/common/utility/bart_app_version_data.dart';
import 'package:bart_app/common/widgets/input/colour_switch_toggle.dart';
import 'package:bart_app/common/widgets/input/language_switch_toggle.dart';

const statusBarHeight = 35.0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () => GoRouter.of(context).pop(),
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
            // ListTile(
            //   leading: const Icon(Icons.privacy_tip),
            //   title: const Text('Privacy'),
            //   titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            //   onTap: null,
            // ),
            // ListTile(
            //   leading: const Icon(Icons.notifications_none_outlined),
            //   title: const Text('Notifications'),
            //   titleTextStyle: Theme.of(context).textTheme.headlineSmall,
            //   onTap: null,
            // ),
            ExpansionTile(
              leading: const Icon(Icons.design_services_outlined),
              title: Text(
                context.tr('personalisation.header'),
                style: Theme.of(context).textTheme.headlineSmall,
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
            ExpansionTile(
              leading: const Icon(Icons.info),
              title: Text(
                context.tr('about.header'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              maintainState: false,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    // 'Bart is a mobile application that aims to provide a platform for users to buy, sell or barter goods and services.\n',
                    context.tr('about.text'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    // '${BartAppVersionData.appName} (Version ${BartAppVersionData.version} Build ${BartAppVersionData.buildNumber})',
                    
                    context.tr('app.version.info', namedArgs: {
                      'versionNum' : BartAppVersionData.version,
                      'buildNum' : BartAppVersionData.buildNumber,
                    }),
                    
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            // Text(
            //   BartAppVersionData.packageName,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
