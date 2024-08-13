import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';

class EnterFullNamePageView extends StatefulWidget {
  const EnterFullNamePageView({
    super.key,
    required this.onSubmit,
  });

  final VoidCallback onSubmit;

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
    return Column(
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
            onPressed: () {
              if (fullNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  BartSnackBar(
                    icon: Icons.error,
                    message: context.tr('onboarding.page.1.snackbar'),
                    appearOnTop: true,
                    backgroundColor: Colors.red,
                  ).build(context),
                );
                return;
              }
              stateProvider.updateFullName(fullNameController.text.trim());
              fullNameFocusNode.unfocus();
              widget.onSubmit();
            },
            child: Text(context.tr('next')),
          ),
        ),
      ],
    );
  }
}
