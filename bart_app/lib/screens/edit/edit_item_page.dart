import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/providers/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/image_upload_input.dart';
import 'package:bart_app/common/widgets/input/item_description_input.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({
    super.key,
    required this.tradedItem,
  });

  final Item tradedItem;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final TextEditingController _nameTextController;
  late final TextEditingController _descriptionTextController;
  late final TextEditingController _returnsTextController;
  bool _isBtnEnabled = true;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    final TempStateProvider tempProvider = Provider.of<TempStateProvider>(
      context,
      listen: false,
    );
    _descriptionTextController = TextEditingController(
      text: widget.tradedItem.itemDescription,
    );
    _nameTextController = TextEditingController(
      text: widget.tradedItem.itemName,
    );
    tempProvider.imagePaths = widget.tradedItem.imgs;
    final prefRetList = widget.tradedItem.preferredInReturn;
    final prefString = prefRetList != null ? prefRetList.join(', ') : '';
    _returnsTextController = TextEditingController(
      text: prefString,
    );
  }

  bool validateForm({
    String name = '',
    String description = '',
    List<String> imgList = const [],
  }) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
          // message: 'Please provide a name for your item',
          message: tr('newItem.page.snackbar1'),
          backgroundColor: Colors.red,
          icon: Icons.error,
        ).build(context),
      );
      return false;
    }
    if (imgList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
          // message: 'Please upload at least one image of your item',
          message: tr('newItem.page.snackbar2'),
          backgroundColor: Colors.red,
          icon: Icons.error,
        ).build(context),
      );
      return false;
    }
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
          // message: 'Please provide a description for your item',
          message: tr('newItem.page.snackbar3'),
          backgroundColor: Colors.red,
          icon: Icons.error,
        ).build(context),
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _descriptionTextController.dispose();
    _nameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadOverlay = LoadingBlockFullScreen(
      context: context,
      dismissable: false,
    );
    return Consumer2<BartStateProvider, TempStateProvider>(
      builder: (context, stateProvider, tempProvider, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 30,
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('newItem.page.itemNameHeader'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: BartAppTheme.red1,
                            fontSize: 20.spMin,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          hintText: context.tr('newItem.page.itemNameHint'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr('newItem.page.itemImagesHeader'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: BartAppTheme.red1,
                            fontSize: 20.spMin,
                          ),
                    ),
                    const BartImagePicker(),
                    const SizedBox(height: 10),
                    Text(
                      context.tr('newItem.page.itemDescHeader'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: BartAppTheme.red1,
                            fontSize: 20.spMin,
                          ),
                    ),
                    const SizedBox(height: 10),
                    DescriptionTextField(
                      textController: _descriptionTextController,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.tr("newItem.page.prefInReturnHeader"),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: BartAppTheme.red1,
                            fontSize: 20.spMin,
                          ),
                    ),
                    Text(
                      context.tr('newItem.page.prefInReturnSub'),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: BartAppTheme.red1,
                            fontSize: 10.spMin,
                          ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _returnsTextController,
                        maxLength: 500,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: context.tr('newItem.page.prefInReturnHint'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 75,
                        child: BartMaterialButton(
                          label: context.tr('edit.trade.page.btn.confirm'),
                          isEnabled: _isBtnEnabled,
                          onPressed: () {
                            setState(() => _isBtnEnabled = false);
                            final isFormValid = validateForm(
                              name: _nameTextController.text,
                              description: _descriptionTextController.text,
                              imgList: tempProvider.imagePaths,
                            );
                            if (!isFormValid) return;
                            loadOverlay.show();
                            final editedTradedItem = widget.tradedItem.copyWith(
                              itemName: _nameTextController.text,
                              itemDescription: _descriptionTextController.text,
                              imgs: tempProvider.imagePaths,
                              preferredInReturn:
                                  _returnsTextController.text.split(", "),
                            );

                            BartFirestoreServices.saveEditItemPostingChanges(
                              editedTradedItem,
                            ).then(
                              (result) {
                                loadOverlay.hide();
                                setState(() => _isBtnEnabled = true);
                                if (result) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    BartSnackBar(
                                      message: tr(
                                        'edit.item.confirm.success.snackbar',
                                      ),
                                      backgroundColor: Colors.green,
                                      icon: Icons.error,
                                    ).build(context),
                                  );
                                  tempProvider.clearAllTempData();
                                  context.pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    BartSnackBar(
                                      message: tr(
                                          'edit.item.confirm.error.snackbar'),
                                      backgroundColor: Colors.red,
                                      icon: Icons.error,
                                    ).build(context),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
