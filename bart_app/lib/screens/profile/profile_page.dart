import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_image_tools.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_text.dart';
import 'package:bart_app/styles/bart_profile_page_colour_style.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';
import 'package:bart_app/common/widgets/shimmer/shimmer_profile_info_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _userNameController;
  late final FocusNode _userNameFocusNode;
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  late bool _isEditingUserName;
  late bool _isEditingName;

  @override
  void initState() {
    super.initState();
    _isEditingUserName = false;
    _userNameFocusNode = FocusNode();
    _userNameController = TextEditingController(
      text: context.read<BartStateProvider>().userProfile.userName,
    );
    _isEditingName = false;
    _nameFocusNode = FocusNode();
    _nameController = TextEditingController(
      text: context.read<BartStateProvider>().userProfile.fullName,
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userNameFocusNode.dispose();
    super.dispose();
  }

  void editUserName(BartStateProvider stateProvider, String userName) {
    closeKeyboard1();
    // check if the username is updated at all
    if (userName == stateProvider.userProfile.userName) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
          appearOnTop: true,
          message: context.tr('profile.page.username.unchanged'),
          backgroundColor: Colors.amber,
          icon: Icons.info,
        ).build(context),
      );
      return;
    }
    // if not, check if the username exists in the database
    stateProvider.doesUserNameExist(userName).then((value) {
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          BartSnackBar(
            appearOnTop: true,
            message: context.tr('profile.page.username.exists'),
            backgroundColor: Colors.red,
            icon: Icons.error,
          ).build(context),
        );
        _userNameController.text = stateProvider.userProfile.userName;
        return;
      } else {
        stateProvider.updateUserName(userName).then(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                BartSnackBar(
                  appearOnTop: true,
                  message: context.tr('profile.page.username.updated'),
                  backgroundColor: Colors.green,
                  icon: Icons.check,
                ).build(context),
              ),
            );
      }
    });
  }

  void editFullName(BartStateProvider stateProvider, String fullName) {
    closeKeyboard2();
    // check if the username is updated at all
    if (fullName == stateProvider.userProfile.fullName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const BartSnackBar(
          appearOnTop: true,
          // message: context.tr('profile.page.username.unchanged'),
          message: "Name is unchanged",
          backgroundColor: Colors.amber,
          icon: Icons.info,
        ).build(context),
      );
      return;
    }
    // if not, check if the username exists in the database
    stateProvider.doesFullNameExist(fullName).then(
      (value) {
        if (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const BartSnackBar(
              appearOnTop: true,
              // message: context.tr('profile.page.username.exists'),
              message: 'Name already exists',
              backgroundColor: Colors.red,
              icon: Icons.error,
            ).build(context),
          );
          _nameController.text = stateProvider.userProfile.fullName;
          return;
        } else {
          stateProvider.updateFullName(fullName).then(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                  const BartSnackBar(
                    appearOnTop: true,
                    // message: context.tr('profile.page.username.updated'),
                    message: 'Name updated',
                    backgroundColor: Colors.green,
                    icon: Icons.check,
                  ).build(context),
                ),
              );
        }
      },
    );

    _nameFocusNode.unfocus();
    Future.delayed(
      100.ms,
      () => setState(() => _isEditingName = false),
    );
    return;
  }

  // open the keyboard for the username text field
  void openKeyboard1() {
    setState(() => _isEditingUserName = true);
    Future.delayed(
      400.ms,
      () => FocusScope.of(context).requestFocus(_userNameFocusNode),
    );
  }

  // open the keyboard for the name text field
  void openKeyboard2() {
    setState(() => _isEditingName = true);
    Future.delayed(
      400.ms,
      () => FocusScope.of(context).requestFocus(_nameFocusNode),
    );
  }

  void closeKeyboard1() {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(
      100.ms,
      () => setState(() => _isEditingUserName = false),
    );
  }

  void closeKeyboard2() {
    FocusManager.instance.primaryFocus?.unfocus();
    Future.delayed(
      100.ms,
      () => setState(() => _isEditingName = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileStyle =
        Theme.of(context).extension<BartProfilePageColourStyle>()!;

    final loadingOverlay = LoadingBlockFullScreen(
      context: context,
      dismissable: false,
    );

    final stateProvider = Provider.of<BartStateProvider>(context, listen: true);

    final providerList = stateProvider.user == null
        ? [
            const BartTextShimmer(textHeight: 10, textLength: 150),
          ]
        : stateProvider.user!.providerData
            .map(
              (userInfo) => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  userInfo.providerId == 'google.com'
                      ? Image.asset(
                          "assets/icons/logo_google_96x96.png",
                          height: 25.h,
                          width: 25.w,
                        )
                      : Container(),
                  SizedBox(width: 10.w),
                  Text(
                    userInfo.providerId,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 16.spMin,
                        ),
                  ),
                ],
              ),
            )
            .toList();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Future.delayed(
          100.ms,
          () {
            setState(() {
              _isEditingUserName = false;
              _isEditingName = false;
            });
          },
        );
      },
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                stops: const [0.01, 0.3],
                colors: [
                  profileStyle.gradientColourTop,
                  profileStyle.gradientColourBottom,
                ],
              ),
            ),
            child: Stack(
              children: [
                // information container
                Container(
                  margin: const EdgeInsets.only(top: 120.0),
                  height: MediaQuery.of(context).size.height - 220,
                  padding: EdgeInsets.only(
                    top: 95.h,
                    left: 20.w,
                    right: 20.w,
                    bottom: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: profileStyle.containerColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: profileStyle.profileInfoCardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            context.tr('profile.page.profile.info.header'),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 25.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          context.tr('profile.page.profile.username'),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 15.spMin,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 18,
                              child: TextField(
                                maxLines: 1,
                                minLines: 1,
                                enabled: _isEditingUserName,
                                focusNode: _userNameFocusNode,
                                controller: _userNameController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 18.spMin,
                                    ),
                                decoration: InputDecoration(
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  fillColor: _isEditingUserName
                                      ? profileStyle.containerColor
                                      : Colors.transparent,
                                ),
                                onTap: _isEditingUserName ? null : null,
                                onEditingComplete: () => editUserName(
                                  stateProvider,
                                  _userNameController.text.trim(),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Expanded(
                              flex: 5,
                              child: _isEditingUserName
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => editUserName(
                                        stateProvider,
                                        _userNameController.text.trim(),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: openKeyboard1,
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.tr('profile.page.profile.name'),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 15.spMin,
                                  ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 18,
                              child: TextField(
                                maxLines: 1,
                                minLines: 1,
                                enabled: _isEditingName,
                                focusNode: _nameFocusNode,
                                controller: _nameController,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 18.spMin,
                                    ),
                                decoration: InputDecoration(
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  fillColor: _isEditingName
                                      ? profileStyle.containerColor
                                      : Colors.transparent,
                                ),
                                onTap: _isEditingName ? null : null,
                                onEditingComplete: () => editFullName(
                                  stateProvider,
                                  _nameController.text.trim(),
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Expanded(
                              flex: 5,
                              child: _isEditingName
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      onPressed: () => editFullName(
                                        stateProvider,
                                        _nameController.text.trim(),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: openKeyboard2,
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.tr('profile.page.profile.email'),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    fontSize: 15.spMin,
                                  ),
                        ),
                        SizedBox(height: 2.h),
                        stateProvider.user == null
                            ? BartTextShimmer(
                                textHeight: 10,
                                textLength: 100.sp,
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  left: 10,
                                ),
                                child: Text(
                                  stateProvider.user!.email == null
                                      ? '(Email not given by provider)'
                                      : stateProvider.user!.email!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                        const SizedBox(height: 5.0),
                        Divider(
                          color: profileStyle.textColor.withOpacity(0.1),
                        ),
                        const SizedBox(height: 10.0),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            context.tr('profile.page.account.type.header'),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  fontSize: 25.spMin,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, val) => providerList[val],
                          separatorBuilder: (context, val) =>
                              const SizedBox(height: 10),
                          itemCount: providerList.length,
                        ),
                        SizedBox(height: 18.h),
                        BartMaterialButton(
                          label: context.tr('profile.page.btn.logout'),
                          onPressed: () async {
                            loadingOverlay.show();
                            await stateProvider.signOut().then(
                              (value) {
                                if (value) {
                                  Future.delayed(
                                    const Duration(milliseconds: 2000),
                                    () {
                                      loadingOverlay.hide();
                                      context.go('/login');
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
                  ),
                ).animate().moveY(
                    begin: MediaQuery.of(context).size.height + 100,
                    end: 0.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                    delay: 400.ms),

                // profile image + username container
                Align(
                  alignment: Alignment.topCenter,
                  child: stateProvider.user == null
                      ? const ProfileInfoHeaderShimmer()
                      : StreamBuilder(
                          stream:
                              BartFirestoreServices.getCurrentUserProfileStream(
                            stateProvider.user!.uid,
                          ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const ProfileInfoHeaderShimmer();
                            }

                            return Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(top: 70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  // this should be a column with  [image, username]
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    cacheManager:
                                        BartImageTools.customCacheManager,
                                    cacheKey: 'profile_image',
                                    progressIndicatorBuilder:
                                        BartImageTools.progressLoader,
                                    imageUrl:
                                        stateProvider.userProfile.imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    stateProvider.userProfile.userName,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          fontSize: 20.sp,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ).animate().fadeIn(
                      duration: 400.ms,
                      curve: Curves.easeInOutCubic,
                      delay: 1600.ms,
                    ),
              ],
            ),
          ),
        ].animate().fadeIn(
              duration: 400.ms,
              curve: Curves.easeInOutCubic,
            ),
      ),
    );
  }
}
