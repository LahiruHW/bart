import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/styles/bart_scrollbar_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class EnterFullNamePageView extends StatefulWidget {
  const EnterFullNamePageView({
    super.key,
    required this.onSubmit,
    required this.loadOverlay,
  });

  final VoidCallback onSubmit;
  final LoadingBlockFullScreen loadOverlay;

  @override
  State<StatefulWidget> createState() => EnterFullNamePageViewState();
}

class EnterFullNamePageViewState extends State<EnterFullNamePageView> {
  late final FocusNode fullNameFocusNode;
  late final TextEditingController fullNameController;
  late final BartStateProvider stateProvider;

  @override
  void initState() {
    super.initState();
    stateProvider = Provider.of<BartStateProvider>(
      context,
      listen: false,
    );
    fullNameFocusNode = FocusNode();
    fullNameController = TextEditingController(
      text: stateProvider.userProfile.fullName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollbarTheme = Theme.of(context).extension<BartScrollbarStyle>()!;
    final controller = ScrollController();
    return ScrollbarTheme(
      data: scrollbarTheme.themeData.copyWith(crossAxisMargin: -10),
      child: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                context.tr('onboarding.page.1.1'),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: fullNameController,
                focusNode: fullNameFocusNode,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 18.spMin,
                    ),
                cursorOpacityAnimates: true,
                decoration: InputDecoration(
                  hintText: context.tr('onboarding.page.1.2'),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    final thisText = fullNameController.text.trim();
                    if (thisText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        BartSnackBar(
                          icon: Icons.error,
                          message: context.tr('onboarding.page.1.snackbar'),
                          appearOnTop: true,
                          backgroundColor: Colors.yellow,
                        ).build(context),
                      );
                      return;
                    }
                    widget.loadOverlay.show();
                    await stateProvider.updateFullName(thisText).then(
                      (_) {
                        fullNameFocusNode.unfocus();
                        widget.loadOverlay.hide();
                        widget.onSubmit();
                      },
                    );
                  },
                  child: Text(context.tr('next')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
