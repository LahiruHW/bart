import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/common/utility/bart_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class EnterUserNamePageView extends StatefulWidget {
  const EnterUserNamePageView({
    super.key,
    required this.onSubmit,
    required this.loadOverlay,
  });

  final VoidCallback onSubmit;
  final LoadingBlockFullScreen loadOverlay;

  @override
  State<StatefulWidget> createState() => EnterUserNamePageViewState();
}

class EnterUserNamePageViewState extends State<EnterUserNamePageView> {
  late final FocusNode userNameFocusNode;
  late final TextEditingController userNameController;
  late final BartStateProvider stateProvider;

  @override
  void initState() {
    super.initState();
    stateProvider = Provider.of<BartStateProvider>(
      context,
      listen: false,
    );
    userNameFocusNode = FocusNode();
    userNameController = TextEditingController(
      text: stateProvider.userProfile.userName,
    );
  }

  @override
  void dispose() {
    userNameFocusNode.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('onboarding.page.2.1'),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16.spMin,
                fontWeight: FontWeight.normal,
              ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: userNameController,
          focusNode: userNameFocusNode,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 18.spMin,
              ),
          cursorOpacityAnimates: true,
          decoration: InputDecoration(
            hintText: context.tr('onboarding.page.2.2'),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.bolt_outlined),
              onPressed: () {
                setState(() {
                  userNameController.text = BartAuthService.getRandomName();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: OutlinedButton(
            onPressed: () async {
              widget.loadOverlay.show();
              final thisText = userNameController.text.trim();
              if (thisText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  BartSnackBar(
                    icon: Icons.error,
                    message: context.tr('onboarding.page.2.snackbar'),
                    backgroundColor: Colors.amber,
                    appearOnTop: true,
                  ).build(context),
                );
                return;
              }
              if (thisText != stateProvider.userProfile.userName) {
                await stateProvider.doesUserNameExist(thisText).then(
                  (exists) async {
                    if (exists) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        BartSnackBar(
                          icon: Icons.error,
                          message: context.tr('profile.page.username.exists'),
                          backgroundColor: Colors.amber,
                          appearOnTop: true,
                        ).build(context),
                      );
                      return;
                    }
                    await stateProvider.updateUserName(thisText).then(
                      (_) {
                        userNameFocusNode.unfocus();
                        widget.onSubmit();
                        return;
                      },
                    );
                  },
                );
              } else {
                userNameFocusNode.unfocus();
                widget.onSubmit();
              }
              widget.loadOverlay.hide();
            },
            child: Text(context.tr('next')),
          ),
        ),
      ],
    );
  }
}
