import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bart_app/styles/bart_themes.dart';
import 'package:bart_app/common/entity/item.dart';
import 'package:bart_app/common/entity/trade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bart_app/common/widgets/bart_snackbar.dart';
import 'package:bart_app/common/providers/state_provider.dart';
import 'package:bart_app/common/utility/bart_storage_services.dart';
import 'package:bart_app/common/providers/temp_state_provider.dart';
import 'package:bart_app/common/utility/bart_firestore_services.dart';
import 'package:bart_app/common/widgets/input/image_upload_input.dart';
import 'package:bart_app/common/widgets/buttons/bart_material_button.dart';
import 'package:bart_app/common/widgets/input/item_description_input.dart';
import 'package:bart_app/common/widgets/overlays/login_loading_overlay.dart';

/// data entry form with shared fields used when posting a new item or a return offer
class NewItemPage extends StatefulWidget {
  const NewItemPage({
    super.key,
    this.isReturnOffer = false,
    this.returnForItem,
  });

  final bool isReturnOffer;
  final Item? returnForItem;

  @override
  State<NewItemPage> createState() => _NewItemPageState();
}

class _NewItemPageState extends State<NewItemPage> {
  late final bool _isReturnOffer;
  late final TextEditingController _nameTextController;
  late final TextEditingController _descriptionTextController;
  late final TextEditingController _returnsTextController;
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _descriptionTextController = TextEditingController();
    _nameTextController = TextEditingController();
    _returnsTextController = TextEditingController();
    _isReturnOffer = widget.isReturnOffer;
  }

  bool validateForm({
    String name = '',
    String description = '',
    List<String> imgList = const [],
  }) {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        BartSnackBar(
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
          message: tr('newItem.page.snackbar3'),
          backgroundColor: Colors.red,
          icon: Icons.error,
        ).build(context),
      );
      return false;
    }
    return true;
  }

  void returnOfferCallback(
    BartStateProvider stateProvider,
    TempStateProvider tempProvider,
  ) {
    final valid = validateForm(
      name: _nameTextController.text,
      description: _descriptionTextController.text,
      imgList: tempProvider.imagePaths,
    );
    if (!valid) return;
    // 0. Get the current timestamp using LocalTime.now()
    final timestamp = Timestamp.fromDate(DateTime.now());

    // 1. Get the imminent document IDs from the firestore collection
    final newItemID = BartFirestoreServices.getNextNewItemID();
    final newTradeID = BartFirestoreServices.getNextNewTradeID();

    final loadingOverlay = LoadingBlockFullScreen(
      context: _scaffoldKey.currentContext!,
      dismissable: false,
    );

    loadingOverlay.show();

    // 2. upload the images to the firebase storage, and get their links back
    BartFirebaseStorageServices.uploadItemImages(
      tempProvider.imagePaths,
      newItemID,
    ).then((imgList) {
      // 3. create a new Item object
      final newItem = Item(
        itemID: newItemID,
        itemOwner: stateProvider.userProfile,
        itemDescription: _descriptionTextController.text,
        itemName: _nameTextController.text,
        imgs: imgList,
        preferredInReturn: [],
        postedOn: timestamp,
        isListedInMarket: false,
      );
      // 4. add the item to the firestore collection
      BartFirestoreServices.addItem(
        newItem,
        newItemID,
      ).then((value) {
        // 5. create the new trade in the firestore collection
        final newTrade = Trade(
          tradeID: newTradeID,
          tradedItem: widget.returnForItem!,
          offeredItem: newItem,
          timeCreated: timestamp,
          timeUpdated: timestamp,
          isAccepted: false,
          isCompleted: false,
          isRead: false,
        );

        BartFirestoreServices.addTrade(
          newTrade,
        ).then((value) {
          loadingOverlay.hide();
          tempProvider.clearAllTempData();
          // ADD THE OBJECT DEFINITION FOR THE TRADE RESULT PAGE
          final Map<String, dynamic> obj = {
            'messageHeading': context.tr(
                'trade.result.message.title.heading.success'), // todo:_IMPLEMENT THE FAILED ONES ALSO!!
            'message': context.tr('trade.result.message.text.success'),
            'isSuccessful': true,
            'item1': widget.returnForItem,
            'item2': newItem,
            'dateCreated': newTrade.timeCreated,
          };
          context.push(
            '/item/${widget.returnForItem!.itemID}/returnItem/tradeResult',
            extra: obj,
          );
        });
      });
    });
  }

  void newItemCallback(
    BartStateProvider stateProvider,
    TempStateProvider tempProvider,
  ) async {
    final valid = validateForm(
      name: _nameTextController.text,
      description: _descriptionTextController.text,
      imgList: tempProvider.imagePaths,
    );
    if (!valid) return;
    // 0. Get the current timestamp using LocalTime.now()
    final timestamp = Timestamp.fromDate(DateTime.now());

    // 1. Get the imminent document ID from the firestore collection
    final docID = BartFirestoreServices.getNextNewItemID();

    final loadingOverlay = LoadingBlockFullScreen(
      context: _scaffoldKey.currentContext!,
      dismissable: false,
    );

    loadingOverlay.show();

    // 2. upload the images to the firebase storage, and get their links back
    BartFirebaseStorageServices.uploadItemImages(
      tempProvider.imagePaths,
      docID,
    ).then((imgList) async {
      // 3. create a new Item object
      final newItem = Item(
        itemID: docID,
        itemOwner: stateProvider.userProfile,
        itemDescription: _descriptionTextController.text,
        itemName: _nameTextController.text,
        imgs: imgList,
        preferredInReturn: _returnsTextController.text.isNotEmpty
            ? _returnsTextController.text.split(', ')
            : [],
        postedOn: timestamp,
      );

      // 4. add the item to the firestore collection
      await BartFirestoreServices.addItem(
        newItem,
        docID,
      ).then((value) {
        loadingOverlay.hide();
        tempProvider.clearAllTempData();
        final Map<String, dynamic> obj = {
          'messageHeading':
              context.tr('newItem.confirmation.title.heading.success'),
          'message': context.tr('newItem.confirmation.message.text.success'),
          'isSuccessful': true,
          'item': newItem,
          'dateCreated': newItem.postedOn,
        };
        context.push(
          '/home/newItem/newItemResult',
          extra: obj,
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionTextController.dispose();
    _nameTextController.dispose();
    _returnsTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BartStateProvider, TempStateProvider>(
      builder: (context, stateProvider, tempProvider, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          key: _scaffoldKey,
          body: SingleChildScrollView(
            padding: widget.isReturnOffer
                ? const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 30)
                : const EdgeInsets.only(
                    left: 10, right: 10, top: 30, bottom: 30),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('newItem.page.itemNameHeader'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: BartAppTheme.red1,
                          fontSize: 20,
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
                          fontSize: 20,
                        ),
                  ),
                  const BartImagePicker(),
                  const SizedBox(height: 10),
                  Text(
                    // "Provide a description of your item:",
                    context.tr('newItem.page.itemDescHeader'),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: BartAppTheme.red1,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 10),
                  DescriptionTextField(
                    textController: _descriptionTextController,
                  ),
                  const SizedBox(height: 10),

                  _isReturnOffer
                      ? const SizedBox(height: 0)
                      : Text(
                          context.tr("newItem.page.prefInReturnHeader"),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: BartAppTheme.red1,
                                    fontSize: 20,
                                  ),
                        ),
                  _isReturnOffer
                      ? const SizedBox(height: 0)
                      : Text(
                          context.tr('newItem.page.prefInReturnSub'),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: BartAppTheme.red1,
                                    fontSize: 10,
                                  ),
                        ),
                  _isReturnOffer
                      ? const SizedBox(height: 0)
                      : Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _returnsTextController,
                            maxLength: 500,
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText:
                                  context.tr('newItem.page.prefInReturnHint'),
                            ),
                          ),
                        ),
                  // const SizedBox(height: 10),
                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 75,
                      child: BartMaterialButton(
                        label: context.tr('newItem.page.btn.continue'),
                        onPressed: () => _isReturnOffer
                            ? returnOfferCallback(
                                stateProvider,
                                tempProvider,
                              )
                            : newItemCallback(
                                stateProvider,
                                tempProvider,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
